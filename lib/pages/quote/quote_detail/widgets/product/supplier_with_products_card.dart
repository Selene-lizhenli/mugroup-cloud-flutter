import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 供应商及其商品卡片组件
class SupplierWithProductsCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);

    final shortName = supplier?.shortName;
    final name = supplier?.name;
    final label = (shortName != null && shortName.isNotEmpty)
        ? shortName
        : (name != null && name.isNotEmpty)
            ? name
            : '未知供应商';
    return Container(
      decoration: BoxDecoration( 
        borderRadius: BorderRadius.circular(8), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 供应商标题
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: GestureDetector(
              onTap: onSupplierTap,
              child: Row(
                children: [
                  Text(
                    '$label(${products.length})',
                    style: theme.textTheme.titleSmall?.copyWith(   ),
                  ),
                  if (onSupplierTap != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: products.length + 1,
                itemBuilder: (context, index) {
                  final totalCount = products.length + 1;
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < totalCount - 1 ? 8 : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: () async {
                            await context.router.push(
                              QuoteProductAddAdaptiveRoute(
                                initialMode: 0,
                                supplierId: supplierId?.toString(),
                              ),
                            );
                          
                              await quoteDetailNotifier.fetchQuoteDetail(
                                quoteId!,
                              );
                          
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.white,
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 36,
                              color: colorScheme.outline.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final product = products[index - 1];
                  final sample = product.showroomSample;
                  // 使用 cover getter，它会自动处理 thumbUrl 和 url 的回退逻辑
                  final imageUrl = sample?.cover;
                  logger
                      .d('Product image URL: $imageUrl, sample: ${sample?.id}');
                  final sampleId = sample?.id;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < totalCount - 1 ? 8 : 0,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: () {
                            if (sampleId == null) return;
                            if (!context.mounted) return;
                            context.router.push(
                              ShowroomSampleDetailRoute(id: sampleId),
                            );
                          },
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? ImageShow(
                                  imageUrl: imageUrl,
                                  width: products.length>=2?80:20,
                                  height:products.length>=2?80:20,
                                  fit: BoxFit.cover,
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
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: colorScheme.outline),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
