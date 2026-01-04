import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/router/router.gr.dart';
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
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图片
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
              // 标题和加入购物车按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Expanded(
                      child: Text(
                        sample.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 加入购物车按钮
                    if (onTapAddSample != null)
                      GestureDetector(
                        onTap: onTapAddSample,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
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
                            if (cartCount != null && cartCount! > 0)
                              Positioned(
                                top: -10,
                                right: -8,
                                child: TDBadge(
                                  TDBadgeType.message,
                                  color: colorScheme.primary,
                                  showZero: false,
                                  count: cartCount.toString(),
                                ),
                              )
                          ],
                        ),
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
