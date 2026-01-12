import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route.dart' show PageInfo;
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers/product_batch_import_provider.dart';
import 'widgets/selected_product_card.dart'; 

@RoutePage()
class ProductBatchImportPage extends HookConsumerWidget {
  static const String routeName = 'ProductBatchImportRoute';
  static PageInfo page = PageInfo(
    routeName,
    builder: (data) => const ProductBatchImportPage(),
  );

  final int? quotationId;
  final int? userId;

  const ProductBatchImportPage({
    super.key,
    this.quotationId,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productBatchImportProvider);
    final notifier = ref.read(productBatchImportProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final batchQtyController = useTextEditingController(text: '1');

    void applyBatchQty() {
      final newQty = batchQtyController.text;
      for (final item in state.selected) {
        notifier.updateSelectedQty(item.id, newQty.isEmpty ? item.qty : newQty);
      }
    }

    Future<void> handleSave() async {
      if (quotationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('报价单ID不能为空')),
        );
        return;
      }

      final sampleItems = state.selected.map((e) {
        final qty = int.tryParse(e.qty) ?? 1;
        // final supplierPrice = double.tryParse(e.supplierPrice) ?? 0.0;
        return {
          "sample_id": e.id,
          "qty": qty,
          // TODO 待调试接口加上
          // "supplier_price": supplierPrice,
          // 客户报价
        };
      }).toList();

      final data = {
        'quotation_id': quotationId,
        'sample_items': sampleItems,
      };

      final result = await addQuotationSamples(data);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('添加成功')),
        );
        // 保存成功后，跳转到报价单详情页面
        if (quotationId != null) {
          if (context.mounted) {
            // 先清空当前数据，然后关闭当前页面，再跳转到报价单详情页面
            notifier.clean();
            Navigator.of(context).pop();
            context.router.push(
              QuoteDetailRoute(
                id: quotationId!,
                userId: userId!,
              ),
            );
          }
        } else {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('添加失败')),
        );
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加报价产品'),
        centerTitle: true,
        backgroundColor: colorScheme.surfaceTint,
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
                                notifier.setSupplier(id, name);
                                // 选择完供应商后，自动打开产品选择弹窗
                                if (context.mounted) {
                                  final result = await context.router.push<List<Sample>>(SelectProductRoute(supplierId: id));
                                  if (result != null) {
                                    // 将选中的产品添加到批量导入列表中
                                    for (final sample in result) {
                                      if (sample.id != null) {
                                        notifier.toggleSelect(sample);
                                      }
                                    }
                                  }
                                }
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
                        GestureDetector(
                          onTap: () async {
                            if (state.supplierId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('请先选择供应商')),
                              );
                              return;
                            }
                            final result = await context.router.pushNamed<List<Sample>>(
                              '/selectors/product?supplierId=${state.supplierId}',
                            );
                            if (result != null) {
                              // 将选中的产品添加到批量导入列表中
                              for (final sample in result) {
                                if (sample.id != null) {
                                  notifier.toggleSelect(sample);
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorScheme.surfaceTint,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '已选 ${state.selected.length} 个产品',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_right,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.selected.isNotEmpty)
                    _SectionCard(
                      title: '已选产品 (${state.selected.length}个)',
                      batchQtyController: batchQtyController,
                      onBatchQtyChanged: applyBatchQty,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          ...state.selected.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SelectedProductCard(
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
                  onPressed: handleSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final TextEditingController? batchQtyController;
  final VoidCallback? onBatchQtyChanged;

  const _SectionCard({
    required this.title,
    required this.child,
    this.batchQtyController,
    this.onBatchQtyChanged,
  });

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
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (batchQtyController != null &&
                    onBatchQtyChanged != null) ...[
                  const Spacer(),
                  Text(
                    '批量设置数量',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 75,
                    child: Input(
                      label: '',
                      value: batchQtyController!.text,
                      onChanged: (v) {
                        batchQtyController!.text = v;
                        onBatchQtyChanged!();
                      },
                      keyboardType: TextInputType.number,
                      showClearButton: false,
                    ),
                  ),
                ],
              ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.surfaceTint,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
