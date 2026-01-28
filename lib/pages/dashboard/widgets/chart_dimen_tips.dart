import 'package:flutter/material.dart';

/// 图表维度提示：小圆点 + 「xxx排行」文案，用于柱状图等右上角
class ChartDimenTips extends StatelessWidget {
  final String label;

  const ChartDimenTips({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 2, right: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 11, color: colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
