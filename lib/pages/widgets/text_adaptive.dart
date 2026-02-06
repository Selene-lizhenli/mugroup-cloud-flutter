import 'package:flutter/material.dart';

/// 自适应文本，根据内容长度进行缩放。
/// 
/// 根据文本是否超过 1 行，自动在两种字号间切换。
///
/// - 超过 1 行：使用 [smallFontSize]
/// - 不超过 1 行：使用 [baseFontSize]
///
/// 常用于 AppBar 标题：保证长标题时更紧凑，但仍允许最多 [maxLines] 行。
/// 
/// 使用示例：
/// 
/// AdaptiveTitleText(
///   title: '这是一个很长的标题，需要自适应',
///   maxLines: 2,
///   baseFontSize: 17,
///   smallFontSize: 14,
/// ),
/// 
class AdaptiveTitleText extends StatelessWidget {
  const AdaptiveTitleText({
    super.key,
    required this.title,
    this.maxLines = 2,
    this.baseFontSize = 17,
    this.smallFontSize = 14,
  });

  final String title;
  final int maxLines;
  final double baseFontSize;
  final double smallFontSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final rawBaseStyle =
            theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge;

        final baseStyle =
            (rawBaseStyle ?? const TextStyle()).copyWith(fontSize: baseFontSize);
        final smallStyle = baseStyle.copyWith(fontSize: smallFontSize);

        final painter = TextPainter(
          text: TextSpan(text: title, style: baseStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
          ellipsis: '…',
        )..layout(maxWidth: constraints.maxWidth);

        final useSmall = painter.didExceedMaxLines;

        return Text(
          title,
          style: useSmall ? smallStyle : baseStyle,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

