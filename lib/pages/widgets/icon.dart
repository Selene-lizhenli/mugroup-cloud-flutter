import 'package:cloud/helper/helper.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// - icon
/// - 默认颜色跟随主题
/// - 大小默认26

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
    final themeType = ref.watch(appThemeProvider);
    final theme = themeType == ThemeType.pink ? 'pink' : 'blue';
    logger.d('iconSize$iconSize');
    return onPressed == null
        ? Image.asset(
            'assets/mu/${iconType}_$theme.png',
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          )
        : IconButton(
            icon: Image.asset(
              'assets/mu/${iconType}_$theme.png',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            onPressed: onPressed,
            tooltip: tooltip,
          );
  }
}
