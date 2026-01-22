import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'sample_room_module.dart';

/// 图表内容组件
class ChartContent extends StatefulWidget {
  final List<Level1CategoryStat> sampleRoomData;

  const ChartContent({
    super.key,
    required this.sampleRoomData,
  });

  @override
  State<ChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<ChartContent> {
  int? _selectedIndex; // 当前选中的柱子索引

  /// 格式化数字（添加千分位）
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 过滤掉值为 0 的数据项（fl_chart 不允许扇区值为 0）
    final validData = widget.sampleRoomData
        .where((item) => item.totalProductsCount > 0)
        .toList();

    // 如果没有有效数据，显示空状态
    if (validData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            '暂无有效数据',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ),
      );
    }

    // 计算总数量（只计算有效数据）
    final totalCount =
        validData.fold<int>(0, (sum, item) => sum + item.totalProductsCount);

    // 构建原始索引到有效索引的映射（用于图例点击）
    final originalIndexMap = <int, int>{};
    int validIndex = 0;
    for (int i = 0; i < widget.sampleRoomData.length; i++) {
      if (widget.sampleRoomData[i].totalProductsCount > 0) {
        originalIndexMap[validIndex] = i;
        validIndex++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 柱状图（只显示有效数据）
        buildBarChart(context, validData, originalIndexMap),
        // 下方显示当前选中数据
        if (_selectedIndex != null &&
            _selectedIndex! >= 0 &&
            _selectedIndex! < widget.sampleRoomData.length &&
            widget.sampleRoomData[_selectedIndex!].totalProductsCount > 0) ...[
          Container(
            margin: const EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.sampleRoomData[_selectedIndex!].name}：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                ),
                Text(
                  _formatNumber(widget
                      .sampleRoomData[_selectedIndex!].totalProductsCount),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${((widget.sampleRoomData[_selectedIndex!].totalProductsCount / totalCount) * 100).toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        // 数据列表
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '样品间统计详情',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colorScheme.onSurface),
          ),
        ),

        const SizedBox(height: 8),
        // 遍历显示所有有效数据的列表
        ...validData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final percentage = totalCount > 0
              ? (item.totalProductsCount / totalCount * 100).toStringAsFixed(1)
              : '0.0';
          // 检查当前项是否为选中项
          final originalIndex = originalIndexMap[index];
          final isSelected =
              originalIndex != null && _selectedIndex == originalIndex;
          return Container(
            margin: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 颜色指示器
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // 样品间名称
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? colorScheme.secondary : null,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        ),
                  ),
                ),
                // 数量和百分比
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _formatNumber(item.totalProductsCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected ? colorScheme.secondary : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? colorScheme.secondary
                                : colorScheme.outline,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// 构建柱状图
  Widget buildBarChart(BuildContext context,
      List<Level1CategoryStat> displayData, Map<int, int> originalIndexMap) {
    final colorScheme = Theme.of(context).colorScheme;

    // 计算最大数量，用于设置纵轴最大值
    final maxCount = displayData.isNotEmpty
        ? displayData
            .map((e) => e.totalProductsCount)
            .reduce((a, b) => a > b ? a : b)
        : 0;
    final maxY = maxCount > 0 ? (maxCount * 1.2).ceil().toDouble() : 10.0;

    // 计算总数量（只计算有效数据）
    final totalCount =
        displayData.fold<int>(0, (sum, item) => sum + item.totalProductsCount);

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor:
                              colorScheme.onSurface.withOpacity(0.06),
                          fitInsideHorizontally: true,
                          tooltipRoundedRadius: 8,
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final item = displayData[groupIndex];
                            final percentage = totalCount > 0
                                ? (item.totalProductsCount / totalCount * 100)
                                    .toStringAsFixed(1)
                                : '0.0';
                            return BarTooltipItem(
                              '${item.name}\n'
                              '数量: ${item.totalProductsCount}\n'
                              '占比: $percentage%',
                              TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 10,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        touchCallback: (barTouchResponse) {
                          if (barTouchResponse.spot == null) {
                            setState(() {
                              _selectedIndex = null;
                            });
                            return;
                          }
                          final touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                          // 将有效索引转换回原始索引
                          if (touchedIndex >= 0 &&
                              touchedIndex < displayData.length) {
                            final originalIndex =
                                originalIndexMap[touchedIndex];
                            if (originalIndex != null &&
                                originalIndex < widget.sampleRoomData.length) {
                              setState(() {
                                _selectedIndex = originalIndex;
                              });
                            }
                          } else {
                            setState(() {
                              _selectedIndex = null;
                            });
                          }
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitles: (value) {
                            final index = value.toInt();
                            if (index >= 0 && index < displayData.length) {
                              final item = displayData[index];
                              // 限制长度，避免文字过长
                              final name = item.name.length > 6
                                  ? '${item.name.substring(0, 6)}...'
                                  : item.name;
                              return name;
                            }
                            return '';
                          },
                          getTextStyles: (_) => TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 8,
                          ),
                        ),
                        leftTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outline.withOpacity(0.2),
                            width: 1,
                          ),
                          left: BorderSide.none,
                        ),
                      ),
                      barGroups: displayData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              y: item.totalProductsCount.toDouble(),
                              colors: [colorScheme.secondary],
                              width: 24,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                          barsSpace: 8,
                        );
                      }).toList(),
                    ),
                  ),
                  // 在柱子正上方显示数量（无背景色）
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: displayData.asMap().entries.map((entry) {
                          final item = entry.value;
                          final count = item.totalProductsCount;
                          // 图表绘制区域高度（给 bottomTitles 预留空间）
                          final chartAreaHeight = constraints.maxHeight - 30;
                          final barHeight = maxY <= 0
                              ? 0.0
                              : (count / maxY) * chartAreaHeight;
                          final barTop = chartAreaHeight - barHeight;
                          // 确保文字至少在柱子顶部上方至少8像素的位置，避免显示在柱子上
                          const minOffsetAboveBar = 8.0;
                          final dy = (barTop - 18)
                              .clamp(minOffsetAboveBar, chartAreaHeight);

                          return Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Transform.translate(
                                offset: Offset(0, dy),
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 10,
                                      height: 1),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
