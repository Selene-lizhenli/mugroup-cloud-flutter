import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 筛选底部抽屉内容：竖向 Tab - 排序、价格区间
class FilterContent extends HookConsumerWidget {
  const FilterContent({
    super.key,
    this.scrollController,
  });

  /// 来自 `DraggableScrollableSheet` 的滚动控制器（用于内容超出时可上下滑动）
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final selectedTabIndex = useState(0);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text(
                '筛选',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  notifier.resetFilterContent();
                  if (context.mounted) Navigator.of(context).pop();
                },
                child:
                    Text('重置', style: TextStyle(color: colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  notifier.loadProducts(refresh: true);
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 竖向 Tab 列表
              Container(
                width: 100,
                color: colorScheme.primary.withOpacity(0.1),
                child: Column(
                  children: [
                    _FilterTabItem(
                      label: '排序',
                      selected: selectedTabIndex.value == 0,
                      onTap: () => selectedTabIndex.value = 0,
                    ),
                    _FilterTabItem(
                      label: '价格区间',
                      selected: selectedTabIndex.value == 1,
                      onTap: () => selectedTabIndex.value = 1,
                    ),
                  ],
                ),
              ),
              // 右侧内容
              Expanded(
                child: Container(
                  color: colorScheme.surface,
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: selectedTabIndex.value == 0
                        ? _SortContent(
                            currentSort: state.sortOrder,
                            onSortChanged: notifier.setSortOrder,
                          )
                        : _PriceRangeContent(
                            minValue: state.priceMin,
                            maxValue: state.priceMax,
                            onMinChanged: (min) {
                              notifier.setPriceRange(min, state.priceMax);
                            },
                            onMaxChanged: (max) {
                              notifier.setPriceRange(state.priceMin, max);
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      child: InkWell(
        focusColor: Colors.white,
        hoverColor: Colors.white,
        highlightColor: Colors.white,
        splashColor: Colors.white,
        onTap: onTap,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String?>(
          title: const Text('默认'),
          value: null,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) => onSortChanged(v),
        ),
        RadioListTile<String?>(
          title: const Text('按价格降序'),
          value: kSortPriceDesc,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) => onSortChanged(v),
        ),
        RadioListTile<String?>(
          title: const Text('按价格升序'),
          value: kSortPriceAsc,
          groupValue: currentSort,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) => onSortChanged(v),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: minValue ?? '',
            decoration: const InputDecoration(
              labelText: '最低价',
              hintText: '请输入最小值',
              border: OutlineInputBorder(),
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
            decoration: const InputDecoration(
              labelText: '最高价',
              hintText: '请输入最大值',
              border: OutlineInputBorder(),
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
