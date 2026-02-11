import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 筛选底部抽屉内容：竖向 Tab - 排序、价格区间
class FilterContent extends HookConsumerWidget {
  const FilterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final selectedTabIndex = useState(0);
    final priceMinController =
        useTextEditingController(text: state.priceMin ?? '');
    final priceMaxController =
        useTextEditingController(text: state.priceMax ?? '');
    final colorScheme = Theme.of(context).colorScheme;

    return Container( 
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  notifier.setPriceRange(
                    priceMinController.text.trim().isEmpty
                        ? null
                        : priceMinController.text.trim(),
                    priceMaxController.text.trim().isEmpty
                        ? null
                        : priceMaxController.text.trim(),
                  );
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
                  padding: const EdgeInsets.all(20),
                  child: selectedTabIndex.value == 0
                      ? _SortContent(
                          currentSort: state.sortOrder,
                          onSortChanged: notifier.setSortOrder,
                        )
                      : _PriceRangeContent(
                          minController: priceMinController,
                          maxController: priceMaxController,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
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
      color: selected ? colorScheme.surface : Colors.transparent,
      child: InkWell(
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

/// 排序单选项：价格降序、价格升序
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
          title: const Text('价格降序'),
          value: kSortPriceDesc,
          groupValue: currentSort,
          onChanged: (v) => onSortChanged(v),
        ),
        RadioListTile<String?>(
          title: const Text('价格升序'),
          value: kSortPriceAsc,
          groupValue: currentSort,
          onChanged: (v) => onSortChanged(v),
        ),
      ],
    );
  }
}

/// 价格区间：最小值、最大值输入框
class _PriceRangeContent extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;

  const _PriceRangeContent({
    required this.minController,
    required this.maxController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: minController,
          decoration: const InputDecoration(
            labelText: '最低价',
            hintText: '请输入最小值',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: maxController,
          decoration: const InputDecoration(
            labelText: '最高价',
            hintText: '请输入最大值',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
