import 'package:cloud/pages/dashboard/widgets/modules/common_line_chart.dart';
import 'package:flutter/material.dart';

/// 供应商模块 - 折线图
class SupplierChart extends StatelessWidget {
  const SupplierChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleLineChart(
      moduleId: 'supplier', 
      height: 200,
      emptyDataHeight: 100,
      isCurved: false,  
    );
  }
}

