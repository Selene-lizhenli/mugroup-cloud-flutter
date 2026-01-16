import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart'; 
import 'package:cloud/pages/quote/widgets/sample_detail_card.dart'; 
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_pagination.dart';
import 'package:flutter/material.dart'; 
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
    final quoteDetailAsync = ref.watch(quoteDetailProvider(quotationId));
    final quoteCurrency = quoteDetailAsync.whenOrNull(
          data: (quote) => quote.curreny,
        ) ?? '';
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
                                    supplierNo: supplierNo.toString(),
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
                                  QuoteProductAddAdaptiveRoute( 
                                    supplierId: supplierId.toString(), 
                                  ),
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
                      quoteCurrency,
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
    String quoteCurrency,
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
          quoteCurrency,
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
    String quoteCurrency,
    VoidCallback onRefresh,
  ) {
    return ProductDetailCard(
      data: row,
      imageUrl: imageUrl,
      quoteId: quotationId,
      quoteCurrency: quoteCurrency,
      refreshCallback: onRefresh,
      supplierShow: false,
    );
  }
}
