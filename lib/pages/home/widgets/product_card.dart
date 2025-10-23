import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Sample sample;

  const ProductCard({super.key, required this.sample});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sample.nameCn!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
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
                      child: Text(
                        sample.category!.name!,
                        style: const TextStyle(fontSize: 9),
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '¥',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF03380),
                          ),
                        ),
                        TextSpan(
                          text: sample.purchaseCost,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF03380),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
