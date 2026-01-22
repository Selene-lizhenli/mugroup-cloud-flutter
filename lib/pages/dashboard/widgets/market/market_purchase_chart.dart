import 'dart:math' as math;
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 市场带客模块 - 柱状图
class MarketPurchaseChart extends HookConsumerWidget {
  const MarketPurchaseChart({super.key});

  static const String _moduleId = 'market_purchase';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final stats = ref.watch(moduleStatsProvider(_moduleId));
    final statsNotifier = ref.read(moduleStatsProvider(_moduleId).notifier);
    final timeLabels = stats.timeLabels;
    final productData = stats.data;

    // 市场带客模块需要显示多个数据系列，所以还需要获取其他模块的数据
    final customerStats = ref.watch(moduleStatsProvider('customer'));
    final supplierStats = ref.watch(moduleStatsProvider('supplier'));
    final customerData = customerStats.data;
    final serviceProviderData = supplierStats.data;

    // 页面加载后调用 load
    useEffect(() {
      if (!stats.isLoading && stats.timeLabels.isEmpty) {
        Future.microtask(() {
          statsNotifier.load();
          // 同时加载客户和供应商数据（如果它们还没有加载）
          if (customerStats.timeLabels.isEmpty) {
            ref.read(moduleStatsProvider('customer').notifier).load();
          }
          if (supplierStats.timeLabels.isEmpty) {
            ref.read(moduleStatsProvider('supplier').notifier).load();
          }
        });
      }
      return null;
    }, []);

    // 显示加载状态
    if (stats.isLoading || customerStats.isLoading || supplierStats.isLoading) {
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
    if (allData.isEmpty) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: colorScheme.surfaceContainerHighest),
          ),
        ),
      );
    }
    final maxValue = allData.reduce((a, b) => a > b ? a : b);
    // 使用1.15倍的上边距，确保所有柱子都能完整显示
    final maxY = maxValue.toDouble() * 1.15;
    // 计算合适的Y轴刻度间隔，确保最多显示10个刻度点（包括0）
    final yAxisInterval = _calculateYAxisInterval(maxY, maxTicks: 10);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 模块标题和维度选择器
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 模块标题
                Text(
                  '市场带客',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                // 维度选择器
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.tune,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  offset: const Offset(-10, 45),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: '最近半年',
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: stats.timeDimension == TimeDimension.last6Months
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '最近半年',
                            style: TextStyle(
                              color: stats.timeDimension == TimeDimension.last6Months
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: stats.timeDimension == TimeDimension.last6Months
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '最近一年',
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: stats.timeDimension == TimeDimension.last12Months
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '最近一年',
                            style: TextStyle(
                              color: stats.timeDimension == TimeDimension.last12Months
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: stats.timeDimension == TimeDimension.last12Months
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '所有时间',
                      child: Row(
                        children: [
                          Icon(
                            Icons.all_inclusive,
                            size: 18,
                            color: stats.timeDimension == TimeDimension.allTime
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '所有时间',
                            style: TextStyle(
                              color: stats.timeDimension == TimeDimension.allTime
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: stats.timeDimension == TimeDimension.allTime
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    TimeDimension? dimension;
                    switch (value) {
                      case '最近半年':
                        dimension = TimeDimension.last6Months;
                        break;
                      case '最近一年':
                        dimension = TimeDimension.last12Months;
                        break;
                      case '所有时间':
                        dimension = TimeDimension.allTime;
                        break;
                    }
                    if (dimension != null) {
                      // 市场带客模块需要同时更新客户和供应商模块的时间维度，以保持数据一致性
                      ref.read(moduleStatsProvider('market_purchase').notifier).setTimeDimension(dimension);
                      ref.read(moduleStatsProvider('customer').notifier).setTimeDimension(dimension);
                      ref.read(moduleStatsProvider('supplier').notifier).setTimeDimension(dimension);
                    }
                  },
                ),
              ],
            ),
          ),
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
                    reservedSize: 20,
                    getTitles: (value) {
                      // 纵轴：显示数量，根据计算出的间隔显示刻度
                      // 大于999的数字使用k格式显示
                      if (value % yAxisInterval == 0 && value >= 0) {
                        return formatNumberWithK(value);
                      }
                      return '';
                    },
                    getTextStyles: (value) => TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  bottomTitles: SideTitles(
                    showTitles: timeLabels.isNotEmpty ? true : false,
                    reservedSize: 12,
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
  /// [maxTicks] 最大刻度点数量（包括0），默认10个
  double _calculateYAxisInterval(double maxY, {int maxTicks = 10}) {
    if (maxY <= 0) return 50;

    // 先计算一个合理的初始间隔
    double initialInterval;
    if (maxY <= 50) {
      initialInterval = 10;
    } else if (maxY <= 100) {
      initialInterval = 20;
    } else if (maxY <= 200) {
      initialInterval = 50;
    } else if (maxY <= 500) {
      initialInterval = 100;
    } else if (maxY <= 1000) {
      initialInterval = 200;
    } else if (maxY <= 2000) {
      initialInterval = 500;
    } else if (maxY <= 5000) {
      initialInterval = 1000;
    } else {
      // 对于更大的值，使用科学计数法风格的间隔
      final magnitude = maxY.toStringAsFixed(0).length - 1;
      final base = math.pow(10, magnitude).toDouble();
      initialInterval = base / 2; // 例如：5000 -> 1000, 50000 -> 10000
    }

    // 检查使用初始间隔会有多少个刻度点（包括0）
    final tickCount = (maxY / initialInterval).ceil() + 1;

    // 如果刻度点数量超过限制，调整间隔
    if (tickCount > maxTicks) {
      // 计算最大允许的间隔（确保最多 maxTicks 个刻度点）
      final maxAllowedInterval = maxY / (maxTicks - 1);
      // 将间隔向上取整到合理的数字
      return _roundToNiceNumber(maxAllowedInterval);
    }

    return initialInterval;
  }

  /// 将数字向上取整到合理的间隔值（如 10, 20, 50, 100, 200, 500, 1000 等）
  double _roundToNiceNumber(double value) {
    if (value <= 0) return 10;

    // 计算数量级
    final magnitude =
        math.pow(10, (math.log(value) / math.ln10).floor()).toDouble();
    final normalized = value / magnitude;

    // 向上取整到 1, 2, 5, 10
    double multiplier;
    if (normalized <= 1) {
      multiplier = 1;
    } else if (normalized <= 2) {
      multiplier = 2;
    } else if (normalized <= 5) {
      multiplier = 5;
    } else {
      multiplier = 10;
    }

    return magnitude * multiplier;
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
