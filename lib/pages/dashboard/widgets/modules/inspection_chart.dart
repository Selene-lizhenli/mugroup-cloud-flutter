import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 验货模块 - 折线图
class InspectionChart extends ConsumerStatefulWidget {
  const InspectionChart({super.key});

  @override
  ConsumerState<InspectionChart> createState() => _InspectionChartState();
}

class _InspectionChartState extends ConsumerState<InspectionChart> {
  bool _hasLoaded = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(dashboardStatsProvider);
    
    // 初始化时加载数据（仅在首次且未加载时）
    if (!_hasLoaded && !stats.isLoading && stats.timeLabels.isEmpty) {
      _hasLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(dashboardStatsProvider.notifier).load();
        }
      });
    }

    // 显示加载状态
    if (stats.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final timeLabels = stats.timeLabels;
    final inspectionData = stats.inspectionData;

        if (inspectionData.isEmpty) {
          return Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('暂无数据'),
            ),
          );
        }

        // 将验货任务数量转换为 FlSpot
        final spots = inspectionData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.toDouble());
        }).toList();

        // 计算最大数量用于设置Y轴范围
        final maxY = inspectionData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;

        return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitles: (value) {
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

