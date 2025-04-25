import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/widgets/quote_item.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SampleItem extends HookWidget {
  final Sample sample;
  final CartType? cartType;
  final String? price;
  final int? count;
  final QuotationInfo? quotationInfo;
  final ValueChanged<int>? onChange;

  const SampleItem({
    super.key,
    required this.sample,
    this.cartType,
    this.price,
    this.quotationInfo,
    this.count,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    double? finalPrice;
    String? displayPrice;
    Map<String, String> symbols = {
      "CNY": "¥",
      "USD": "\$",
      "EUR": "€",
      "GBP": "£",
    };
    final quotes = useState<List<Quote>?>([]);
    final loading = useState<bool>(false);
    final symbol = symbols[quotationInfo?.curreny] ?? "¥";
    if (sample.purchaseCost != null) {
      finalPrice = double.parse(sample.purchaseCost!) /
          (quotationInfo?.exchange ?? 1) *
          (1 + ((quotationInfo?.commissionRate ?? 0) * 0.01));
    }

    if (cartType == CartType.quotation) {
      displayPrice = sample.purchaseCost != null
          ? '$symbol ${price ?? finalPrice?.toStringAsFixed(2)}'
          : "";
    } else {
      displayPrice =
          sample.purchaseCost != null ? '¥${sample.purchaseCost}' : "";
    }

    var cover = sample.image?.elementAtOrNull(0)?.thumbUrl ??
        sample.image?.elementAtOrNull(0)?.url;

    return AppExpansionTile(
      title: Text(
        sample.nameCn ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onForward: () async {
        try {
          loading.value = true;
          final resp =
              await getSupplyQuotes(queryParameters: {"sample_id": sample.id});
          quotes.value = resp.data;
        } finally {
          loading.value = false;
        }
      },
      subtitle: Row(
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
                    sample.productNo ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    sample.spec ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(displayPrice,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(color: Colors.red)),
                      if (cartType != CartType.quotation)
                        FlanStepper(
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
      ),
      child: loading.value == true
          ? const CircularProgressIndicator()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: quotes.value?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    QuoteItem(item: quotes.value![index]),
                    if (index < quotes.value!.length - 1)
                      const Divider(
                        height: 1.0,
                        color: Colors.grey,
                      ),
                  ],
                );
              },
              physics: const NeverScrollableScrollPhysics(),
            ),
    );
  }
}
