import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Sample sample;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapAddSample;

  final int? cartCount;

  const ProductCard({
    super.key,
    required this.sample,
    this.onTap,
    this.onTapAddSample,
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
            ],
          ),
        ),
      ),
    );
  }
}
