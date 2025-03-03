import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TotalRecord extends HookConsumerWidget {
  final List<CartItem>? items;
  final Cart? cart;
  final Warehouse? warehouse;
  final Borrow? borrow;

  const TotalRecord(
      {super.key, this.items, this.cart, this.warehouse, this.borrow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double totalPrice = items?.fold(0.0, (previousValue, item) {
          // 尝试将 purchaseCost 从 String 转换为 double
          double cost = double.tryParse(item.sample.purchaseCost ?? '0') ?? 0.0;
          return previousValue! + (cost * item.count);
        }) ??
        0.0;

    int totalCount = items?.fold(0, (previousValue, item) {
          return previousValue! + item.count;
        }) ??
        0;

    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Text("已选: $totalCount 件"),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("合计: "),
                          const Text(
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400),
                              '¥'),
                          Text(
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                              totalPrice.toStringAsFixed(2))
                        ],
                      ),
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () async {
                  final productData = items
                      ?.map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count
                          })
                      .toList();
                  EasyLoading.show(status: '加载中...');
                  try {
                    if (cart?.type == CartType.borrowIn) {
                      if (borrow == null) {
                        EasyLoading.showInfo("请先选择借样单!");
                        return;
                      }
                      final data = {
                        "remark": "备注",
                        "return_items": productData
                      };
                      await borrowIn(borrow!.id!, data);
                      EasyLoading.showSuccess("还样成功!");
                    }
                    if (cart?.type == CartType.borrow) {
                      if (warehouse == null) {
                        EasyLoading.showInfo("请先选择仓库!");
                        return;
                      }
                      final data = {
                        "borrower_id": 2, // 借样人ID
                        "warehouse_id": warehouse!.id!,
                        "remark": "备注",
                        "products": productData
                      };
                      await storeBorrow(data);
                      EasyLoading.showSuccess("借样成功!");
                    }
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // 设置按钮文字颜色
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // 设置内边距
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // 设置按钮圆角
                  ),
                  elevation: 5, // 设置按钮的阴影效果
                ),
                child: Text(
                  cart?.type == CartType.borrowIn ? "还样" : "借样",
                  style: const TextStyle(
                    fontSize: 16.0, // 设置字体大小
                    fontWeight: FontWeight.bold, // 设置字体粗细
                  ),
                )),
          )
        ],
      ),
    );
  }
}
