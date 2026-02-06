import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/selectors/select_product/widgets/product_list_sheet.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SelectProductPage extends StatelessWidget {
  final int? supplierId;
  final List<int>? initialSelectedIds;

  const SelectProductPage({
    super.key,
    @QueryParam() this.supplierId,
    this.initialSelectedIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductListSheet(
        supplierId: supplierId,
        initialSelectedIds: initialSelectedIds,
        onConfirm: (selectedProducts) {
          // 通过路由返回选中的产品列表
          context.router.maybePop(selectedProducts);
        },
      ),
    );
  }
}
