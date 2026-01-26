import 'package:flutter/material.dart';

/// 可复用空态组件：空 icon + 文案，上下布局
///
/// - 支持自定义图片高度 [height]
/// - 支持自定义文案 [text] 或富文本 [textSpans]
/// - 支持自定义图标 [icon] / 图标大小 [iconSize]
/// - 默认颜色跟随主题 [Theme]/[ColorScheme]
class Empty extends StatelessWidget {
  final double picHeight;
  final double width;
  final String text;
  final List<InlineSpan>? textSpans;
  final IconData? icon;
  final double iconSize;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? padding;
  final double? height;
  final bool? showImage;
  final double? fontSize;

  const Empty({
    super.key,
    this.picHeight = 80,
    this.text = '暂无数据',
    this.textSpans,
    this.width = 62,
    this.icon,
    this.iconSize = 44,
    this.textStyle,
    this.iconColor,
    this.padding = 0,
    this.height,
    this.showImage = false,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.outline;
    final effectiveTextStyle =
        textStyle ?? TextStyle(color: colorScheme.outline, fontSize: fontSize);
    final effectivePadding = padding != null ? padding! * 2 : 120;

    return SizedBox(
      height: height ?? picHeight + effectivePadding,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
          ] else if (showImage == true) ...[
            Image.asset(
              'assets/element/empty.png',
              height: picHeight,
              fit: BoxFit.contain,
            ),
          ],
          const SizedBox(height: 10),
          if (textSpans != null) ...[
            SizedBox(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: textSpans,
                ),
              ),
            ),
          ] else ...[
            Text(
              text,
              textAlign: TextAlign.center,
              style: effectiveTextStyle,
            ),
          ],
        ],
      ),
    );
  }
}
