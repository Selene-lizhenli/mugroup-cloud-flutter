import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/sample/sample_extensions.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/samples/samples_l10n_helper.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/widgets/quote_item.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; 
import 'package:collection/collection.dart';
class SampleItem extends HookConsumerWidget {
  final Sample sample;
  final CartType? cartType;
  final String? price;
  final int? count;
  final QuotationInfo? quotationInfo;
  final ValueChanged<int>? onChange;
  final String? xTenantId;

  const SampleItem({
    super.key,
    required this.sample,
    this.cartType,
    this.price,
    this.quotationInfo,
    this.count,
    this.onChange,
    this.xTenantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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

    final showPrice = quotationInfo?.showPrice ?? false;
    final showTaxRatePrice = quotationInfo?.showTaxRatePrice ?? false;

    // 不含税率价格
    double getPriceWithoutTax(Sample sample, bool showTaxRatePrice) {
      // 将 purchaseCost 转成 double
      final cost = double.tryParse(sample.purchaseCost ?? '') ?? 0.0;

      // 将 taxRate 从 String 转成 double
      final rate = double.tryParse(sample.taxRate ?? '') ?? 0.0;

      if (!showTaxRatePrice) {
        return cost / (1 + rate * 0.01);
      }
      return cost;
    }

    var purchaseCost = getPriceWithoutTax(sample, showTaxRatePrice);

    final symbol = symbols[quotationInfo?.curreny] ?? "¥";

    // 计算换算后的最终价格
    finalPrice = purchaseCost /
        (quotationInfo?.exchange ?? 1) *
        (1 + ((quotationInfo?.commissionRate ?? 0) * 0.01));

    // 设置展示价格
    if (cartType == null || cartType == CartType.quotation) {
      // 类型是1.报价选样车 2.没有选择选样车；时 购物车都显示调整后价格
      displayPrice = sample.purchaseCost != null
          ? price ?? finalPrice.toStringAsFixed(2)
          : "";
    } else {
      displayPrice =
          sample.purchaseCost != null ? '${sample.purchaseCost}' : "";
    }
// --------------------处理独立样品间租户名称tag------------------------------------------------------
    // 有 xTenantId 表示列表曾带 X-Tenant-ID；展示名从 core 租户列表按 id 匹配。
    final cloud = ref.watch(coreProvider).value;
    final tenants = cloud?.tenants ?? const <Tenant>[];
    final xTenantKey = sample.xTenantId?.trim();
    final parsedTenantId = xTenantKey != null ? int.tryParse(xTenantKey) : null;
    final matchedTenant = xTenantKey == null || xTenantKey.isEmpty
        ? null
        : tenants.firstWhereOrNull(
            (t) => parsedTenantId != null
                ? t.id == parsedTenantId
                : t.id?.toString() == xTenantKey,
          );
    final tenantName = matchedTenant?.title?.trim()??'';
// --------------------------------------------------------------------------

    var cover = sample.image?.elementAtOrNull(0)?.thumbUrl ??
        sample.image?.elementAtOrNull(0)?.url;

    final request = useCallback((int sampleId) async {
      try {
        loading.value = true;
        final resp =
            await getSupplyQuotes(queryParameters: {"sample_id": sampleId});
        quotes.value = resp.data;
      } finally {
        loading.value = false;
      }
    }, []);

    return AppExpansionTile(
      title: Text(
        sample.localizedName(preferChinese: samplesPreferChinese(context)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onForward: () async {
        request(sample.id!);
      },
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              cover != null
                  ? CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      imageUrl: cover,
                    )
                  : Image.asset(
                      'assets/icons/no_image.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
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
                  if (sample.pageNo != null && sample.pageNo != "-")
                    Text(
                      l10n.cartSamplePageNo(sample.pageNo!),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  if (showPrice)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: symbol,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.secondary,
                            ),
                          ),
                          TextSpan(
                            text: displayPrice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary,
                            ),
                          ),
                          if (sample.hasTaxRate == true)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  sampleTaxRateHint(
                                    context,
                                    showTaxRatePrice: showTaxRatePrice,
                                    taxRate: sample.taxRate!,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (xTenantId != null)
                    Container(
                        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                        decoration: BoxDecoration(
                            color: colorScheme.outline.withOpacity(0.3)),
                        child: Text(
                          tenantName,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.outline,
                          ),
                        )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: SizedBox.shrink(),
                      ),
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
          ? const MuProgressIndicator()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: quotes.value?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    QuoteItem(item: quotes.value![index]),
                    if (index < quotes.value!.length - 1)
                      Divider(
                        height: 1.0,
                        color: Colors.grey[200],
                      ),
                  ],
                );
              },
              physics: const NeverScrollableScrollPhysics(),
            ),
    );
  }
}
