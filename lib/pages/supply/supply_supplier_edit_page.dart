import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/supply/widgets/supply_supplier_form.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierEditPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierEditPage({super.key, @pathParam required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = useState<Supplier?>(null);
    final isLoading = useState<bool>(true);
    useEffect(() {
      () async {
        try {
          final resp = await getSupplier(id);
          supplier.value = resp;
        } finally {
          isLoading.value = false;
        }
      }();
      return null;
    }, [id]);

    if (isLoading.value) {
      return Scaffold(
        body: Skeleton(
          isLoading: true,
          skeleton: SkeletonListView(),
          child: Container(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('供应商编辑')),
      body: SupplySupplierForm(
        initial: supplier.value,
        onSubmit: (data) async {
          await updateShowroomSupplier(id, data);
          EasyLoading.showSuccess("编辑成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
