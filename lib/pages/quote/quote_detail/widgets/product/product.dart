import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/products_with_supplie_card.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';

class ProductSection extends HookConsumerWidget {
  final int? quoteId;
  const ProductSection({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteDetailProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 供应商分组改为：完全基于产品列表中的 supplyQuote.supplierId

    final Map<int, List<QuotationSample>> grouped = {};
    final List<int> supplierOrder = [];
    final Map<int, Supplier?> supplierInfo = {};
    int unknownKeySeed = -1;

    for (final p in state.products) {
      final id = p.supplyQuote?.supplierId;
      final key = id ?? (unknownKeySeed--);

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
        supplierOrder.add(key);
      }
      grouped[key]!.add(p);

      // 尽量保存供应商快照信息（如果有）
      final s = p.supplyQuote?.supplier;
      if (id != null && s != null) {
        supplierInfo[id] = s;
      }
    }

    return Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(16, 3, 16, 3),
        child: SizedBox(
          child: Column(children: [
            // ===== 头部 =====
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ActionPillButton(
                        label: '供应商',
                        icon: Icons.add,
                        backgroundColor: colorScheme.secondary,
                        textColor: colorScheme.onSecondary,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context)
                                  .size
                                  .width, // 底部抽屉宽度占满屏幕
                            ),
                            builder: (context) =>
                                AddSupplierSheet(quotationId: quoteId),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionPillButton(
                        label: '导入',
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
                    ],
                  )
                ],
              ),
            ),
            if (state.isProductLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: MuProgressIndicator(),
                ),
              ),
            ] else if (state.products.isEmpty) ...[
              Empty(
                // icon: Icons.search,
                padding: 100,
                textSpans: [
                  WidgetSpan(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '暂无产品，',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context)
                                    .size
                                    .width, // 底部抽屉宽度占满屏幕
                              ),
                              builder: (context) =>
                                  AddSupplierSheet(quotationId: quoteId),
                            );
                          },
                          child: Text(
                            '去添加供应商？',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              Column(
                children: [
                  for (var i = 0; i < supplierOrder.length; i++) ...[
                    Builder(builder: (context) {
                      final supplierKey = supplierOrder[i];
                      final supplierProducts =
                          grouped[supplierKey] ?? const <QuotationSample>[];
                      final supplierId = supplierKey > 0 ? supplierKey : null;
                      final supplier =
                          supplierId != null ? supplierInfo[supplierId] : null;

                      return SupplierWithProductsCard(
                        supplier: supplier,
                        supplierId: supplierId,
                        products: supplierProducts,
                        supplierIndex: i + 1,
                        colorScheme: colorScheme,
                        theme: Theme.of(context),
                        quoteId: quoteId,
                        onSupplierTap: () {
                          if (quoteId != null && supplierId != null) {
                            context.router.push(
                              SupplierProductsRoute(
                                quotationId: quoteId!,
                                supplierId: supplierId,
                                supplierNo: supplier?.supplierNo ?? '',
                                supplierName: supplier?.name ?? '',
                              ),
                            );
                          }
                        },
                      );
                    }),
                    if (i < supplierOrder.length - 1)
                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withOpacity(0.6),
                      ),
                  ],
                ],
              ),
            ],
          ]),
        ));
  }
}
