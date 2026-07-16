import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/search_platform_l10n_helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

/// 横向可滑动的标签列表，用于平台等单选标签展示
class MuTagList extends StatelessWidget {
  const MuTagList({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.height = 40,
    this.spacing = 10,
    this.padding,
    this.fontSize = 13,
    this.chipPadding,
    this.backgroundColor,
  });

  final List<SearchPlatformItem> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final double height;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final EdgeInsetsGeometry? chipPadding;
  final Color? backgroundColor; //未选中时的标签背景颜色

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listView = ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: padding,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(width: spacing),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedValue == item.value;
        return GestureDetector(
          onTap: () => onSelected(item.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: chipPadding ??
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : backgroundColor ??
                      theme.colorScheme.outlineVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                item.label ?? searchPlatformLabel(context.l10n, item.value),
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      },
    );
    final child = SizedBox(height: height, child: listView);
    return child;
  }
}
