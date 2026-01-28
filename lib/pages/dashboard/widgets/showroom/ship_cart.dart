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
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:cloud/pages/dashboard/widgets/chart_dimen_tips.dart';

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
    this.selectedRange = DateRange.lastYear,
    this.onRangeChanged,
    this.isLoading,
    this.handleExpandScroll,
  });

  @override
  State<ShipTopChartContent> createState() => _TopChartContentState();
}

class _TopChartContentState extends State<ShipTopChartContent> {
  bool _isExpanded = false;
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
                  '$dimenLabel排行数据',
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
                        _isExpanded ? '收起' : '更多',
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
                  Stack(children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '样品编号: ${item.sampleNo ?? ' '}',
                                        style: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.72),
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '出货金额(CNY)：${formatCurrencyAmount(item.shippingAmount)}',
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
                    // 奖杯
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
                  ]),

                  // 添加水平分割线（最后一条数据后不添加）
                  if (index < displayData.length - 1)
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.15),
                    ),
                ];
              }),
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
                label: '$dimenLabel排行',
              ),
              const SizedBox(height: 10),
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: colorScheme.onSurface.withOpacity(0.06),
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
                      final data = item.shippingAmount ?? 0;
                      // 图表绘制区域高度（给 bottomTitles 预留空间）
                      final chartAreaHeight = constraints.maxHeight - 10;
                      final barHeight =
                          maxY <= 0 ? 0.0 : (data / maxY) * chartAreaHeight;
                      final barTop = chartAreaHeight - barHeight;
                      // 往上抬一点点，让数字“贴”在柱顶上方
                      final dy = (barTop - 14).clamp(0.0, chartAreaHeight);

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
