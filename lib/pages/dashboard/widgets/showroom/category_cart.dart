 
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'sample_room_module.dart';

/// 图表内容组件
class CategoryChartContent extends StatefulWidget {
  final List<Level1CategoryStat> sampleRoomData; 

  const CategoryChartContent({
    super.key,
    required this.sampleRoomData, 
  });

  @override
  State<CategoryChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<CategoryChartContent> {
  int? _selectedIndex; // 当前选中的扇区索引
  bool _isLegendExpanded = false; // 图例是否展开

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
        // 上方图例（显示所有数据，包括值为 0 的）
        LayoutBuilder(
          builder: (context, constraints) {
            // 构建图例项列表
            final legendItems =
                widget.sampleRoomData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;
              final hasValue = item.totalProductsCount > 0;
              return GestureDetector(
                onTap: hasValue
                    ? () {
                        setState(() {
                          // 确保索引有效
                          if (isSelected) {
                            _selectedIndex = null;
                          } else if (index >= 0 &&
                              index < widget.sampleRoomData.length) {
                            _selectedIndex = index;
                          }
                        });
                      }
                    : null,
                child: Opacity(
                  opacity: hasValue ? 1.0 : 0.5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: isSelected
                                  ? item.color
                                  : Colors.grey.shade700,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();

            // 估算：每行约显示 4-5 项（根据容器宽度和项的平均宽度）
            // 两行约 8-10 项，使用 8 作为阈值
            // 两行的高度：12px (图标) + 8px (runSpacing) + 12px (第二行图标) ≈ 32px，加上文本高度约 14px，总计约 46px
            const double twoLineHeight = 60;
            const int itemsPerRow = 4;
            const int maxItemsWhenCollapsed = itemsPerRow * 2;
            final bool needsExpansionButton =
                legendItems.length > maxItemsWhenCollapsed;
            final bool isCollapsed = !_isLegendExpanded && needsExpansionButton;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: isCollapsed
                            ? twoLineHeight
                            : 1000.0, // 使用足够大的值而不是 infinity
                      ),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                needsExpansionButton && !isCollapsed ? 30 : 0,
                          ),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: legendItems,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 展开/收起按钮（仅在需要时显示，始终在右下角）
                if (needsExpansionButton)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _isLegendExpanded = !_isLegendExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity, // 宽度占满父容器
                        padding: EdgeInsets.fromLTRB(
                            12, _isLegendExpanded ? 12 : 24, 2, 2),
                        alignment: Alignment.centerRight, // 文本整体靠右
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          // 背景使用从下到上的渐变：越往上透明度越低
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromRGBO(255, 255, 255, 1), // 下方
                              Color.fromRGBO(255, 255, 255, 0.85),
                              Color.fromRGBO(255, 255, 255, 0.6),
                              Color.fromRGBO(255, 255, 255, 0.0), // 上方
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _isLegendExpanded ? '收起' : '展开',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 11,
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              _isLegendExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        // 圆饼图（只显示有效数据）
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (pieTouchResponse) {
                  if (pieTouchResponse.touchedSection == null) {
                    setState(() {
                      _selectedIndex = null;
                    });
                    return;
                  }
                  final touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                  // 将有效索引转换回原始索引
                  if (touchedIndex >= 0 && touchedIndex < validData.length) {
                    final originalIndex = originalIndexMap[touchedIndex];
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
              sectionsSpace: 2, // 扇区之间的间隔
              centerSpaceRadius: 40, // 中心空白半径
              sections: validData.asMap().entries.map((entry) {
                final validIndex = entry.key;
                final item = entry.value;
                final originalIndex = originalIndexMap[validIndex];
                final percentage = totalCount > 0
                    ? (item.totalProductsCount / totalCount * 100)
                        .toStringAsFixed(1)
                    : '0.0';
                final isSelected =
                    originalIndex != null && _selectedIndex == originalIndex;

                return PieChartSectionData(
                  value: item.totalProductsCount.toDouble(),
                  color: item.color,
                  title: '${percentage}%',
                  radius: isSelected ? 60 : 50, // 选中时突出显示
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // 下方显示当前选中数据
        if (_selectedIndex != null &&
            _selectedIndex! >= 0 &&
            _selectedIndex! < widget.sampleRoomData.length &&
            widget.sampleRoomData[_selectedIndex!].totalProductsCount > 0)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.sampleRoomData[_selectedIndex!].color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.sampleRoomData[_selectedIndex!].name}：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
      ],
    );
  }
}
