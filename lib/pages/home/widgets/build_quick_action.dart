import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BuildQuickAction extends HookConsumerWidget {
  final IconData icon; // 图标
  final String title; // 文字
  final Color color;
  final String url;

  const BuildQuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.url,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Material(
          color: color.withOpacity(0.1), // 背景色
          shape: const CircleBorder(), // 圆形
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              // TODO: 点击逻辑
            },
            child: Padding(
              padding: const EdgeInsets.all(8), // 控制按钮大小
              child: Icon(icon, color: color, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
