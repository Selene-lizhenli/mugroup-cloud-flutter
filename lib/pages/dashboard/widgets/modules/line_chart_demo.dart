import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartDemo extends StatelessWidget {
  const LineChartDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
          ),
          minY: 2.6,
          borderData: FlBorderData(
              show: false, border: Border.all(color: Colors.black, width: 1)),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3.5),
                FlSpot(1, 3.1),
                FlSpot(2, 3.3),
                FlSpot(3, 2.9),
                FlSpot(4, 3.1),
                FlSpot(5, 3.3),
                FlSpot(6, 3.2),
                FlSpot(7, 3.1),
              ],
              isCurved: false,
              colors: [colorScheme.secondary.withOpacity(0.6)],
              belowBarData: BarAreaData(
                  show: true, colors: [colorScheme.secondary.withOpacity(0.1)]),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
