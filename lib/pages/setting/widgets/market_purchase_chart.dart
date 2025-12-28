import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 市场采购模块 - 折线图
class MarketPurchaseChart extends StatelessWidget {
  const MarketPurchaseChart({super.key});

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
          maxY: 10,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 4.2),
                FlSpot(1, 5.1),
                FlSpot(2, 6.3),
                FlSpot(3, 5.8),
                FlSpot(4, 7.2),
                FlSpot(5, 6.9),
                FlSpot(6, 8.1),
                FlSpot(7, 7.5),
              ],
              isCurved: true,
              colors: [Colors.blueAccent],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.blueAccent.withOpacity(0.1)],
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

