import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
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
                ? CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/showroom/image/352796/84c3f40a2e924fb0836ecd2b03424744_origin.jpg",
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
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '¥',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF03380),
                          ),
                        ),
                        TextSpan(
                          text: '99',
                          style: TextStyle(
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
