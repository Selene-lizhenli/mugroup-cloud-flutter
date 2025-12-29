import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 供应商模块 - 折线图
class SupplierChart extends StatelessWidget {
  const SupplierChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 示例数据：时间轴标签（月份）
    final timeLabels = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月'];
    
    // 示例数据：供应商数量
    final spots = [
      FlSpot(0, 10150),
      FlSpot(1, 15000),
      FlSpot(2, 15008),
      FlSpot(3, 20000),
      FlSpot(4, 25066),
      FlSpot(5, 40000),
      FlSpot(6, 45580),
      FlSpot(7, 65608),
    ];
    
    // 计算最大数量用于设置Y轴范围
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2; 
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) * 0.8;
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitles: (value) {
                // 纵轴：显示数量（整数）
                if (value % 2 == 0 && value >= 0) {
                  return value.toInt().toString();
                }
                return '';
              },
              getTextStyles: (value) => TextStyle(
                fontSize: 10,
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
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
          ),
          minY: minY,
          maxY: maxY,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
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

