import 'package:flutter/material.dart';

/// 时间范围枚举（最近一年、最近半年、最近一个月）
enum ShipDateRange {
  lastYear,
  lastHalfYear,
  lastThreeMonths,
  lastMonth,
}

/// 将时间范围转为 API 所需的 start/end 参数（YYYY-MM-DD）
Map<String, String> shipDateRangeToParams(ShipDateRange range) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month, now.day);
  late DateTime start;
  switch (range) {
    case ShipDateRange.lastYear:
      start = DateTime(now.year - 1, now.month, now.day);
      break;
      case ShipDateRange.lastHalfYear:
        start = DateTime(now.year, now.month - 6, now.day);
        break;
    case ShipDateRange.lastThreeMonths:
      start = DateTime(now.year, now.month - 3, now.day);
      break;
    case ShipDateRange.lastMonth:
      start = DateTime(now.year, now.month - 1, now.day);
      break;
  }
  String format(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  return {'start': format(start), 'end': format(end)};
}

/// 可复用的时间范围选择器：最近一年、最近半年、最近一个月
class TimeRangeSelect extends StatelessWidget {
  final ShipDateRange selectedRange;
  final ValueChanged<ShipDateRange>? onRangeChanged;
  final EdgeInsetsGeometry? padding;

  const TimeRangeSelect({
    super.key,
    required this.selectedRange,
    this.onRangeChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RangeChip(
            label: '最近一年',
            isSelected: selectedRange == ShipDateRange.lastYear,
            onTap: () => onRangeChanged?.call(ShipDateRange.lastYear),
          ), 
          _RangeChip(
            label: '最近半年',
            isSelected: selectedRange == ShipDateRange.lastHalfYear,
            onTap: () => onRangeChanged?.call(ShipDateRange.lastHalfYear),
          ), 
            _RangeChip(
            label: '最近三个月',
            isSelected: selectedRange == ShipDateRange.lastThreeMonths,
            onTap: () => onRangeChanged?.call(ShipDateRange.lastThreeMonths),
          ),  
          _RangeChip(
            label: '最近一个月',
            isSelected: selectedRange == ShipDateRange.lastMonth,
            onTap: () => onRangeChanged?.call(ShipDateRange.lastMonth),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isSelected
          ? colorScheme.outline.withOpacity(0.2)
          : colorScheme.outline.withOpacity(0),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.72),
            ),
          ),
        ),
      ),
    );
  }
}
