import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/dashboard_configs.dart'; 
import 'package:cloud/models/dashboard/ship_top_stats.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud/pages/widgets/image_show.dart';

/// 样品间---统计排行图表&列表组件
class ShipTopChartContent extends StatefulWidget {
  final List<ShipTopStats> data;

  const ShipTopChartContent({
    super.key,
    required this.data,
  });

  @override
  State<ShipTopChartContent> createState() => _TopChartContentState();
}

class _TopChartContentState extends State<ShipTopChartContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 只取前5条数据
    final displayData = widget.data.take(9).toList();

    // 如果没有数据，显示空状态
    if (displayData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            '暂无数据',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 柱状图
        buildBarChart(context, displayData),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${sampleDimensionConfigs[0]['label']}排行',
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
            return [
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
                                      color: colorScheme.outline, fontSize: 10),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${sampleDimensionConfigs[0]['label']}：${item.shippingAmount ?? ' '}',
                                  style: TextStyle(
                                      color: colorScheme.outline, fontSize: 10),
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
  Widget buildBarChart(BuildContext context, List<ShipTopStats> displayData) {
    final colorScheme = Theme.of(context).colorScheme;

    // 计算最大数量，用于设置纵轴最大值
    final maxCount =
        displayData.map((e) => e.shippingAmount ?? 0).reduce((a, b) => a > b ? a : b);
    final maxY = maxCount > 0 ? (maxCount * 1.2).ceil().toDouble() : 10.0;

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
                          '数量: ${item.shippingAmount ?? 0}',
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
                      final shippingAmount = item.shippingAmount ?? 0;
                      // 图表绘制区域高度（给 bottomTitles 预留空间）
                      final chartAreaHeight = constraints.maxHeight - 10;
                      final barHeight =
                          maxY <= 0 ? 0.0 : (shippingAmount / maxY) * chartAreaHeight;
                      final barTop = chartAreaHeight - barHeight;
                      // 往上抬一点点，让数字“贴”在柱顶上方
                      final dy = (barTop - 14).clamp(0.0, chartAreaHeight);

                      return Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(0, dy),
                            child: Text(
                              '$shippingAmount',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 8, 
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
