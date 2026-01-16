import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_pagination.dart';
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
                            context.router.push(QuoteProductAddAdaptiveRoute(
                              quoteId: quoteId,
                              initialMode: 0,
                            ));
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