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
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          const Text("全选"),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("12"),
                Text("2"),
              ],
            ),
          ),
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
