import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 供应商模块 - 折线图
class SupplierChart extends StatelessWidget {
  const SupplierChart({super.key});

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
          maxY: 15,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 5.5),
                FlSpot(1, 7.2),
                FlSpot(2, 8.1),
                FlSpot(3, 9.5),
                FlSpot(4, 11.2),
                FlSpot(5, 12.8),
                FlSpot(6, 13.5),
                FlSpot(7, 14.2),
              ],
              isCurved: true,
              colors: [Colors.purple],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.purple.withOpacity(0.1)],
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

