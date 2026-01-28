import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 显示最高点和最低点标签的 Widget
class MinMaxLabels extends StatelessWidget {
  final int maxIndex;
  final int minIndex;
  final double maxValue;
  final double minValue;
  final List<FlSpot> spots;
  final BoxConstraints constraints;
  final double minY;
  final double maxY;
  final double leftReservedSize;
  final double bottomReservedSize;

  const MinMaxLabels({
    super.key,
    required this.maxIndex,
    required this.minIndex,
    required this.maxValue,
    required this.minValue,
    required this.spots,
    required this.constraints,
    required this.minY,
    required this.maxY,
    required this.leftReservedSize,
    required this.bottomReservedSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (spots.isEmpty || spots.length == 1) return const SizedBox.shrink();

    final chartAreaWidth = constraints.maxWidth - leftReservedSize;
    final chartAreaHeight = constraints.maxHeight - bottomReservedSize;
    final xRange = spots.length > 1 ? spots.length - 1 : 1.0;
    final yRange = maxY - minY;

    // 计算最高点的位置
    final maxSpot = spots[maxIndex];
    final maxX = leftReservedSize + (maxSpot.x / xRange) * chartAreaWidth;
    final maxYPos =
        chartAreaHeight - ((maxSpot.y - minY) / yRange) * chartAreaHeight;

    // 计算最低点的位置
    final minSpot = spots[minIndex];
    final minX = leftReservedSize + (minSpot.x / xRange) * chartAreaWidth;
    final minYPos =
        chartAreaHeight - ((minSpot.y - minY) / yRange) * chartAreaHeight;

    // 标签文本
    final maxText = '最高: ${maxValue.toStringAsFixed(4)}';
    final minText = '最低: ${minValue.toStringAsFixed(4)}';

    // 使用 TextPainter 精确测量文本尺寸
    const textStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );
    final maxTextPainter = TextPainter(
      text: TextSpan(text: maxText, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    maxTextPainter.layout();

    final minTextPainter = TextPainter(
      text: TextSpan(text: minText, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    minTextPainter.layout();

    // 标签尺寸（考虑padding）
    const labelPadding = 12.0; // horizontal padding
    final maxLabelWidth = maxTextPainter.width + labelPadding;
    final maxLabelHeight = maxTextPainter.height + 6; // vertical padding
    final minLabelWidth = minTextPainter.width + labelPadding;
    final minLabelHeight = minTextPainter.height + 6;

    // 计算最高点标签位置（考虑边界）
    double maxLabelLeft = maxX - maxLabelWidth / 2;
    double maxLabelTop = maxYPos - 17;

    // 边界检查：左边界
    if (maxLabelLeft < 0) {
      maxLabelLeft = 4;
    }
    // 边界检查：右边界
    if (maxLabelLeft + maxLabelWidth > constraints.maxWidth) {
      maxLabelLeft = constraints.maxWidth - maxLabelWidth - 4;
    }
    // 边界检查：上边界
    if (maxLabelTop < 0) {
      maxLabelTop = maxYPos + 5; // 如果上方空间不足，显示在点下方
    }
    // 边界检查：下边界
    if (maxLabelTop + maxLabelHeight > constraints.maxHeight) {
      maxLabelTop = constraints.maxHeight - maxLabelHeight - 4;
    }

    // 计算最低点标签位置（考虑边界）
    double minLabelLeft = minX - minLabelWidth / 2;
    double minLabelTop = minYPos + 30; // 增加距离，让标签更靠下

    // 边界检查：左边界
    if (minLabelLeft < 0) {
      minLabelLeft = 4;
    }
    // 边界检查：右边界
    if (minLabelLeft + minLabelWidth > constraints.maxWidth) {
      minLabelLeft = constraints.maxWidth - minLabelWidth - 4;
    }
    // 边界检查：上边界
    if (minLabelTop < 0) {
      minLabelTop = 4;
    }
    // 边界检查：下边界
    if (minLabelTop + minLabelHeight > constraints.maxHeight) {
      minLabelTop = minYPos - minLabelHeight - 5; // 如果下方空间不足，显示在点上方
    }

    return Stack(
      children: [
        // 最高点标签
        Positioned(
          left: maxLabelLeft,
          top: maxLabelTop,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              maxText,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // 最低点标签
        Positioned(
          left: minLabelLeft,
          top: minLabelTop,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              minText,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
