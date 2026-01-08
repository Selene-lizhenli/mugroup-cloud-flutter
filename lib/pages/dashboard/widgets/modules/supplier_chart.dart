import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 供应商模块 - 折线图
class SupplierChart extends ConsumerStatefulWidget {
  const SupplierChart({super.key});

  @override
  ConsumerState<SupplierChart> createState() => _SupplierChartState();
}

class _SupplierChartState extends ConsumerState<SupplierChart> {
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
    final serviceProviderData = stats.serviceProviderData;

        if (serviceProviderData.isEmpty) {
          return Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('暂无数据'),
            ),
          );
        }

        // 将服务商数量转换为 FlSpot
        final spots = serviceProviderData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.toDouble());
        }).toList();

        // 计算最大数量用于设置Y轴范围
        final maxY = serviceProviderData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;
        final minY = serviceProviderData.reduce((a, b) => a < b ? a : b).toDouble() * 0.8;
        return Container(
          height: 100,
          padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitles: (value) {
                // 纵轴：显示数量（整数），根据数据范围动态调整间隔
                final interval = maxY > 10000 ? 10000 : (maxY > 1000 ? 1000 : 100);
                if (value % interval == 0 && value >= 0) {
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

