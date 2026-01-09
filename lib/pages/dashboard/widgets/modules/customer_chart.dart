import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 客户模块 - 折线图
class CustomerChart extends ConsumerStatefulWidget {
  const CustomerChart({super.key});

  @override
  ConsumerState<CustomerChart> createState() => _CustomerChartState();
}

class _CustomerChartState extends ConsumerState<CustomerChart> {
  bool _hasLoaded = false;
  static const String _moduleId = 'customer';

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(moduleStatsProvider(_moduleId));
    
    // 初始化时加载数据（仅在首次且未加载时）
    if (!_hasLoaded && !stats.isLoading && stats.timeLabels.isEmpty) {
      _hasLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(moduleStatsProvider(_moduleId).notifier).load();
        }
      });
    }

    // 显示加载状态
    if (stats.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 150,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final timeLabels = stats.timeLabels;
    final customerData = stats.data;

        if (customerData.isEmpty) {
          return Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('暂无数据'),
            ),
          );
        }

        // 将客户数量转换为 FlSpot
        final spots = customerData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.toDouble());
        }).toList();

        // 计算最大数量用于设置Y轴范围
        final maxY = customerData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;

        return Container(
          height: 150,
          padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
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

