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
    return Scaffold(
      appBar: AppBar(title: const Text('供应商创建')),
      body: SupplySupplierForm(
        initial: null,
        onSubmit: (data) async {
          await storeShowroomSupplier(data);
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
