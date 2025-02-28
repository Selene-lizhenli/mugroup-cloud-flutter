import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TotalRecord extends HookConsumerWidget {
  final List<CartItem>? items;

  const TotalRecord({super.key, this.items});

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
                        children: [
                          Text("已选: $totalCount 件"),
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              const Text("合计: "),
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
                      ),
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () async {
                  final productData = items
                      ?.map((item) =>
                          {"model_id": item.sample.id, "inout_qty": item.count})
                      .toList();
                  final data = {
                    "borrower_id": 2, // 借样人ID
                    "warehouse_id": 1, // 仓库ID
                    "remark": "备注",
                    "products": productData
                  };
                  // 生成报价单
                  await api.post("api/tenant/wms/stock/borrows", data: data);
                  logger.d(data);
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
                child: const Text(
                  '借样',
                  style: TextStyle(
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
