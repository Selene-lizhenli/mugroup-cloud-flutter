import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ProductCardDetailed extends HookConsumerWidget {
  final Sample sample;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapAddSample;

  final int? cartCount;

  const ProductCardDetailed({
    super.key,
    required this.sample,
    this.onTap,
    this.onTapAddSample,
    this.cartCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemTypeSpan = _buildItemTypeSpan(context);

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
        onTap: onTap,
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
                          if (itemTypeSpan != null) itemTypeSpan,
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
                            )
                          ],
                          if (sample.barcode != null)
                            Flexible(
                              child: Text(
                                sample.barcode!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                        ],
                      ),
                    ),
                    if (sample.category != null)
                      TDTag(
                        sample.category!.name!,
                        isLight: true,
                        theme: TDTagTheme.warning,
                        size: TDTagSize.medium,
                      ),

                    // 贸易国别
                    if (sample.tradeCountry != null)
                      Container(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "贸易国别",
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            TDTag(
                              sample.tradeCountry!,
                              isLight: true,
                              size: TDTagSize.small,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    // 价格
                    Row(
                      children: [
                        if (sample.purchaseCost != null && showPrice)
                          RichText(
                            text: TextSpan(
                              children: [
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
                                if (sample.hasTaxRate == true)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        showTaxRatePrice
                                            ? '(含税率 ${sample.taxRate!}%)'
                                            : '(已扣除税率 ${sample.taxRate!}%)',
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
              // 工厂报价
              // if (sample.supplyQuotes?.isNotEmpty == true) ...[
              //   const TDDivider(
              //     text: '工厂报价',
              //     alignment: TextAlignment.center,
              //   ),
              //   Container(
              //     padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              //     child: EasyRefresh.builder(
              //       onRefresh: () async {
              //         await context.router
              //             .push(ShowroomSampleDetailRoute(id: sample.id!));
              //       },
              //       header: const ClassicHeader(
              //         triggerOffset: 40,
              //         spacing: 5,
              //         dragText: "查看更多",
              //         armedText: '前往详情',
              //         readyText: "前往详情",
              //         processedText: "操作成功",
              //         processingText: "前往详情",
              //         showMessage: false,
              //       ),
              //       childBuilder: (context, physics) => CarouselSlider(
              //         options: CarouselOptions(
              //           height: 130,
              //           scrollPhysics: physics,
              //           reverse: true,
              //           viewportFraction:
              //               sample.supplyQuotes!.length > 1 ? 0.9 : 1,
              //           padEnds: false,
              //           initialPage: sample.supplyQuotes != null
              //               ? sample.supplyQuotes!.length - 1
              //               : 0,
              //           enableInfiniteScroll: false,
              //         ),
              //         items: [
              //           for (var (index, supplyQuote)
              //               in sample.supplyQuotes!.reversed.indexed)
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.stretch,
              //               children: [
              //                 Expanded(
              //                   child: _ProductSupplyQuote(
              //                     supplyQuote: supplyQuote,
              //                   ),
              //                 ),
              //                 if (index != 0)
              //                   const TDDivider(
              //                     width: 0.3,
              //                     height: double.infinity,
              //                     margin: EdgeInsets.symmetric(horizontal: 5),
              //                   ),
              //               ],
              //             ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ]
            ],
          ),
        ),
      ),
    );
  }

  WidgetSpan? _buildItemTypeSpan(BuildContext context) {
    String? itemType = sample.itemType;
    if (itemType == null) {
      return null;
    }

    final colorMap = {
      "japan": Colors.yellow[800],
      "market_product": Colors.red
    };
    final labelMap = {"japan": "日本产品", "market_product": "内部"};

    final label = labelMap[itemType];
    final bg = colorMap[itemType] ?? Colors.grey;

    if (label == null) {
      return null;
    }

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 2,
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
