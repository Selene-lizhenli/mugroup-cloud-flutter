import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// - icon 随主题切换颜色的icon
/// - 默认颜色跟随主题
/// - 大小默认26
/// - 支持自定义大小 [iconSize]
/// - 支持自定义点击事件 [onPressed]
/// - 支持自定义提示 [tooltip]
/// - 支持自定义图标类型 [iconType]
/// - 支持自定义图标大小 [iconSize]
class MuIcon extends ConsumerWidget {
  final double? iconSize;
  final void Function()? onPressed;
  final String iconType;
  final String? tooltip;

  const MuIcon({
    super.key,
    this.iconSize = 26,
    this.onPressed,
    required this.iconType,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return onPressed == null
        ? Image.asset(
            'assets/icons/$iconType.png',
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          )
        : IconButton(
            icon: Image.asset(
              'assets/icons/$iconType.png',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            onPressed: onPressed,
            tooltip: tooltip,
          );
  }
}
