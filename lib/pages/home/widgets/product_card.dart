import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ProductCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sample.cover == null
                  ? Image.asset(
                      'assets/noImage.png',
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
                color: Colors.grey[200]!.withOpacity(0.8),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sample.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                    // 产品编号
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
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
                                color: Colors.grey[500]!.withOpacity(0.8),
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
                            const TDTag(
                              '贸易国别',
                              isLight: true,
                              size: TDTagSize.small,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              sample.tradeCountry!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6F6F6F),
                              ),
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
                        if (sample.purchaseCost != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '¥',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: sample.purchaseCost,
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
                                        '(含税率 ${sample.taxRate!})',
                                        style: const TextStyle(
                                          color: Colors.grey,
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
                                    color: colorScheme.secondary,
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
              if (sample.supplyQuotes?.isNotEmpty == true) ...[
                const TDDivider(
                  text: '工厂报价',
                  alignment: TextAlignment.center,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: EasyRefresh(
                    onRefresh: () async {
                      await context.router
                          .push(ShowroomSampleDetailRoute(id: sample.id!));
                    },
                    header: const ClassicHeader(
                      triggerOffset: 40,
                      spacing: 5,
                      dragText: "查看更多",
                      armedText: '前往详情',
                      readyText: "前往详情",
                      processedText: "操作成功",
                      processingText: "前往详情",
                      showMessage: false,
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: null,
                        reverse: true,
                        viewportFraction:
                            sample.supplyQuotes!.length > 1 ? 0.9 : 1,
                        padEnds: false,
                        initialPage: sample.supplyQuotes != null
                            ? sample.supplyQuotes!.length - 1
                            : 0,
                        enableInfiniteScroll: false,
                      ),
                      items: [
                        for (var (index, supplyQuote)
                            in sample.supplyQuotes!.reversed.indexed)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _ProductSupplyQuote(
                                  supplyQuote: supplyQuote,
                                ),
                              ),
                              if (index != 0)
                                const TDDivider(
                                  width: 0.3,
                                  height: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSupplyQuote extends StatelessWidget {
  final Quote supplyQuote;
  const _ProductSupplyQuote({required this.supplyQuote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tdTheme = TDTheme.of(context);
    final supplier = supplyQuote.supplier;
    final location = supplier?.city ?? supplier?.province;

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (supplier != null)
            GestureDetector(
              onTap: () {
                context.router
                    .push(SupplySupplierDetailRoute(id: supplier.id!));
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    if (location != null)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: tdTheme.grayColor2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              child: Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    TextSpan(
                      text: supplier.name ?? '',
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _currencySymbol(supplyQuote.currency),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.secondary,
                      ),
                    ),
                    TextSpan(
                      text: supplyQuote.purchaseCost,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                    if (supplyQuote.taxRate != null)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            '(含税率 ${supplyQuote.taxRate})',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatBeijingTime(supplyQuote.chuhuoAt),
                style: TextStyle(
                  color: tdTheme.grayColor7,
                  fontSize: tdTheme.fontBodySmall!.size,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatBeijingTime(DateTime? time) {
    if (time == null) return '';

    final beijingTime = time.isUtc ? time.add(const Duration(hours: 8)) : time;

    final now = DateTime.now();
    final isThisYear = beijingTime.year == now.year;

    return DateFormat(isThisYear ? 'MM-dd' : 'yyyy-MM-dd').format(beijingTime);
  }

  String? _currencySymbol(String? currency) {
    String? symbol;
    if (currency == 'USD') {
      symbol = "\$";
    }
    if (currency == 'CNY') {
      symbol = '¥';
    }

    return symbol;
  }
}
