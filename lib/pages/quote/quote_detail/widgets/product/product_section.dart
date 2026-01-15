import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_pagination.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/supplier/supplier_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_edit_dialog.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    final selectedTab = useState(1); // 0: 供应商列表/验货, 1: 产品清单
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
                                userId: state.baseInfo?.user?.id,
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
                    label: '供应商列表',
                    // icon: Icons.store_mall_directory_outlined,
                    icon: Icons.factory_outlined,
                    isSelected: selectedTab.value == 0,
                    onTap: () => selectedTab.value = 0,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _TabButton(
                    label: '产品清单',
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
    final theme = Theme.of(context);
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
        // 获取供应商编号
        final supplierNo = row.supplyQuote?.supplier?.supplierNo ?? '';
        final supplierName = row.supplyQuote?.supplier?.name ?? '';
        final supplierDisplay = supplierNo.isNotEmpty
            ? '供应商:$supplierNo'
            : (supplierName.isNotEmpty ? '供应商:$supplierName' : '供应商:-');

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 供应商信息和操作按钮 =====
              Row(
                children: [
                  Text(
                    supplierDisplay,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () async {
                      if (quoteId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('报价单ID不能为空')),
                        );
                        return;
                      }
                      final Map<String, String>? data = await showDialog(
                        context: context,
                        builder: (_) => ProductEditDialog(
                          row: row,
                          quotationId: quoteId,
                        ),
                      );

                      if (data != null) {
                        final values = {
                          "supply_quote": {
                            "shipping_qty": data['shipping_qty'],
                            "purchase_cost": data['purchase_cost'],
                            "customer_price": data['customer_price'],
                            "internal_sku": data['internal_sku'],
                            "supplier_sku": data['supplier_sku'],
                            "customer_sku": data['customer_sku']
                          }
                        };

                        await updateShowroomQuotationSample(row.id!, values);
                      }

                      // 刷新产品列表
                      if (context.mounted) {
                        await notifier.fetchProductsPage(
                            quoteId, state.productPage);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 移除产品
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () async {
                      await _handleDeleteProductFromList(
                        context: context,
                        quoteId: quoteId,
                        productId: row.id,
                        notifier: notifier,
                        page: state.productPage,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ===== 产品信息 =====
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    final id = sample.id;
                    if (id == null) return;
                    if (!context.mounted) return;
                    context.router.push(ShowroomSampleDetailRoute(id: id));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== 产品图片 =====
                      _ProductImage(imageUrl: imageUrl),
                      const SizedBox(width: 12),
                      // ===== 产品信息 =====
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _KeyValue(
                              label: '公司货号',
                              value: (row.supplyQuote?.internalSku ?? 0)
                                  .toString(),
                              highlight: false,
                            ),
                            const SizedBox(height: 4),
                            _KeyValue(
                              label: '客户报价(CNY)',
                              value: (row.supplyQuote?.customerPrice ?? 0)
                                  .toString(),
                              highlight: false,
                            ),
                            const SizedBox(height: 4),
                            _KeyValue(
                              label: '供应商报价(CNY)',
                              value: (row.supplyQuote?.purchaseCost ?? 0)
                                  .toString(),
                              highlight: false,
                            ),
                            const SizedBox(height: 4),
                            _KeyValue(
                              label: '采购数量',
                              value: (row.supplyQuote?.shippingQty ?? 0)
                                  .toString(),
                              highlight: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> _handleDeleteProductFromList({
    required BuildContext context,
    required int? quoteId,
    required int? productId,
    required dynamic notifier,
    required int page,
  }) async {
    if (productId == null || quoteId == null) return;
    final confirmed = await ConfirmDialog.show(
      context,
      title: '确认删除',
      content: '确定要删除该产品吗？',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (!confirmed || !context.mounted) return;

    EasyLoading.show(status: '删除中...');
    final params = {
      'ids': [productId],
      "quotation_id": quoteId,
    };
    try {
      await removeQuotationSamples(params);
      await notifier.fetchProductsPage(quoteId, page);
      EasyLoading.showSuccess('删除成功');
    } catch (e) {
      EasyLoading.showError('删除失败：$e');
    } finally {
      EasyLoading.dismiss();
    }
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

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported, size: 24),
                      SizedBox(height: 4),
                      Text(
                        'IMAGE\nNOT AVAILABLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported,
                      size: 24, color: colorScheme.outline),
                  const SizedBox(height: 4),
                  Text(
                    'IMAGE NOT AVAILABLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 8, color: colorScheme.outline),
                  ),
                ],
              ),
            ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool priceStyle;

  const _KeyValue({
    required this.label,
    required this.value,
    this.highlight = false,
    this.priceStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 12,
              color: priceStyle
                  ? colorScheme.primary
                  : (highlight ? colorScheme.primary : colorScheme.onSurface),
              fontWeight: (priceStyle || highlight)
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
