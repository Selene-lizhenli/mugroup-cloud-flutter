import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuotationItem extends HookWidget {
  final Sample sample;
  final QuotationInfo? quotationInfo;
  const QuotationItem({
    super.key,
    required this.sample,
    this.quotationInfo,
  });

  @override
  Widget build(BuildContext context) {
    double? price;
    Map<String, String> symbols = {
      "CNY": "¥",
      "USD": "\$",
      "EUR": "€",
      "GBP": "£",
    };
    final symbol = symbols[quotationInfo?.curreny] ?? "¥";
    if (sample.purchaseCost != null) {
      price = double.parse(sample.purchaseCost!) /
          (quotationInfo?.exchange ?? 1) *
          (1 + ((quotationInfo?.commissionRate ?? 0) * 0.01));
    }

    var cover = sample.image?.elementAtOrNull(0)?.thumbUrl ??
        sample.image?.elementAtOrNull(0)?.url;
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
            height: 105,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sample.nameCn ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  sample.productNo ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        sample.purchaseCost != null
                            ? '$symbol ${price?.toStringAsFixed(2)}'
                            : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.red)),
                    TextButton(
                        onPressed: () {
                          logger.d("调价");
                        },
                        child: const Text("调价"))
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
