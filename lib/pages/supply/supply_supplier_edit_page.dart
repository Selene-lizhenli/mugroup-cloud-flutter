import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_page.dart';
import 'package:cloud/pages/supply/widgets/supply_supplier_form.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierEditPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierEditPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = useState<Supplier?>(null);
    final isLoading = useState(true);
    final tab = useState(0);

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
        appBar: AppBar(title: const Text('供应商编辑')),
        body: Skeleton(
            isLoading: true, skeleton: SkeletonListView(), child: Container()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('供应商编辑')),
      body: Column(
        children: [
          CustomSlidingSegmentedControl<int>(
            initialValue: tab.value,
            children: const {
              0: Text("基本信息"),
              1: Text("联系人"),
              2: Text("证书"),
              3: Text("动态"),
              4: Text("验厂"),
            },
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            onValueChanged: (v) => tab.value = v,
          ),
          Expanded(
            child: IndexedStack(
              index: tab.value,
              children: [
                /// 基本资料
                SupplySupplierForm(
                  initial: supplier.value,
                  onSubmit: (data) async {
                    await updateSupplySupplier(id, data);
                    EasyLoading.showSuccess("编辑成功");
                  },
                ),

                SupplySupplierContactPage(supplierId: id),

                /// 证书模块（例）
                Text('证书模块'),

                /// 动态模块（例）
                Text('动态模块'),

                /// 验厂模块（例）
                Text('验厂模块')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
