import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 供应商及其商品卡片组件
class SupplierWithProductsCard extends ConsumerStatefulWidget {
  final Supplier? supplier;
  final int? supplierId;
  final List<QuotationSample> products;
  final int supplierIndex;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final VoidCallback? onSupplierTap;
  final int? quoteId;

  const SupplierWithProductsCard({
    super.key,
    required this.supplier,
    required this.supplierId,
    required this.products,
    required this.supplierIndex,
    required this.colorScheme,
    required this.theme,
    this.onSupplierTap,
    this.quoteId,
  });

  @override
  ConsumerState<SupplierWithProductsCard> createState() =>
      _SupplierWithProductsCardState();
}

class _SupplierWithProductsCardState
    extends ConsumerState<SupplierWithProductsCard> {
  int? _longPressedIndex; // 跟踪哪个商品被长按了（显示删除按钮）
  static int countLimit = 20;
  static double rowHeight = 100;
  static double mainAxisSpacing = 5;
  static double crossAxisSpacing = 5;

  @override
  Widget build(BuildContext context) {
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);

    final shortName = widget.supplier?.shortName;
    final name = widget.supplier?.name;
    final label = (shortName != null && shortName.isNotEmpty)
        ? shortName
        : (name != null && name.isNotEmpty)
            ? name
            : '未知供应商';
    final products = widget.products;
    final productsLength = products.length;
    final useTwoRows = productsLength >= countLimit;
    final colorScheme = widget.colorScheme;
    final onSupplierTap = widget.onSupplierTap;
    final quoteId = widget.quoteId;
    final supplierId = widget.supplierId;
    final theme = widget.theme;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 供应商卡片标题区域
          GestureDetector(
            onTap: onSupplierTap,
            child: Row(
              children: [
                Text(
                  '$label(${products.length})',
                  style: theme.textTheme.titleSmall?.copyWith(),
                ),
                if (onSupplierTap != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ],
                const Spacer(),
                ActionPillButton(
                  label: '新增',
                  icon: Icons.add,
                  // backgroundColor: colorScheme.secondary,
                  textColor: colorScheme.primary,
                  fontSize: 13,
                  onTap: () async {
                    await context.router.push(
                      QuoteProductNewAddRoute(
                        quoteId: 0,
                        supplierId: supplierId?.toString(),
                      ),
                    );
                    await quoteDetailNotifier.fetchQuoteDetail(
                      quoteId!,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 商品图片列表（可左右滑动）
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '暂无商品',
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: useTwoRows ? rowHeight * 2 : rowHeight,
              child: useTwoRows
                  ? GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio: 1,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) => _buildProductItem(
                          context, index, productsLength, quoteDetailNotifier),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: products.length,
                      itemBuilder: (context, index) => _buildProductItem(
                          context, index, productsLength, quoteDetailNotifier),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    int index,
    int productsLength,
    QuoteDetailNotifier quoteDetailNotifier,
  ) {
    final totalCount = widget.products.length;
    final product = widget.products[index];
    final sample = product.showroomSample;
    final imageUrl = sample?.cover;
    final sampleId = sample?.id;
    final productId = product.id;
    final isLongPressed = _longPressedIndex == index;
    final double itemSize = productsLength >= countLimit ? 90 : 90;

    logger.d('Product image URL: $imageUrl, sample: ${sample?.id}');

    return Padding(
      padding: EdgeInsets.only(
        right: index < totalCount - 1 ? 8 : 0,
      ),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            _longPressedIndex = index;
          });
        },
        onTap: () {
          if (isLongPressed) {
            setState(() {
              _longPressedIndex = null;
            });
            return;
          }
          if (sampleId == null) return;
          if (!context.mounted) return;
          context.router.push(
            ShowroomSampleDetailRoute(id: sampleId),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: itemSize,
              height: itemSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color:
                    widget.colorScheme.surfaceContainerHighest.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? ImageShow(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 26, color: widget.colorScheme.outline),
                            const SizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'IMAGENOT AVAILABLE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize:
                                        productsLength >= countLimit ? 6 : 8,
                                    color: widget.colorScheme.outline),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            if (isLongPressed && productId != null)
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: rowHeight - mainAxisSpacing * 2,
                  height: rowHeight - crossAxisSpacing * 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _handleDeleteProduct(
                          context,
                          productId,
                          quoteDetailNotifier,
                        ),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: widget.colorScheme.error,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.delete_outlined,
                            size: 16,
                            color: widget.colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 处理删除商品
  Future<void> _handleDeleteProduct(
    BuildContext context,
    int productId,
    QuoteDetailNotifier quoteDetailNotifier,
  ) async {
    // 先隐藏删除按钮
    setState(() {
      _longPressedIndex = null;
    });

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
      "quotation_id": widget.quoteId,
    };
    logger.d('删除参数: $params');
    try {
      await removeQuotationSamples(params);
      EasyLoading.showSuccess('删除成功');
      // 刷新报价单详情
      if (widget.quoteId != null) {
        await quoteDetailNotifier.fetchQuoteDetail(widget.quoteId!);
      }
    } catch (e) {
      EasyLoading.showError('删除失败：$e');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
