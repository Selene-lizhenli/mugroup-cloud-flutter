import 'dart:math' as math;
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 市场采购模块 - 柱状图
class MarketPurchaseChart extends HookConsumerWidget {
  const MarketPurchaseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final stats = ref.watch(dashboardStatsProvider);
    final statsNotifier = ref.read(dashboardStatsProvider.notifier);
    final timeLabels = stats.timeLabels;
    final productData = stats.productData;
    final customerData = stats.customerData;
    final serviceProviderData = stats.serviceProviderData;

    // 页面加载后调用 load
    useEffect(() {
      if (!stats.isLoading && stats.timeLabels.isEmpty) {
        Future.microtask(() {
          statsNotifier.load();
        });
      }
      return null;
    }, []); 
   
    // 显示加载状态
    if (stats.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 计算最大数量用于设置Y轴范围，确保所有数据都能完整显示
    final allData = [...productData, ...customerData, ...serviceProviderData];
     logger.d('allData${allData}');
    if (allData.isEmpty) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text('暂无数据'),
        ),
      );
    }
    final maxValue = allData.reduce((a, b) => a > b ? a : b);
    // 使用1.15倍的上边距，确保所有柱子都能完整显示
    final maxY = maxValue.toDouble() * 1.15;
    // 计算合适的Y轴刻度间隔，使刻度更合理
    final yAxisInterval = _calculateYAxisInterval(maxY);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图例
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _buildLegendItem('产品数量', Colors.green),
              _buildLegendItem('客户数量', colorScheme.secondary),
              _buildLegendItem('服务商数量', colorScheme.primary),
            ],
          ),
          const SizedBox(height: 16),
          // 柱状图
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitles: (value) {
                      // 纵轴：显示数量（整数），根据计算出的间隔显示刻度
                      if (value % yAxisInterval == 0 && value >= 0) {
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
                    showTitles: timeLabels.isNotEmpty ? false : true,
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
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  timeLabels.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        y: productData[index].toDouble(),
                        colors: [Colors.green],
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(1),
                          topRight: Radius.circular(1),
                        ),
                      ),
                      BarChartRodData(
                        y: customerData[index].toDouble(),
                        colors: [colorScheme.secondary],
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(1),
                          topRight: Radius.circular(1),
                        ),
                      ),
                      BarChartRodData(
                        y: serviceProviderData[index].toDouble(),
                        colors: [colorScheme.primary],
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                    ],
                    barsSpace: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 计算合适的Y轴刻度间隔
  /// 根据最大值动态计算，使刻度显示更合理
  double _calculateYAxisInterval(double maxY) {
    if (maxY <= 0) return 50;

    // 根据最大值范围选择合适的间隔
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 200) return 50;
    if (maxY <= 500) return 100;
    if (maxY <= 1000) return 200;
    if (maxY <= 2000) return 500;
    if (maxY <= 5000) return 1000;
    // 对于更大的值，使用科学计数法风格的间隔
    final magnitude = maxY.toStringAsFixed(0).length - 1;
    final base = math.pow(10, magnitude).toDouble();
    return base / 2; // 例如：5000 -> 1000, 50000 -> 10000
  }

  /// 构建图例项
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
