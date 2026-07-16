import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 筛选底部抽屉内容：排序、价格区间上下平铺展示
class FilterContent extends ConsumerWidget {
  const FilterContent({super.key});
  static const colothemeColor = Color.fromARGB(255, 247, 237, 255);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: colothemeColor,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Text(
                l10n.filter,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  notifier.resetFilterContent();
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text(
                  l10n.reset,
                  style: TextStyle(color: colorScheme.secondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  notifier.loadProducts(refresh: true);
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text(l10n.quoteConfirm),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.purchaseAssistFilterSort,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              _SortContent(
                currentSort: state.sortOrder,
                onSortChanged: notifier.setSortOrder,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.purchaseAssistFilterPriceRange,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              _PriceRangeContent(
                minValue: state.priceMin,
                maxValue: state.priceMax,
                onMinChanged: (min) {
                  notifier.setPriceRange(min, state.priceMax);
                },
                onMaxChanged: (max) {
                  notifier.setPriceRange(state.priceMin, max);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 排序单选项：默认、按价格降序、按价格升序
class _SortContent extends StatelessWidget {
  final String? currentSort;
  final ValueChanged<String?> onSortChanged;

  const _SortContent({
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String?>(
          title: Text(l10n.purchaseAssistSortDefault),
          value: null,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: onSortChanged,
        ),
        RadioListTile<String?>(
          title: Text(l10n.purchaseAssistSortPriceDesc),
          value: kSortPriceDesc,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: onSortChanged,
        ),
        RadioListTile<String?>(
          title: Text(l10n.purchaseAssistSortPriceAsc),
          value: kSortPriceAsc,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: onSortChanged,
        ),
      ],
    );
  }
}

/// 价格区间：最小值、最大值输入框
class _PriceRangeContent extends StatelessWidget {
  final String? minValue;
  final String? maxValue;
  final ValueChanged<String?> onMinChanged;
  final ValueChanged<String?> onMaxChanged;

  const _PriceRangeContent({
    required this.minValue,
    required this.maxValue,
    required this.onMinChanged,
    required this.onMaxChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: minValue ?? '',
            decoration: InputDecoration(
              labelText: l10n.purchaseAssistMinPrice,
              hintText: l10n.purchaseAssistEnterMinPrice,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) {
              final text = v.trim();
              onMinChanged(text.isEmpty ? null : text);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            initialValue: maxValue ?? '',
            decoration: InputDecoration(
              labelText: l10n.purchaseAssistMaxPrice,
              hintText: l10n.purchaseAssistEnterMaxPrice,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (v) {
              final text = v.trim();
              onMaxChanged(text.isEmpty ? null : text);
            },
          ),
        ),
      ],
    );
  }
}
