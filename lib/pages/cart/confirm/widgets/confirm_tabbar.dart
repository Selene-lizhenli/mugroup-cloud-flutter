import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmTabbar extends HookConsumerWidget {
  final Function()? onPressed;

  const ConfirmTabbar({super.key, this.onPressed});
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
                onPressed: onPressed,
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
