import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
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
                      FlanTag(
                        type: FlanTagType.warning,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 3,
                          ),
                          child: Text(
                            sample.category!.name!,
                            style: const TextStyle(
                              fontSize: 10,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
