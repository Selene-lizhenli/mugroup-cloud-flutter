import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/models/state.dart';

/// 根据报价设置计算样品最终展示价。
///
/// 采购价不含税时，按税率映射除去对应实际税率（如 13% → 10% 则除以 1.10），
/// 再叠加汇率与佣金比率。
String resolveSampleFinalPrice(
  Sample sample, {
  QuotationInfo? quotationInfo,
  bool? showTaxRatePrice,
  double? exchange,
  double? commissionRate,
  Map<String, double>? taxRateMapping,
}) {
  final includeTax = showTaxRatePrice ?? quotationInfo?.showTaxRatePrice ?? false;
  final rate = exchange ?? quotationInfo?.exchange ?? 1.0;
  final commission = commissionRate ?? quotationInfo?.commissionRate ?? 0.0;
  final mapping = taxRateMapping ?? quotationInfo?.taxRateMapping;

  final rawCost = double.tryParse(sample.purchaseCost ?? '') ?? 0.0;
  final taxRate = double.tryParse(sample.taxRate ?? '') ?? 0.0;

  double baseCost = rawCost;
  if (!includeTax) {
    final mappedRate = resolveMappedTaxRate(
      taxRate: taxRate,
      taxRateRaw: sample.taxRate,
      taxRateMapping: mapping,
    );
    baseCost = rawCost / (1 + mappedRate * 0.01);
  }
  final price = (baseCost / rate) * (1 + commission * 0.01);
  return  price.toStringAsFixed(2) ;
}

/// 税率映射 key 与弹窗一致（如 "13"）；兼容 "13.0" 等写法。
double resolveMappedTaxRate({
  required double taxRate,
  String? taxRateRaw,
  Map<String, double>? taxRateMapping,
}) {
  if (taxRateMapping == null || taxRateMapping.isEmpty) return taxRate;
  final rawKey = taxRateRaw?.trim();
  final intKey =
      taxRate == taxRate.roundToDouble() ? '${taxRate.toInt()}' : null;
  return taxRateMapping[rawKey] ??
      (intKey != null ? taxRateMapping[intKey] : null) ??
      taxRateMapping['$taxRate'] ??
      taxRate;
}
