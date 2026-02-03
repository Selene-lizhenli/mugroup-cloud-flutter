import 'package:flutter/material.dart';

/// 通用进度条：左侧为进度条，右侧为文字，同一行、上下居中、左右 spaceBetween。
class AppProgressBar extends StatelessWidget {
  /// 进度值 0.0 ~ 1.0
  final double progress;

  /// 右侧展示的文案（如 "3/10"）
  final String progressText;

  /// 进度条高度，默认 10
  final double height;

  /// 进度条圆角，默认 4
  final double borderRadius;

  /// 轨道（底色）颜色，为 null 时使用 theme.primary.withOpacity(0.2)
  final Color? trackColor;

  /// 已进度颜色，为 null 时使用 theme.primary
  final Color? valueColor;

  /// 右侧文字样式，为 null 时使用 theme.secondary、fontSize 10
  final TextStyle? textStyle;

  const AppProgressBar({
    super.key,
    required this.progress,
    required this.progressText,
    this.height = 10,
    this.borderRadius = 4,
    this.trackColor,
    this.valueColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveTrackColor = trackColor ?? colorScheme.primary.withOpacity(0.2);
    final effectiveValueColor = valueColor ?? colorScheme.primary;
    final effectiveTextStyle = textStyle ??
        TextStyle(
          color: colorScheme.secondary,
          fontSize: 10,
          height: 1,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: effectiveTrackColor,
              ),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double currentWidth =
                          constraints.maxWidth * progress.clamp(0.0, 1.0);
                      return Container(
                        width: currentWidth,
                        color: effectiveValueColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          progressText,
          style: effectiveTextStyle,
        ),
      ],
    );
  }
}
