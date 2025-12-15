import 'package:flutter/material.dart';

class QuoteTimeTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const QuoteTimeTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  static const _tabs = [
    '全部',
    '近一个月',
    '近三个月',
    '近六个月',
    '近一年',
  ];

//  quote_at=2025-12-15+06:07:07,2025-12-15+22:00:00

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final selected = index == currentIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_tabs[index]),
              selected: selected,
              onSelected: (_) => onChanged(index),
              showCheckmark: false, //RawChip 支持直接隐藏勾
              selectedColor: colorScheme.primary,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 2), // 缩小内部 padding
              side: BorderSide(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant, // 边框颜色
                width: 1, // 边框粗细
              ),
              labelStyle: TextStyle(
                fontSize: 11,
                color: selected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }),
      ),
    );
  }
}
