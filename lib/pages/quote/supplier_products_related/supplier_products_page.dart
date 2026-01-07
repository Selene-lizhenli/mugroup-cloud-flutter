import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_edit_dialog.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplierProductsPage extends HookConsumerWidget {
  final int quotationId;
  final int supplierId;
  final String supplierNo;
  final String supplierName;

  const SupplierProductsPage({
    super.key,
    @pathParam required this.quotationId,
    @pathParam required this.supplierId,
    @pathParam required this.supplierNo,
    @pathParam required this.supplierName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isLoading = useState(true);
    final products = useState<List<QuotationSample>>([]);
    final currentPage = useState(1);
    final totalPages = useState(1);
    final error = useState<String?>(null);

    Future<void> fetchProducts({bool showLoading = false}) async {
      try {
        if (showLoading) {
          isLoading.value = true;
        }
        error.value = null;

        final params = {
          "page": currentPage.value,
          "pageSize": 10,
          if (supplierId > 0) "supplier_id": supplierId,
        };
        final resp =
            await getQuotationProductListByProductId(quotationId, params);
        products.value = resp.data;
        totalPages.value = resp.meta?.pagination?.totalPages ?? 1;
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchProducts(showLoading: true);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('供应商产品列表'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchProducts(showLoading: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // 供应商信息卡片
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  color: colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '供应商: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    supplierName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // 产品列表区域
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // 标题和操作按钮
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 20,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '产品清单',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ActionPillButton(
                              label: '批量导入',
                              icon: Icons.download,
                              backgroundColor: colorScheme.primary,
                              textColor: colorScheme.onPrimary,
                              onTap: () {
                                context.router.push(
                                  ProductBatchImportRoute(
                                    quotationId: quotationId,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            ActionPillButton(
                              label: '新增产品',
                              icon: Icons.add,
                              backgroundColor: colorScheme.secondary,
                              textColor: colorScheme.onSecondary,
                              onTap: () {
                                context.router.push(
                                  QuoteProductPadAddRoute(quoteId: quotationId),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // 产品列表
                  Expanded(
                    child: _buildProductList(
                      context,
                      isLoading.value,
                      error.value,
                      products.value,
                      colorScheme,
                      theme,
                      currentPage.value,
                      totalPages.value,
                      () => fetchProducts(showLoading: true),
                      (page) {
                        currentPage.value = page;
                        fetchProducts(showLoading: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    bool isLoading,
    String? error,
    List<QuotationSample> products,
    ColorScheme colorScheme,
    ThemeData theme,
    int currentPage,
    int totalPages,
    VoidCallback onRefresh,
    ValueChanged<int> onPageChanged,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '加载失败',
              style: TextStyle(color: colorScheme.error),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRefresh,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          '暂无产品',
          style: TextStyle(color: colorScheme.surfaceContainerHighest),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: products.length + 1, // +1 for pagination
      separatorBuilder: (_, index) {
        if (index == products.length - 1) {
          return const SizedBox(height: 8);
        }
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        if (index == products.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PaginationBar(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
            ),
          );
        }

        final row = products[index];
        final sample = row.showroomSample;
        final imageUrl = sample?.image?.isNotEmpty == true
            ? sample!.image!.first.thumbUrl
            : null;

        if (sample == null) {
          return const SizedBox.shrink();
        }

        return _buildProductItem(
          context,
          row,
          sample,
          imageUrl,
          colorScheme,
          theme,
          onRefresh,
        );
      },
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    QuotationSample row,
    dynamic sample,
    String? imageUrl,
    ColorScheme colorScheme,
    ThemeData theme,
    VoidCallback onRefresh,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 产品编号和操作按钮
          Row(
            children: [
              Expanded(
                child: Text(
                  sample.productNo ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => ProductEditDialog(row: row),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  await _handleDeleteProduct(context, row.id, onRefresh);
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
              const SizedBox(width: 8),
              // 验货状态标签
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: Colors.red,
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: const Text(
              //     '未验货',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 8),
              // 开始验货按钮
              ElevatedButton(
                onPressed: () {
                  // TODO: 实现验货功能
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal:12, vertical: 3),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                ),
                child: const Text(
                  '开始验货',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ), 
          // 产品信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 产品图片
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.hardEdge,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported,
                              size: 24);
                        },
                      )
                    : const Icon(Icons.image_not_supported, size: 24),
              ),
              const SizedBox(width: 12),
              // 产品详情
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        '供应商货号 ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        sample.productNo ?? '-',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '客户报价(EUR)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          row.price ?? '0.000',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '采购数量',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${row.qty ?? 0}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteProduct(
      BuildContext context, int? productId, VoidCallback onRefresh) async {
    if (productId == null) return;
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
      "quotation_id": quotationId,
    };
    try {
      await removeQuotationSamples(params);
      EasyLoading.showSuccess('删除成功');
      onRefresh();
    } catch (e) {
      EasyLoading.showError('删除失败：$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

}
