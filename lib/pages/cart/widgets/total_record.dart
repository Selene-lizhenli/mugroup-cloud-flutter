import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final user = useState<User?>(null);
    final remarkController = useTextEditingController();
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

    void borrowDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        "确认",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("借样人:"),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final selectedUser = await context.router
                                  .push<User>(const SelectUserRoute());

                              user.value = selectedUser;
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(user.value == null
                                  ? "请选择用户"
                                  : "${user.value!.name} (${user.value!.department?.name ?? '暂无部门'})"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("备注:"),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: remarkController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("取消"),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (user.value == null) {
                                EasyLoading.showInfo("请先选择用户!");
                                return;
                              }
                              final productData = items
                                  ?.map((item) => {
                                        "product_id": item.sample.id,
                                        "inout_qty": item.count
                                      })
                                  .toList();
                              final data = {
                                "borrower_id": user.value!.id, // 借样人ID
                                "warehouse_id": warehouse!.id,
                                "remark": remarkController.text,
                                "products": productData
                              };
                              try {
                                EasyLoading.show(status: '加载中...');
                                await storeBorrow(data);
                                EasyLoading.showSuccess("借样成功!");
                                user.value = null;
                                remarkController.clear();
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } finally {
                                EasyLoading.dismiss();
                              }
                            },
                            child: const Text("提交"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
                  // 借样
                  if (cart?.type == CartType.borrow) {
                    if (warehouse == null) {
                      EasyLoading.showInfo("请先选择仓库!");
                      return;
                    }
                    borrowDialog(context);
                  }

                  // 还样
                  if (cart?.type == CartType.borrowIn) {
                    if (borrow == null) {
                      EasyLoading.showInfo("请先选择借样单!");
                      return;
                    }
                    final productData = items
                        ?.map((item) => {
                              "product_id": item.sample.id,
                              "inout_qty": item.count
                            })
                        .toList();
                    try {
                      EasyLoading.show(status: '加载中...');
                      final data = {"return_items": productData};
                      await borrowIn(borrow!.id!, data);
                      EasyLoading.showSuccess("还样成功!");
                    } finally {
                      EasyLoading.dismiss();
                    }
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
