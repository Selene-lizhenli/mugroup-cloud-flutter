import 'package:cloud/pages/dashboard/widgets/modules/common_line_chart.dart';
import 'package:flutter/material.dart';

/// 客户模块 - 折线图
class CustomerChart extends StatelessWidget {
  const CustomerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleLineChart(
      moduleId: 'customer', 
      height: 200,
      emptyDataHeight: 100, 
      isCurved: false, 
    );
  }
}

