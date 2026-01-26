 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 汇率图表头部组件（包含标题、汇率计算器和维度选择器）
class ExchangeChartHeader extends StatelessWidget {
  final VoidCallback onCalculatorPressed;
  final String? selectedDimension;
  final List<String> dimensionOptions;
  final ValueChanged<String> onDimensionSelected;

  const ExchangeChartHeader({
    super.key,
    required this.onCalculatorPressed,
    required this.selectedDimension,
    required this.dimensionOptions,
    required this.onDimensionSelected,
  });

  void _openDimensionBottomSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.7;
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Divider(height: 1, color: colorScheme.outlineVariant),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: dimensionOptions.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colorScheme.outlineVariant),
                    itemBuilder: (ctx, index) {
                      final dimension = dimensionOptions[index];
                      final isSelected = selectedDimension == dimension;

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 18,
                          color: isSelected ? colorScheme.primary : colorScheme.outline,
                        ),
                        title: Text(
                          dimension,
                          style: TextStyle(
                            color:
                                isSelected ? colorScheme.primary : colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(dimension),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null && value != selectedDimension) {
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
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TextButton(
              //   onPressed: onCalculatorPressed,
              //   style: TextButton.styleFrom(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //     textStyle: const TextStyle(fontSize: 14),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(
              //         FontAwesomeIcons.calculator,
              //         size: 14,
              //         color: colorScheme.primary,
              //       ),
              //       const SizedBox(width: 6),
              //       const Text(
              //         '汇率计算器',
              //         style: TextStyle(fontSize: 12),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => _openDimensionBottomSheet(context),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    // const SizedBox(width: 6),
                    // Text(
                    //   selectedDimension ?? '选择',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey.shade800,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
