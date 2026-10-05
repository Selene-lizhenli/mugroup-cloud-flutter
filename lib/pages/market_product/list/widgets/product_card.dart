import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ProductCard extends HookConsumerWidget {
  final Sample sample;

  final GestureTapCallback? onTapAddSample;

  final int? cartCount;

  const ProductCard({
    super.key,
    required this.sample,
    this.onTapAddSample,
    this.cartCount,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    final quotationInfo =
        ref.watch(cartProvider.select((state) => state.quotationInfo));

    final showPrice = quotationInfo?.showPrice ?? false;
    final showTaxRatePrice = quotationInfo?.showTaxRatePrice ?? false;
    final exchange = quotationInfo?.exchange ?? 1.0;
    final commissionRate = quotationInfo?.commissionRate ?? 0.0;
    final currency = quotationInfo?.curreny ?? "CNY";

    final double rawCost = double.tryParse(sample.purchaseCost ?? '') ?? 0.0;
    final double taxRate = double.tryParse(sample.taxRate ?? '') ?? 0.0;

    double baseCost = rawCost;
    if (!showTaxRatePrice) {
      baseCost = rawCost / (1 + taxRate * 0.01);
    }

    double finalPriceValue =
        (baseCost / exchange) * (1 + commissionRate * 0.01);

    Map<String, String> symbols = {
      "CNY": "¥",
      "USD": "\$",
      "EUR": "€",
      "GBP": "£"
    };
    String symbol = symbols[currency] ?? "¥";
    String displayPrice = finalPriceValue.toStringAsFixed(2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () {
          if (context.mounted) {
            context.router.push(ShowroomSampleDetailRoute(id: sample.id!));

            return;
          }
        },
        child: Container(
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sample.cover == null
                  ? Image.asset(
                      'assets/icons/no_image.png',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.contain,
                      imageUrl: sample.cover!,
                      placeholder: (context, url) => AspectRatio(
                        aspectRatio: 1,
                        child: Container(),
                      ),
                    ),
              Container(
                height: 0.5,
                color: colorScheme.outlineVariant,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: sample.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                    ),
                    // 产品编号
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.surfaceContainerHighest,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (sample.productNo != null) ...[
                            Text(sample.productNo!),
                          ],
                          if (sample.barcode != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Container(
                                height: 8,
                                width: 0.5,
                                color: colorScheme.outline,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                sample.barcode!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ]
                        ],
                      ),
                    ),

                    if (sample.spec != null)
                      Text(
                        sample.spec!,
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        if (sample.purchaseCost != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                if (showPrice) ...[
                                  TextSpan(
                                    text: symbol,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: displayPrice,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                                if (sample.hasTaxRate == true)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        '(含税率 ${sample.taxRate!})',
                                        style: TextStyle(
                                          color: colorScheme
                                              .surfaceContainerHighest,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        if (onTapAddSample != null)
                          GestureDetector(
                            onTap: onTapAddSample,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      colorScheme.secondary.withOpacity(0.3),
                                  child: Icon(
                                    TDIcons.add,
                                    size: 14,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                Positioned(
                                  top: -10,
                                  right: -8,
                                  child: TDBadge(
                                    TDBadgeType.message,
                                    color: colorScheme.primary,
                                    showZero: false,
                                    count: cartCount != null
                                        ? cartCount.toString()
                                        : '',
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
