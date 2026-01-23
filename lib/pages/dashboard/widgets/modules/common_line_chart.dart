import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 模块折线图 - 可复用组件
class ModuleLineChart extends ConsumerStatefulWidget {
  /// 模块ID
  final String moduleId; 
  
  /// 图表高度
  final double height;
  
  /// 是否使用曲线
  final bool isCurved;
  
  /// 自定义最小Y值（如果不提供，则使用0）
  final double? customMinY;
  
  /// 左侧标题保留空间
  final double leftReservedSize;
  
  /// 底部标题保留空间
  final double bottomReservedSize;
  
  /// 左侧标题字体大小
  final double leftFontSize;
  
  /// 底部标题字体大小
  final double bottomFontSize;
  
  /// 内边距
  final EdgeInsets padding;
  
  /// 空数据容器高度
  final double? emptyDataHeight;
  
  /// Y轴标题间隔计算函数（可选，用于自定义间隔逻辑）
  final double Function(double maxY)? yAxisIntervalCalculator;

  const ModuleLineChart({
    super.key,
    required this.moduleId, 
    this.height = 200,
    this.isCurved = true,
    this.customMinY,
    this.leftReservedSize = 20,
    this.bottomReservedSize = 12,
    this.leftFontSize = 10,
    this.bottomFontSize = 10,
    this.padding = const EdgeInsets.all(16),
    this.emptyDataHeight=100,
    this.yAxisIntervalCalculator,
  });

  @override
  ConsumerState<ModuleLineChart> createState() => _ModuleLineChartState();
}

class _ModuleLineChartState extends ConsumerState<ModuleLineChart> {
  bool _hasLoaded = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(moduleStatsProvider(widget.moduleId));
    final colorScheme = Theme.of(context).colorScheme;

    // 初始化时加载数据（仅在首次且未加载时）
    if (!_hasLoaded && !stats.isLoading && stats.timeLabels.isEmpty) {
      _hasLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(moduleStatsProvider(widget.moduleId).notifier).load();
        }
      });
    }

    // 显示加载状态
    if (stats.isLoading) {
      return Container(
        padding: widget.padding,
        height: widget.height,
        child: const Center(
          child: MuProgressIndicator(),
        ),
      );
    }

    final timeLabels = stats.timeLabels;
    final chartData = stats.data;

    // 显示空数据状态
    if (chartData.isEmpty) {
      return Container(
        height: widget.emptyDataHeight ?? widget.height,
        padding: widget.padding,
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: colorScheme.surfaceContainerHighest),
          ),
        ),
      );
    }

    // 将数据转换为 FlSpot
    final spots = chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
    }).toList();

    // 计算Y轴范围
    final maxY = chartData.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;
    final minY = widget.customMinY ??
        (widget.moduleId == 'supplier'
            ? chartData.reduce((a, b) => a < b ? a : b).toDouble() * 0.8
            : 0.0);

    return Container(
      height: widget.height,
      padding: widget.padding,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: widget.leftReservedSize,
              getTitles: (value) {
                if (widget.moduleId == 'supplier') {
                  // 供应商使用动态间隔
                  final dynamicInterval = maxY > 10000 ? 10000 : (maxY > 1000 ? 1000 : 100);
                  if (value % dynamicInterval == 0 && value >= 0) {
                    return formatNumberWithK(value);
                  }
                } else {
                  // 其他使用固定间隔
                  final interval = widget.yAxisIntervalCalculator?.call(maxY) ?? 10;
                  if (value % interval == 0 && value >= 0) {
                    return formatNumberWithK(value);
                  }
                }
                return '';
              },
              getTextStyles: (value) => TextStyle(
                fontSize: widget.leftFontSize,
                color: Colors.grey.shade600,
              ),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: widget.bottomReservedSize,
              getTitles: (value) {
                final index = value.toInt();
                if (index >= 0 && index < timeLabels.length) {
                  return timeLabels[index];
                }
                return '';
              },
              getTextStyles: (value) => TextStyle(
                fontSize: widget.bottomFontSize,
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
              isCurved: widget.isCurved,
              colors: [colorScheme.primary],
              belowBarData: BarAreaData(
                show: true,
                colors: [colorScheme.primary.withOpacity(0.1)],
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

