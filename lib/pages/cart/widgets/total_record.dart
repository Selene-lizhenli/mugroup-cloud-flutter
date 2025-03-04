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
  final Transfer? transfer;

  const TotalRecord(
      {super.key,
      this.items,
      this.cart,
      this.warehouse,
      this.borrow,
      this.transfer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<CartType, String> buttonText = {
      CartType.borrowOut: "借样",
      CartType.borrowIn: "还样",
      CartType.transferIn: "调拨",
      CartType.transferOut: "调拨",
      CartType.inout: "盘点"
    };
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              "确认借样",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "借样人",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedUser = await context.router
                        .push<User>(const SelectUserRoute());
                    user.value = selectedUser;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.value == null
                                ? "请选择用户"
                                : "${user.value!.name} (${user.value!.department?.name ?? '暂无部门'})",
                            style: TextStyle(
                              fontSize: 16,
                              color: user.value == null
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey), // 添加右侧箭头
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "备注",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarkController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "请输入备注",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (user.value == null) {
                    EasyLoading.showInfo("请先选择用户!");
                    return;
                  }
                  final productData = items
                      ?.map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count,
                          })
                      .toList();
                  final data = {
                    "borrower_id": user.value!.id,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
                  if (cart?.type == CartType.borrowOut) {
                    if (warehouse == null) {
                      EasyLoading.showInfo("请先选择仓库!");
                      return;
                    }
                    borrowDialog(context);
                  }

                  final productData = items
                      ?.map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count
                          })
                      .toList();

                  // 还样
                  if (cart?.type == CartType.borrowIn) {
                    if (borrow == null) {
                      EasyLoading.showInfo("请先选择借样单!");
                      return;
                    }
                    try {
                      EasyLoading.show(status: '加载中...');
                      final data = {"return_items": productData};
                      await borrowIn(borrow!.id!, data);
                      EasyLoading.showSuccess("还样成功!");
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }

                  // 调拨出库
                  if (cart?.type == CartType.transferOut) {
                    try {
                      EasyLoading.show(status: '加载中...');
                      final data = {"items": productData};
                      await addTransferItems(transfer!.id!, data);
                      EasyLoading.showSuccess("调拨出库成功!");
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }

                  // 调拨入库
                  if (cart?.type == CartType.transferIn) {
                    try {
                      EasyLoading.show(status: '加载中...');
                      final data = {"items": productData};
                      await transferIn(transfer!.id!, data);
                      EasyLoading.showSuccess("调拨入库成功!");
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
                  buttonText[cart?.type] ?? "确认",
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
