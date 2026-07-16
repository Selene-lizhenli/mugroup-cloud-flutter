import 'package:cloud/pages/inspection/const.dart';
import 'package:flutter/material.dart';

/// 根据验货 SKU 状态值返回对应颜色
Color getStatusColor(int? status) {
  const statusColors = <int, Color>{
    0: Colors.grey,
    1: Colors.green,
    2: Colors.orange,
    3: Colors.red,
  };
  return statusColors[status] ?? Colors.grey;
}

/// 验货 SKU 状态标签（图标 + 文案），可在列表、抽屉等场景复用
class InspectionStatusTag extends StatelessWidget {
  const InspectionStatusTag({
    super.key,
    required this.status,
    this.needIcon,
    this.fontSize = 14,
  });

  final int? status;
  final bool? needIcon;
  final double? fontSize;

  static IconData _iconForStatus(int? status) {
    return switch (status) {
      1 => Icons.check_circle,
      2 => Icons.info,
      3 => Icons.cancel,
      _ => Icons.radio_button_unchecked,
    };
  }

  @override
  Widget build(BuildContext context) {
    final label =
        inspectionStatusLabelMap[status] ?? inspectionStatusPendingLabel;
    final color = getStatusColor(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (needIcon == true)
          Icon(
            _iconForStatus(status),
            size: 16,
            color: color,
          ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? 14,
            height: 1,
            fontWeight:
                (status ?? 0) != 0 ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
