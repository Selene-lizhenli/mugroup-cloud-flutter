import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 样品间模块 - 圆饼图
class SampleRoomChart extends StatelessWidget {
  const SampleRoomChart({super.key});

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
              value: 35,
              title: '35%',
              color: Colors.orange,
              radius: 25,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 25,
              title: '25%',
              color: Colors.green,
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
              color: Colors.blue,
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
              color: Colors.purple,
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

