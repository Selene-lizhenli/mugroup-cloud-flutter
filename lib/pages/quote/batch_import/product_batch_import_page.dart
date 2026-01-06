import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route.dart' show PageInfo;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers/product_batch_import_provider.dart';
import 'widgets/product_list_sheet.dart';

@RoutePage()
class ProductBatchImportPage extends HookConsumerWidget {
  static const String routeName = 'ProductBatchImportRoute';
  static PageInfo page = PageInfo(
    routeName,
    builder: (data) => const ProductBatchImportPage(),
  );

  const ProductBatchImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productBatchImportProvider);
    final notifier = ref.read(productBatchImportProvider.notifier);

    final batchQtyController = useTextEditingController(text: '1');

    void applyBatchQty() {
      final newQty = batchQtyController.text;
      for (final item in state.selected) {
        notifier.updateSelectedQty(item.id, newQty.isEmpty ? item.qty : newQty);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加报价产品'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    title: '选择产品',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '供应商',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        _SelectTile(
                          label: state.supplierName ?? '请选择供应商',
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const SupplierSelect(),
                            );
                            if (result is Map<String, dynamic>) {
                              final name = (result['short_name'] ??
                                      result['name'] ??
                                      '') as String;
                              final id = result['id'] as int?;
                              if (id != null && name.isNotEmpty) {
                                await notifier.setSupplier(id, name);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '产品',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        _SelectTile(
                          label: '已选 ${state.selected.length} 个产品',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (_) => const ProductListSheet(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: '已选产品 (${state.selected.length}个)',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '批量设置数量',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 80,
                              child: Input(
                                label: '',
                                value: batchQtyController.text,
                                onChanged: (v) => batchQtyController.text = v,
                                keyboardType: TextInputType.number,
                                showClearButton: false,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: applyBatchQty,
                              child: const Text('应用'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...state.selected.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ProductCard(
                              item: item,
                              onQtyChanged: (v) {
                                notifier.updateSelectedQty(item.id, v);
                              },
                              onPriceChanged: (v) {
                                notifier.updateSelectedPrice(item.id, v);
                              },
                              onDelete: () {
                                notifier.removeSelected(item.id);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('保存添加 (${state.selected.length}个产品)'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCover(String? url) {
  if (url == null ||
      url.isEmpty ||
      !(url.startsWith('http://') || url.startsWith('https://'))) {
    return const Icon(Icons.image_not_supported);
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SelectTile({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final SelectedProduct item;
  final ValueChanged<String> onQtyChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.item,
    required this.onQtyChanged,
    required this.onPriceChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 图片
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: _buildCover(item.image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SKU: ${item.sku}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Input(
                  label: '数量',
                  value: item.qty,
                  keyboardType: TextInputType.number,
                  showClearButton: false,
                  onChanged: onQtyChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Input(
                  label: '供应商报价 (CNY)',
                  value: item.supplierPrice,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  showClearButton: false,
                  onChanged: onPriceChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}