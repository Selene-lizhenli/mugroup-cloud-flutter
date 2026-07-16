import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/pages/dashboard/dashboard_l10n_helper.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/pages/dashboard/widgets/chart_dimen_tips.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart';
import 'package:cloud/pages/dashboard/widgets/product_card.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 

/// 样品间---统计排行图表&列表组件
class QuoteTopChartContent extends StatefulWidget {
  final List<QuoteTopStats> data;
  final DateRange selectedRange;
  final void Function(DateRange range, Map<String, String> params)?
      onRangeChanged;
  final bool? isLoading;
  final void Function(GlobalKey)? handleExpandScroll;

  const QuoteTopChartContent({
    super.key,
    required this.data,
    this.selectedRange = DateRange.lastTwoYear,
    this.onRangeChanged,
    this.isLoading,
    this.handleExpandScroll,
  });
  @override
  State<QuoteTopChartContent> createState() => _TopChartContentState();
}

class _TopChartContentState extends State<QuoteTopChartContent> {
  bool _isExpanded = true;
  static const double chartContainerHeight = 200;
  final GlobalKey _expandedContentKey = GlobalKey();

  void _handleExpandToggle() {
    // 展开时，让展开的内容滚动到距离视口顶部200高度的位置
    if (!_isExpanded) {
      setState(() {
        _isExpanded = true;
      });
      widget.handleExpandScroll?.call(_expandedContentKey);
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    // 只取前9条数据
    final displayData = widget.data.take(9).toList();
    final isLoading = widget.isLoading;
    final dimenLabel = context.dashboardSampleDimensionLabel(
      sampleDimensionConfigs[0]['value'] as String,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 柱状图
        if (isLoading == true)
          SizedBox(
            height: chartContainerHeight,
            child: Center(
              child: MuProgressIndicator(showText: true, text: l10n.loading),
            ),
          )
        else if (displayData.isEmpty)
          SizedBox(
            height: chartContainerHeight,
            child: Center(
              child: Text(
                l10n.noData,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
              ),
            ),
          )
        else
          buildBarChart(context, displayData, dimenLabel),

        const SizedBox(height: 16),

        /// 时间范围选择
        TimeRangeSelect(
          initialRange: widget.selectedRange,
          onRangeChanged: widget.onRangeChanged,
          useAllTime:false,
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
                  l10n.dashboardDimensionData(dimenLabel),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 13, color: colorScheme.onSurface),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _handleExpandToggle,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? l10n.dashboardCollapse : l10n.dashboardExpand,
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
          Column(
            key: _expandedContentKey,
            children: [
              TopRankItemCard(
                displayData: displayData.take(3).toList(),
                type: 'quote',
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    highlightColor: colorScheme.tertiary,
                    splashColor: colorScheme.tertiary,
                    focusColor: colorScheme.tertiary,
                    onTap: () {
                      context.router.push(SampleRankListRoute(
                        data: widget.data,
                        label: dimenLabel,
                        type: 'quote',
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withOpacity(0.33),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        l10n.dashboardViewFullRank,
                        style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8)
            ],
          ),
      ],
    );
  }

  /// 构建柱状图
  Widget buildBarChart(BuildContext context, List<QuoteTopStats> displayData,
      String dimenLabel) {
    final l10n = context.l10n;
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
              ChartDimenTips(
                label: dimenLabel,
              ),
              const SizedBox(height: 10),
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
                          '${l10n.dashboardBarTooltip(
                            item.sampleNo ?? l10n.dashboardUnknown,
                            '${item.count ?? 0}',
                          )}',
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
                          colors: [colorScheme.primary],
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
