import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShowroomQuotationsOperateBar extends HookConsumerWidget {
  final void Function()? addCart;

  const ShowroomQuotationsOperateBar({super.key, this.addCart});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: addCart,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[700], // 设置背景颜色
                    foregroundColor: Colors.white, // 设置文字颜色
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16), // 设置内边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 圆角
                    ),
                  ),
                  child: const Text(
                    "添加进购物车",
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
