import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmItem extends HookWidget {
  final CartItem? item;

  const ConfirmItem({super.key, this.item});
  @override
  Widget build(BuildContext context) {
    var cover = item?.sample.image?.elementAtOrNull(0)?.thumbUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cover != null
            ? CachedNetworkImage(
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                imageUrl: cover,
              )
            : Image.asset(
                'assets/noImage.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item?.sample.id}'),
                Text('${item?.count}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
