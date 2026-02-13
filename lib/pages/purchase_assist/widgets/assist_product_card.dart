 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart'; 
import 'package:flutter/material.dart'; 

class AssistProductCard extends StatelessWidget {
  final PurchaseAssistSearchProduct sample;

  final GestureTapCallback? onTap;

  final int? cartCount;

  const AssistProductCard({
    super.key,
    required this.sample,
    this.onTap,
    this.cartCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
 
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
                        if (sample.price != null)
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
