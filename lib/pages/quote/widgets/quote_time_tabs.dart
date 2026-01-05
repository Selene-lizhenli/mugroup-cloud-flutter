import 'package:flutter/material.dart';

class QuoteTimeTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  // 是否高亮时间选择器（比如当前是“自定义时间”状态）
  final bool isCalendarSelected;

  /// 点击时间选择器的回调（外部弹出日期选择）
  final VoidCallback? onCalendarTap;

  const QuoteTimeTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    this.isCalendarSelected = false,
    this.onCalendarTap,
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
        children: [
          // 时间范围标签
          ...List.generate(_tabs.length, (index) {
            // 当 currentIndex 为 -1 时，表示没有任何 tab 被选中
            final selected = currentIndex >= 0 && index == currentIndex;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_tabs[index]),
                selected: selected,
                onSelected: (_) => onChanged(index),
                showCheckmark: false, // RawChip 支持直接隐藏勾
                selectedColor: colorScheme.primary,
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 5), // 缩小内部 padding
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

          // 日历选择按钮（参考 inspection_view.dart 208-236）
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onCalendarTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isCalendarSelected
                    ? colorScheme.primary.withOpacity(0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: isCalendarSelected
                    ? colorScheme.primary
                    : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
