import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_calculator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 汇率图表头部组件（包含标题、汇率计算器和维度选择器）
class ExchangeChartHeader extends StatelessWidget {
  final ExchangeRate? selectedDimension;
  final ValueChanged<ExchangeRate> onDimensionSelected;
  final List<ExchangeRate>? currencyList;

  /// 视图切换回调：传入目标视图是否为趋势图（true = 展示趋势图，false = 展示列表）
  final ValueChanged<bool>? onViewToggle;
  final bool showTrendView; // true 表示显示趋势图，false 表示显示列表

  const ExchangeChartHeader({
    super.key,
    required this.selectedDimension,
    required this.onDimensionSelected,
    this.currencyList,
    this.onViewToggle,
    this.showTrendView = false,
  });

  void _showExchangeCalculator(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return ExchangeCalculatorDialog(
            selectedDimension: selectedDimension, list: currencyList);
      },
    );
  }

  void _openDimensionBottomSheet(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<ExchangeRate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.7;
        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  // 顶部渐变背景（不影响下面的列表区域）
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colorScheme.primary.withOpacity(0.18),
                            colorScheme.surface.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '选择维度',
                            style: Theme.of(sheetContext)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: Icon(
                            Icons.close,
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              if (currencyList != null && currencyList!.isNotEmpty)
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: currencyList!.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colorScheme.outlineVariant),
                    itemBuilder: (ctx, index) {
                      final dimension = currencyList![index];
                      final isSelected =
                          selectedDimension?.shortName == dimension.shortName;

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 18,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                        title: Text(
                          '${dimension.name} ${dimension.shortName}',
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(dimension),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // 选择维度后自动切到趋势视图
        onViewToggle?.call(true);
        onDimensionSelected(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 模块标题
          Text(
            '汇率波动',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (onViewToggle != null)
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    // 点击图标在列表视图与趋势视图之间切换
                    onTap: () => {
                      if (selectedDimension == null && !showTrendView) //当前是列表且没有选中维度
                        _openDimensionBottomSheet(context)
                      else
                        onViewToggle?.call(!showTrendView),
                    },
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: colorScheme.primary.withOpacity(0.1),
                    splashColor: colorScheme.primary.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            !showTrendView ? Icons.show_chart : Icons.grid_view,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _showExchangeCalculator(context),
                  borderRadius: BorderRadius.circular(100),
                  highlightColor: colorScheme.primary.withOpacity(0.1),
                  splashColor: colorScheme.primary.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.calculator,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _openDimensionBottomSheet(context),
                  borderRadius: BorderRadius.circular(100),
                  highlightColor: colorScheme.primary.withOpacity(0.1),
                  splashColor: colorScheme.primary.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
