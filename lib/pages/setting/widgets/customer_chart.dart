import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 客户模块 - 圆饼图
class CustomerChart extends StatelessWidget {
  const CustomerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 30,
          sections: [
            PieChartSectionData(
              value: 40,
              title: '40%',
              color: Colors.blue,
              radius: 25,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 30,
              title: '30%',
              color: Colors.purple,
              radius: 25,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 20,
              title: '20%',
              color: Colors.orange,
              radius: 25,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 10,
              title: '10%',
              color: Colors.teal,
              radius: 25,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

