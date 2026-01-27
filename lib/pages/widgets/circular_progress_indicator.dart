import 'package:flutter/material.dart';

/// 自定义跳动柱状图加载动画
/// UI：primary和secondary两种颜色的长条柱子，一共5根
/// 中间的柱子最长，其他两边对称，均匀减少长度
/// 动画效果：柱子依次跳动
///
/// 使用示例：
/// ```dart
/// // 基本使用
/// MuProgressIndicator()
///
/// // 自定义参数
/// MuProgressIndicator(
///   duration: const Duration(milliseconds: 1000),
///   barWidth: 8.0,
///   barSpacing: 3.0,
///   maxHeight: 40.0,
///   minHeightRatio: 0.2,
/// )
/// ```
class MuProgressIndicator extends StatefulWidget {
  /// 动画持续时间
  final Duration duration;

  /// 柱子宽度
  final double barWidth;

  /// 柱子间距
  final double barSpacing;

  /// 最大高度
  final double maxHeight;

  /// 最小高度比例（相对于最大高度）
  final double minHeightRatio;

  /// 显示在动画下方的文字
  final String? text;

  /// 是否在动画下面显示文字
  final bool? showText;

  /// 文字颜色
  final Color? textColor;

  /// 文字的字体大小
  final double? fontSize;

  const MuProgressIndicator({
    super.key,
    this.duration = const Duration(milliseconds: 800),
    this.barWidth = 6.0,
    this.barSpacing = 2.0,
    this.maxHeight = 30.0,
    this.minHeightRatio = 0.3,
    this.text,
    this.showText,
    this.textColor,
    this.fontSize,
  });

  @override
  State<MuProgressIndicator> createState() => _MuProgressIndicatorState();
}

class _MuProgressIndicatorState extends State<MuProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    // 创建5个柱子的动画，每个柱子有不同的延迟
    _animations = List.generate(5, (index) {
      final delay = index * 0.15; // 每个柱子延迟0.15秒，依次跳动
      return Tween<double>(
        begin: widget.minHeightRatio,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, delay + 0.3, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final barWidth = widget.barWidth;
    final barSpacing = widget.barSpacing;
    final maxHeight = widget.maxHeight;
    final minHeightRatio = widget.minHeightRatio;
    final text = widget.text;
    final showText = widget.showText;
    final textColor = widget.textColor;
    final fontSize = widget.fontSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: maxHeight + 10, // 给一些额外的空间
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (index) {
              // 计算柱子高度比例：中间最高，两边对称递减
              // 高度比例：minHeightRatio, 0.6, 1.0, 0.6, minHeightRatio
              final heightRatios = [
                minHeightRatio,
                0.6,
                1.0,
                0.6,
                minHeightRatio
              ];
              final maxHeightCalc = maxHeight * heightRatios[index];

              // 颜色：primary和secondary交替
              final color =
                  index % 2 == 0 ? colorScheme.primary : colorScheme.secondary;

              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Container(
                    width: barWidth,
                    height: maxHeightCalc * _animations[index].value,
                    margin: EdgeInsets.symmetric(horizontal: barSpacing),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          BorderRadius.circular(barWidth / 2), // 圆角半径等于宽度的一半
                    ),
                  );
                },
              );
            }),
          ),
        ),
        if (showText == true)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              text ?? '加载中...',
              style: TextStyle(
                  fontSize: fontSize ?? 12.0,
                  color: textColor ?? colorScheme.onSurface),
            ),
          ),
      ],
    );
  }
}
