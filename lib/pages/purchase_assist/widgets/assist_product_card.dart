import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssistProductCard extends HookConsumerWidget {
  final PurchaseAssistSearchProduct sample;

  final GestureTapCallback? onTap;

  final int? cartCount;
  final String platformType;

  const AssistProductCard({
    super.key,
    required this.sample,
    required this.platformType,
    this.onTap,
    this.cartCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final quotationInfo =
        ref.watch(cartProvider.select((state) => state.quotationInfo));
    final showPrice = quotationInfo?.showPrice ?? false;
    final shouldShowPrice =
        sample.price != null && (platformType != 'cloud' || showPrice);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sample.imageUrl == null || sample.imageUrl!.isEmpty
                  ? Image.asset(
                      'assets/icons/no_image.png',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.contain,
                      imageUrl: sample.imageUrl!,
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
                    const SizedBox(height: 5),
                    // 价格
                    Row(
                      children: [
                        if (shouldShowPrice)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "¥",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: sample.price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.secondary,
                                  ),
                                ),
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
