import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
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
    // 1. 增加刷新 Key，用于强制子组件重建
    final refreshKey = useState(0);

    // 2. 封装加载方法，支持手动刷新
    Future<void> loadData({bool isRefresh = false}) async {
      try {
        if (isRefresh) EasyLoading.show(status: '刷新中...');

        final resp = await getSupplier(id);
        supplier.value = resp;

        if (isRefresh) {
          refreshKey.value++; // 改变 Key，触发子页面 useEffect
          EasyLoading.showSuccess('刷新成功');
        }
      } catch (e) {
        if (isRefresh) EasyLoading.showError('刷新失败: $e');
      } finally {
        if (!isRefresh) isLoading.value = false;
      }
    }

    useEffect(() {
      loadData();
      return null;
    }, [id]);

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('供应商编辑')),
        body: Skeleton(
            isLoading: true, skeleton: SkeletonListView(), child: Container()),
      );
    }

    // 文字样式构建器（适配灰底白块风格：选中黑，未选中灰）
    Widget buildTabText(String text, int index) {
      final isSelected = tab.value == index;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 13, // 稍微调小一点字体防止5个字挤不下
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('供应商编辑'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // 3. 添加刷新按钮
          TextButton(
            onPressed: () => loadData(isRefresh: true),
            child: const Text(
              "刷新",
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
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
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: CustomSlidingSegmentedControl<int>(
                initialValue: tab.value,
                isStretch: true,
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
                      color: Colors.black12,
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
          Expanded(
            child: IndexedStack(
              index: tab.value,
              children: [
                /// 基本资料
                SupplySupplierForm(
                  key: ValueKey('info_${refreshKey.value}'),
                  initial: supplier.value,
                  onSubmit: (data) async {
                    if (data['images'] != null && data['images'] is List) {
                      data['images'] = (data['images'] as List).map((item) {
                        if (item is Map &&
                            !item.containsKey('collection_name')) {
                          item['collection_name'] = 'bussiness_card';
                        }
                        return item;
                      }).toList();
                    }
                    await updateSupplySupplier(id, data);
                    EasyLoading.showSuccess("编辑成功");
                  },
                ),

                SupplySupplierContactPage(
                  key: ValueKey('contact_${refreshKey.value}'),
                  supplierId: id,
                ),

                SupplySupplierCertPage(
                  key: ValueKey('cert_${refreshKey.value}'),
                  supplierId: id,
                ),

                SupplySupplierActivityPage(
                  key: ValueKey('activity_${refreshKey.value}'),
                  supplierId: id,
                ),

                SupplySupplierYanchangPage(
                  key: ValueKey('yanchang_${refreshKey.value}'),
                  supplierId: id,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
