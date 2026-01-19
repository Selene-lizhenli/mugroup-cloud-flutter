import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_pagination.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/supplier_add_sheet.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/supplier/supplier_list.dart';
import 'package:cloud/pages/quote/widgets/sample_detail_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';

class ProductSection extends HookConsumerWidget {
  final int? quoteId;
  const ProductSection({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteDetailProvider);
    final notifier = ref.read(quoteDetailProvider.notifier);
    final selectedTab = useState(0); // 0: 供应商列表/验货, 1: 产品清单
    final selectedSupplierIds = useState<Set<int>>({});

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(14, 3, 14, 3),
        child: SizedBox(
          child: Column(
            children: [
              // ===== 头部 =====
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('报价产品', style: theme.textTheme.titleMedium),
                    Row(
                      children: [
                        ActionPillButton(
                          label: '批量导入',
                          icon: Icons.download,
                          backgroundColor: colorScheme.primary,
                          textColor: Colors.white,
                          onTap: () {
                            context.router.push(
                              ProductBatchImportRoute(
                                quotationId: quoteId,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ActionPillButton(
                          label: '新增产品',
                          icon: Icons.add,
                          backgroundColor: colorScheme.secondary, // 蓝色
                          textColor: colorScheme.onSecondary,
                          onTap: () {
                            if (selectedTab.value == 0) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) =>
                                    SupplierAddSheet(quotationId: quoteId),
                              );
                              return;
                            }

                            if (selectedTab.value == 1) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AddProductModeDialog(quoteId: quoteId),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // ===== 标签页导航 =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TabButton(
                    label: '供应商列表(${state.suppliers.length})',
                    // icon: Icons.store_mall_directory_outlined,
                    icon: Icons.factory_outlined,
                    isSelected: selectedTab.value == 0,
                    onTap: () => selectedTab.value = 0,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _TabButton(
                    label: '产品清单(${state.productTotalCount})',
                    icon: Icons.view_list,
                    isSelected: selectedTab.value == 1,
                    onTap: () => selectedTab.value = 1,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: selectedTab.value == 1
                    ? _buildProductList(
                        context, state, colorScheme, notifier, quoteId)
                    : _buildSupplierList(context, state, colorScheme, notifier,
                        selectedSupplierIds, quoteId),
              ),
            ],
          ),
        ));
  }

  Widget _buildProductList(BuildContext context, QuoteDetailState state,
      ColorScheme colorScheme, notifier, int? quoteId) {
    if (state.isProductLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.productError != null) {
      return Center(
        child: Text(
          '产品加载失败',
          style: TextStyle(color: colorScheme.error),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
          child: Text(
        '暂无产品',
        style: TextStyle(color: colorScheme.surfaceContainerHighest),
      ));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      itemCount: state.products.length + 1, // +1 for pagination
      separatorBuilder: (_, index) {
        // 最后一个分隔符用于分页组件
        if (index == state.products.length - 1) {
          return const SizedBox(height: 8);
        }
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        // 如果是最后一项，显示分页组件
        if (index == state.products.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PaginationBar(
              currentPage: state.productPage,
              totalPages: state.productTotalPages,
              onPageChanged: (page) {
                if (quoteId != null) {
                  notifier.fetchProductsPage(quoteId, page);
                }
              },
            ),
          );
        }
        final row = state.products[index];
        final sample = row.showroomSample;

        final imageUrl = sample?.image?.isNotEmpty == true
            ? sample!.image!.first.thumbUrl
            : null;
        if (sample == null) {
          return const SizedBox.shrink();
        }

        return ProductDetailCard(
          data: row,
          imageUrl: imageUrl,
          quoteId: quoteId,
          quoteCurrency: state.baseInfo?.curreny ?? '',
          supplierShow: true,
          refreshCallback: () =>
              notifier.fetchProductsPage(quoteId, state.productPage),
        );
      },
    );
  }

  Widget _buildSupplierList(
    BuildContext context,
    QuoteDetailState state,
    ColorScheme colorScheme,
    notifier,
    ValueNotifier<Set<int>> selectedSupplierIds,
    int? quoteId,
  ) {
    if (state.isSupplierLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.supplierError != null) {
      return Center(
        child: Text(
          '供应商加载失败',
          style: TextStyle(color: colorScheme.error),
        ),
      );
    }

    return SupplierListWidget(
      suppliers: state.suppliers,
      products: state.products,
      selectedSupplierIds: selectedSupplierIds.value,
      onSupplierToggle: (supplierId) {
        if (supplierId == null) return;
        final newSet = Set<int>.from(selectedSupplierIds.value);
        if (newSet.contains(supplierId)) {
          newSet.remove(supplierId);
        } else {
          newSet.add(supplierId);
        }
        selectedSupplierIds.value = newSet;
      },
      onSupplierTap: (supplier) {
        if (quoteId != null && supplier.supplier?.id != null) {
          context.router.push(
            SupplierProductsRoute(
              quotationId: quoteId,
              supplierId: supplier.supplier!.id!,
              supplierNo: supplier.supplier?.supplierNo ?? '',
              supplierName: supplier.supplier?.name ?? '',
            ),
          );
        }
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.secondary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductModeDialog extends HookWidget {
  final int? quoteId;

  const AddProductModeDialog({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context) {
    final isAiMode = useState(false);

    final aiSubOptionIndex = useState(0);
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('添加产品', style: theme.textTheme.titleLarge),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('录入模式',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ModeSelectionCard(
                    label: '手动信息录入',
                    isSelected: !isAiMode.value,
                    onTap: () => isAiMode.value = false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeSelectionCard(
                    label: 'AI自动信息录入',
                    isSelected: isAiMode.value,
                    onTap: () => isAiMode.value = true,
                  ),
                ),
              ],
            ),
            if (isAiMode.value) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    _SubOptionCard(
                      label: '写在 [地板/白板] 模式',
                      isSelected: aiSubOptionIndex.value == 0,
                      onTap: () => aiSubOptionIndex.value = 0,
                    ),
                    const SizedBox(height: 8),
                    _SubOptionCard(
                      label: '写在 [记事本页] 模式',
                      isSelected: aiSubOptionIndex.value == 1,
                      onTap: () => aiSubOptionIndex.value = 1,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                onPressed: () {
                  if (!isAiMode.value) {
                    Navigator.of(context).pop();
                    context.router.push(QuoteProductAddAdaptiveRoute(
                      initialMode: 0,
                    ));
                  }
                  if (isAiMode.value) {
                    if (aiSubOptionIndex.value == 0) {
                      Navigator.of(context).pop();
                      context.router.push(QuoteProductAiAddFloorRoute(
                        quoteId: quoteId,
                      ));
                    }
                    if (aiSubOptionIndex.value == 1) {
                      Navigator.of(context).pop();
                      context.router.push(QuoteProductAiAddNotepadRoute(
                        quoteId: quoteId,
                      ));
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text('继续创建产品'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSelectionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeSelectionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? colorScheme.primary.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? colorScheme.primary : Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubOptionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey.shade700,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
