import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/dashboard/ship_top_stats.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart'
    show DateRange, TimeRangeSelect;
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud/pages/dashboard/widgets/chart_dimen_tips.dart';
import 'package:cloud/pages/dashboard/widgets/product_card.dart';

export 'package:cloud/pages/dashboard/widgets/date_select.dart' show DateRange;

/// 样品间---统计排行图表&列表组件
class ShipTopChartContent extends StatefulWidget {
  final List<ShipTopStats> data;
  final DateRange selectedRange;
  final void Function(DateRange range, Map<String, String> params)?
      onRangeChanged;
  final bool? isLoading;
  final void Function(GlobalKey)? handleExpandScroll;

  const ShipTopChartContent({
    super.key,
    required this.data,
    this.selectedRange = DateRange.lastTwoYear,
    this.onRangeChanged,
    this.isLoading,
    this.handleExpandScroll,
  });

  @override
  State<ShipTopChartContent> createState() => _TopChartContentState();
}

class _TopChartContentState extends State<ShipTopChartContent> {
  bool _isExpanded = true;
  static const double chartContainerHeight = 200;
  final GlobalKey _expandButtonKey = GlobalKey();
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
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = widget.isLoading;
    final selectedRange = widget.selectedRange;
    final onRangeChanged = widget.onRangeChanged;
    // 只取前8条数据；shipCount 为 true 时按 shippingCount 从大到小排序后取前 8
    final displayData = widget.data.take(8).toList();
    final dimenLabel =
        sampleDimensionConfigs[0]['label'] as String; //当前选中的维度的标签名字

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
          buildBarChart(context, displayData, dimenLabel),

        const SizedBox(height: 16),

        /// 时间范围选择
        TimeRangeSelect(
          initialRange: selectedRange,
          onRangeChanged: onRangeChanged,
          useAllTime:false,
        ),
        const SizedBox(height: 16),

        /// 排行标题
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
                  '$dimenLabel数据',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 13, color: colorScheme.onSurface),
                ),
              ),
              InkWell(
                key: _expandButtonKey,
                borderRadius: BorderRadius.circular(8),
                onTap: _handleExpandToggle,
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
          Column(
            key: _expandedContentKey,
            children: [
              TopRankItemCard(
                displayData: displayData.take(3).toList(),
                type: 'ship',
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
                        type: 'ship',
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
                        ' 查看完整榜单 ',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 11,
                        ),
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
  Widget buildBarChart(
    BuildContext context,
    List<ShipTopStats> displayData,
    String? dimenLabel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // 计算最大数量，用于设置纵轴最大值
    final maxCount = displayData
        .map((e) => e.shippingAmount ?? 0)
        .reduce((a, b) => a > b ? a : b);
    final maxY = maxCount > 0 ? (maxCount * 1.2).ceil().toDouble() : 10.0;

    return Container(
      height: chartContainerHeight,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              ChartDimenTips(
                  label: '$dimenLabel',
                  extra: Text(
                    '单位：万人民币',
                    style: TextStyle(fontSize: 10, color: colorScheme.outline),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    minY: 0,
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
                            '出货金额(CNY): ${formatCurrencyAmount(item.shippingAmount ?? 0)} ',
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
                      final shippingAmount = item.shippingAmount ?? 0;
                      return BarChartGroupData(
                        x: index + 1,
                        barRods: [
                          BarChartRodData(
                            y: shippingAmount.toDouble(),
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
              ),
              // 在柱子正上方显示数量（无背景色）
              Positioned.fill(
                child: IgnorePointer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: displayData.asMap().entries.map((entry) {
                      final item = entry.value;
                      final data = item.shippingAmount ?? 0;
                      // 图表绘制区域高度（给 bottomTitles 预留空间）
                      final chartAreaHeight = constraints.maxHeight - 10;
                      final barHeight =
                          maxY <= 0 ? 0.0 : (data / maxY) * chartAreaHeight;
                      final barTop = chartAreaHeight - barHeight;
                      // 往上抬一点点，让数字“贴”在柱顶上方
                      final dy = (barTop - 5).clamp(0.0, chartAreaHeight);

                      return Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(0, dy),
                            child: Text(
                              formatCurrencyAmount(data),
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 7,
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
