import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/inventory.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmTabbar extends HookConsumerWidget {
  final Inventory? inventory;

  const ConfirmTabbar({super.key, this.inventory});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
              child: Column(
            children: [Text('')],
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () async {
                  if (inventory != null) {
                    EasyLoading.show(status: '加载中...');
                    await confirmInventory(inventory!.id!);
                    EasyLoading.showSuccess("手动盘点成功!");
                  }
                  if (context.mounted) {
                    context.router.push(const CartRoute());
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
                child: const Text(
                  '确认',
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
