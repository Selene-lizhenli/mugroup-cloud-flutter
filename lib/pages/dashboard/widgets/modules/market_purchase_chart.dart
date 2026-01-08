import 'dart:math' as math;
import 'package:cloud/models/dashboard/market_stats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud/services/dashboard.dart';

/// 市场采购模块 - 柱状图
class MarketPurchaseChart extends StatefulWidget {
  const MarketPurchaseChart({super.key});

  @override
  State<MarketPurchaseChart> createState() => _MarketPurchaseChartState();
}

class _MarketPurchaseChartState extends State<MarketPurchaseChart> {
  MarketPurchaseStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// 加载市场采购统计数据
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // 获取统计数据（默认获取最近几个月的数据）
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 7, 1); // 获取最近8个月
      final endDate = DateTime(now.year, now.month + 1, 0); // 当前月的最后一天
      final params = {
        'start_date':
            '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
        'end_date':
            '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
      };
      final summary = await getStatsSummary(params: params);

      if (summary?.data == null || summary!.data!.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = '暂无数据';
        });
        return;
      }

      // 转换数据格式为图表需要的格式
      final sortedEntries = summary.data!.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)); // 按月份排序

      final timeLabels = <String>[];
      final productData = <int>[];
      final customerData = <int>[];
      final serviceProviderData = <int>[];

      for (final entry in sortedEntries) {
        // 将 "2026-01" 格式转换为 "1月" 格式
        final monthStr = _formatMonthLabel(entry.key);
        timeLabels.add(monthStr);
        productData.add(entry.value.marketProduct ?? 0);
        customerData.add(entry.value.crmCompany ?? 0);
        serviceProviderData.add(entry.value.supplySupplier ?? 0);
      }

      final stats = MarketPurchaseStats(
        timeLabels: timeLabels,
        productData: productData,
        customerData: customerData,
        serviceProviderData: serviceProviderData,
      );

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '加载数据失败: $e';
      });
    }
  }

  /// 格式化月份标签，将 "2026-01" 转换为 "1月"
  String _formatMonthLabel(String monthKey) {
    try {
      final parts = monthKey.split('-');
      if (parts.length >= 2) {
        final month = int.parse(parts[1]);
        return '${month}月';
      }
      return monthKey;
    } catch (e) {
      return monthKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loadData,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    if (_stats == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text('暂无数据'),
        ),
      );
    }

    final timeLabels = _stats!.timeLabels ?? [];
    final productData = _stats!.productData ?? [];
    final customerData = _stats!.customerData ?? [];
    final serviceProviderData = _stats!.serviceProviderData ?? [];

    // 计算最大数量用于设置Y轴范围，确保所有数据都能完整显示
    final allData = [...productData, ...customerData, ...serviceProviderData];
    if (allData.isEmpty) {
      return Container(
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
