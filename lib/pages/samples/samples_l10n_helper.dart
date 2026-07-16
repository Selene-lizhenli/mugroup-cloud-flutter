import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

bool samplesPreferChinese(BuildContext context) =>
    Localizations.localeOf(context).languageCode.startsWith('zh');

String sampleItemTypeLabel(BuildContext context, String itemType) {
  final l10n = context.l10n;
  switch (itemType) {
    case 'japan':
      return l10n.samplesItemTypeJapan;
    case 'market_product':
      return l10n.samplesItemTypeInternal;
    default:
      return '';
  }
}

String sampleTaxRateHint(
  BuildContext context, {
  required bool showTaxRatePrice,
  required String taxRate,
}) {
  final l10n = context.l10n;
  return showTaxRatePrice
      ? l10n.samplesTaxRateIncluded(taxRate)
      : l10n.samplesTaxRateExcluded(taxRate);
}

Color? sampleItemTypeColor(String itemType) {
  switch (itemType) {
    case 'japan':
      return Colors.yellow[800];
    case 'market_product':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

WidgetSpan? buildSampleItemTypeTextSpan(BuildContext context, String? itemType) {
  if (itemType == null) return null;

  final label = sampleItemTypeLabel(context, itemType);
  if (label.isEmpty) return null;

  final bg = sampleItemTypeColor(itemType) ?? Colors.grey;

  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Padding(
      padding: const EdgeInsets.only(right: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
