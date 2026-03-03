import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/supply/widgets/supply_supplier_form.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierCreatePage extends HookConsumerWidget {
  const SupplySupplierCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('供应商创建'),
        backgroundColor: colorScheme.surface,
      ),
      body: SupplySupplierForm(
        initial: null,
        onSubmit: (data) async {
          if (data['images'] != null && data['images'] is List) {
            data['images'] = (data['images'] as List).map((item) {
              if (item is Map && !item.containsKey('collection_name')) {
                item['collection_name'] = 'bussiness_card';
              }
              return item;
            }).toList();
          }
          await storeSupplySupplier({...data, 'item_type': "market"});
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
