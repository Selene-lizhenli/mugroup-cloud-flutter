import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 客户模块 - 折线图
class CustomerChart extends StatelessWidget {
  const CustomerChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例数据：时间轴标签（月份）
    final timeLabels = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月'];
    
    // 示例数据：客户数量
    final spots = [
      FlSpot(0, 42),
      FlSpot(1, 38),
      FlSpot(2, 45),
      FlSpot(3, 52),
      FlSpot(4, 48),
      FlSpot(5, 55),
      FlSpot(6, 58),
      FlSpot(7, 62),
    ];
    
    // 计算最大数量用于设置Y轴范围
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(0,30, 30,0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize:30,
              getTitles: (value) {
                // 纵轴：显示数量（整数）
                if (value % 10 == 0 && value >= 0) {
                  return value.toInt().toString();
                }
                return '';
              },
              getTextStyles: (value) => TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitles: (value) {
                // 横轴：显示时间标签
                final index = value.toInt();
                if (index >= 0 && index < timeLabels.length) {
                  return timeLabels[index];
                }
                return '';
              },
              getTextStyles: (value) => TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
          ),
          minY: 0,
          maxY: maxY,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              colors: [Colors.blue],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.blue.withOpacity(0.1)],
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

