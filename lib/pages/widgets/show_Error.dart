import 'package:flutter/material.dart';

/// 错误显示组件（带重试按钮）
class ShowError extends StatelessWidget {
  /// 错误消息
  final String errorMessage;

  /// 重试回调
  final VoidCallback onRetry;

  /// 容器高度
  final double? height;

  /// 容器内边距
  final EdgeInsetsGeometry? padding;

  /// 错误消息文字样式
  final TextStyle? errorTextStyle;

  /// 重试按钮文字样式
  final TextStyle? retryTextStyle;

  /// 重试按钮文字
  final String retryText;

  /// 是否使用重试逻辑
  final bool showRetryText;

  final double fontSize;

  const ShowError({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.height,
    this.padding,
    this.errorTextStyle,
    this.retryTextStyle,
    this.retryText = '重试',
    this.showRetryText = true,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height ?? 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: errorTextStyle ??
                TextStyle(
                  color: colorScheme.outline,
                  fontSize: fontSize,
                ),
          ),
          if (showRetryText) ...[
            TextButton(
              onPressed: onRetry,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    retryText,
                    style: retryTextStyle ??
                        TextStyle(
                          color: colorScheme.primary,
                          fontSize: fontSize,
                          height: 1,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.refresh,
                    size: fontSize + 2,
                    color: (retryTextStyle?.color) ?? colorScheme.primary,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
