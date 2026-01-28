import 'package:flutter/material.dart';

/// 时间范围枚举（所有时间、最近一年、最近半年、最近一个月）
enum DateRange {
  allTime,
  lastYear,
  lastHalfYear, 
  lastMonth,
}

/// 将时间范围转为 API 所需的 start/end 参数（YYYY-MM-DD）
Map<String, String> trnasDateRangeToParams(DateRange range) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month, now.day);
  late DateTime start;
  switch (range) {
    case DateRange.lastYear:
      start = DateTime(now.year - 1, now.month, now.day);
      break;
    case DateRange.lastHalfYear:
      start = DateTime(now.year, now.month - 6, now.day);
      break;
    case DateRange.lastMonth:
      start = DateTime(now.year, now.month - 1, now.day);
      break;
    case DateRange.allTime:
      return {'start': '', 'end': ''};
  }
  String format(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  return {'start': format(start), 'end': format(end)};
}

/// 可复用的时间范围选择器：最近一年、最近半年、最近一个月
/// 选中的时间范围由组件内部 state 维护，通过 [onRangeChanged] 通知外部。
class TimeRangeSelect extends StatefulWidget {
  /// 初始选中的时间范围（仅用于首次展示，之后由内部 state 维护）
  final DateRange initialRange;
  final void Function(DateRange range, Map<String, String> params)?
      onRangeChanged;
  final EdgeInsetsGeometry? padding;

  const TimeRangeSelect({
    super.key,
    this.initialRange = DateRange.allTime,
    this.onRangeChanged,
    this.padding,
  });

  @override
  State<TimeRangeSelect> createState() => _TimeRangeSelectState();
}

class _TimeRangeSelectState extends State<TimeRangeSelect> {
  late DateRange _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  void _selectRange(DateRange range) {
    if (_selectedRange == range) return;
    setState(() => _selectedRange = range);
    widget.onRangeChanged?.call(range, trnasDateRangeToParams(range));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RangeChip(
            label: '所有时间',
            isSelected: _selectedRange == DateRange.allTime,
            onTap: () => _selectRange(DateRange.allTime),
          ),
          _RangeChip(
            label: '最近一年',
            isSelected: _selectedRange == DateRange.lastYear,
            onTap: () => _selectRange(DateRange.lastYear),
          ),
          _RangeChip(
            label: '最近半年',
            isSelected: _selectedRange == DateRange.lastHalfYear,
            onTap: () => _selectRange(DateRange.lastHalfYear),
          ), 
          _RangeChip(
            label: '最近一个月',
            isSelected: _selectedRange == DateRange.lastMonth,
            onTap: () => _selectRange(DateRange.lastMonth),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              height: 1,
              color: isSelected
                  ? colorScheme.onSurface.withOpacity(0.7)
                  : colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
