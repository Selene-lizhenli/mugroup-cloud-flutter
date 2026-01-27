import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/date_select.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud/pages/widgets/image_show.dart';

/// 样品间---统计排行图表&列表组件
class QuoteTopChartContent extends StatefulWidget {
  final List<QuoteTopStats> data;
  final ShipDateRange selectedRange;
  final ValueChanged<ShipDateRange>? onRangeChanged;
  final bool? isLoading;

  const QuoteTopChartContent({
    super.key,
    required this.data,
    this.selectedRange = ShipDateRange.lastYear,
    this.onRangeChanged,
    this.isLoading,
  });
  @override
  State<QuoteTopChartContent> createState() => _TopChartContentState();
}

class _TopChartContentState extends State<QuoteTopChartContent> {
  bool _isExpanded = false;
  static const double chartContainerHeight = 200;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 只取前9条数据
    final displayData = widget.data.take(9).toList();
    final isLoading = widget.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 柱状图
        if (isLoading == true)
          const SizedBox(
            height: chartContainerHeight,
            child: Center(
              child: MuProgressIndicator(showText: true, text: '加载中...'),
            ),
          )
        else if (displayData.isEmpty)
          SizedBox(
            height: chartContainerHeight,
            child: Center(
              child: Text(
                '暂无数据',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
              ),
            ),
          )
        else
          buildBarChart(context, displayData),

        const SizedBox(height: 16),

        /// 时间范围选择
        TimeRangeSelect(
          selectedRange: widget.selectedRange,
          onRangeChanged: widget.onRangeChanged,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: colorScheme.surfaceTint.withOpacity(0.8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '报价次数排行',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 13, color: colorScheme.onSurface),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? '收起' : '展开',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // 列表（可展开/收起）
        if (_isExpanded)
          ...displayData.asMap().entries.expand<Widget>((entry) {
            final index = entry.key;
            final item = entry.value;
            final isTopThree = index < 3;
            final medalColor = index == 0
                ? const Color(0xFFFFD700) // 金
                : index == 1
                    ? const Color(0xFFC0C0C0) // 银
                    : const Color(0xFFCD7F32); // 铜

            return [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                    ),
                    child: InkWell(
                      onTap: item.id != null
                          ? () {
                              if (context.mounted) {
                                context.router.push(
                                  ShowroomSampleDetailRoute(id: item.id!),
                                );
                              }
                            }
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          // 缩略图
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: ImageShow(
                                imageUrl: item.thumbUrl ?? '',
                                fit: BoxFit.contain,
                                enablePreview: false,
                                showErrorText: true,
                                errorIconSize: 18,
                                errorTextSize: 7,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 内容
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.sampleName ?? ' ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '样品编号: ${item.sampleNo ?? ' '}',
                                      style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.72),
                                          fontSize: 10),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '报价次数：${item.count ?? ' '}',
                                      style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.72),
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // 箭头图标（可点击）
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: colorScheme.outline, size: 14),
                        ],
                      ),
                    ),
                  ),
                  if (isTopThree)
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: medalColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 14,
                              color: index == 1
                                  ? Colors.grey.shade800
                                  : Colors.white,
                            ),
                            // Text(index.toString()),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              // 添加水平分割线（最后一条数据后不添加）
              if (index < displayData.length - 1)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.15),
                ),
            ];
          }),
      ],
    );
  }

  /// 构建柱状图
  Widget buildBarChart(BuildContext context, List<QuoteTopStats> displayData) {
    final colorScheme = Theme.of(context).colorScheme;

    // 计算最大数量，用于设置纵轴最大值
    final maxCount =
        displayData.map((e) => e.count ?? 0).reduce((a, b) => a > b ? a : b);
    final minCount =
        displayData.map((e) => e.count ?? 0).reduce((a, b) => a > b ? b : a);
    final maxY = maxCount > 0 ? (maxCount * 1.1).ceil().toDouble() : 10.0;
    final minY = minCount > 0 ? (minCount * 0.85).ceil().toDouble() : 10.0;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: minY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: colorScheme.onPrimary.withOpacity(0.89),
                      fitInsideHorizontally: true,
                      tooltipRoundedRadius: 8,
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final item = displayData[groupIndex];
                        return BarTooltipItem(
                          '${item.sampleName ?? ''}\n'
                          '编号: ${item.sampleNo ?? '未知'}\n'
                          '数量: ${item.count ?? 0}',
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
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 0,
                      getTitles: (value) {
                        final index = value.toInt();
                        if (index >= 1 && index <= displayData.length) {
                          final item = displayData[index - 1];
                          return item.sampleNo ?? '';
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
                    final count = item.count ?? 0;

                    return BarChartGroupData(
                      x: index + 1,
                      barRods: [
                        BarChartRodData(
                          y: count.toDouble(),
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
                      final count = item.count ?? 0;
                      // 图表绘制区域高度（给 bottomTitles 预留空间）
                      final chartAreaHeight = constraints.maxHeight - 10;
                      // 有 minY 时：柱顶在像素中的位置 = (maxY - count) / (maxY - minY) * chartAreaHeight
                      final rangeY = maxY - minY;
                      final barTop = rangeY <= 0
                          ? chartAreaHeight * 0.5
                          : chartAreaHeight * (maxY - count) / rangeY;
                      // 往上抬一点，让数字贴在柱顶上方
                      final dy = (barTop - 14).clamp(0.0, chartAreaHeight);
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
                              ),
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
    );
  }
}
