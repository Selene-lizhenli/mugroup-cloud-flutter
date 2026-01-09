import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/supply/supply_supplier_activity/supply_supplier_activity_page.dart';
import 'package:cloud/pages/supply/supply_supplier_cert/supply_supplier_cert_page.dart';
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_page.dart';
import 'package:cloud/pages/supply/supply_supplier_yanchang/supply_supplier_yanchang_page.dart';
import 'package:cloud/pages/supply/widgets/supply_supplier_form.dart';
import 'package:cloud/services/supply.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
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

    Widget buildTabText(String text, int index) {
      final isSelected = tab.value == index;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('供应商编辑')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: tab.value,
                  isStretch: false,
                  children: {
                    0: buildTabText("基本信息", 0),
                    1: buildTabText("联系人", 1),
                    2: buildTabText("证书", 2),
                    3: buildTabText("动态", 3),
                    4: buildTabText("验厂", 4),
                  },
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  innerPadding: const EdgeInsets.all(2),
                  duration: const Duration(milliseconds: 200),
                  onValueChanged: (v) => tab.value = v,
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: tab.value,
              children: [
                SupplySupplierForm(
                  initial: supplier.value,
                  onSubmit: (data) async {
                    await updateSupplySupplier(id, data);
                    EasyLoading.showSuccess("编辑成功");
                  },
                ),
                SupplySupplierContactPage(supplierId: id),
                SupplySupplierCertPage(supplierId: id),
                SupplySupplierActivityPage(supplierId: id),
                SupplySupplierYanchangPage(supplierId: id)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
