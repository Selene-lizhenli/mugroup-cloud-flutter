import 'package:cloud/pages/dashboard/widgets/modules/common_line_chart.dart';
import 'package:flutter/material.dart';

/// 验货模块 - 折线图
class InspectionChart extends StatelessWidget {
  const InspectionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleLineChart(
      moduleId: 'inspection', 
      height: 200,
      emptyDataHeight: 100,
      isCurved: true, 
    );
  }
}
