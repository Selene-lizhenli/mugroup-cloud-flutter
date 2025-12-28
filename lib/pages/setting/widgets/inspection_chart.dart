import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 验货模块 - 折线图
class InspectionChart extends StatelessWidget {
  const InspectionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
          ),
          minY: 0,
          maxY: 12,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3.5),
                FlSpot(1, 5.2),
                FlSpot(2, 4.8),
                FlSpot(3, 6.5),
                FlSpot(4, 7.8),
                FlSpot(5, 9.2),
                FlSpot(6, 8.5),
                FlSpot(7, 10.1),
              ],
              isCurved: true,
              colors: [Colors.green],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.green.withOpacity(0.1)],
              ),
              dotData: FlDotData(show: false),
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

