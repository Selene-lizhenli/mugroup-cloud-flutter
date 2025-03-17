import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WmsTransferConfirmItem extends HookWidget {
  final Sample product;

  final int? inQty;
  final int? outQty;

  final int? count;

  final ValueChanged<int>? onChange;

  const WmsTransferConfirmItem({
    super.key,
    required this.product,
    this.inQty,
    this.outQty,
    this.count,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var cover = product.image?.elementAtOrNull(0)?.thumbUrl ??
        product.image?.elementAtOrNull(0)?.url;
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
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nameCn ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  product.productNo ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        product.purchaseCost != null
                            ? '¥${product.purchaseCost}'
                            : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.red)),
                    FlanStepper(
                      max: outQty ?? 0,
                      min: inQty ?? 0,
                      value: count,
                      onChange: (v, _) {
                        if (v is int) {
                          onChange?.call(v);
                        } else {
                          onChange?.call(int.parse(v.toString()));
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
