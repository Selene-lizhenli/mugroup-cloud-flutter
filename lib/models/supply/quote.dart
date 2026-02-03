import 'package:cloud/models/supply/supplier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
class Quote with _$Quote {
  factory Quote(
    int? id,
    int? moq,
    Supplier? supplier,
    String? packing,
    String? material,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'outer_capacity') String? outerCapacity,
    @JsonKey(name: 'outer_volume') String? outerVolume,
    @JsonKey(name: 'outer_gross_weight') String? outerGrossWeight,
    @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
    @JsonKey(name: 'sample_location') String? sampleLocation,
    @JsonKey(name: 'record_user') String? recordUser,
    @JsonKey(name: 'can_bill') bool? canBill,
    @JsonKey(name: 'tax_rate') String? taxRate,
    @JsonKey(name: 'purchase_cost') String? purchaseCost,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'supplier_product_no') String? supplierProductNo,
    @JsonKey(name: 'shipping_qty') int? shippingQty,
    @JsonKey(name: 'customer_price') String? customerPrice,
    @JsonKey(name: 'supplier_price') String? supplierPrice,
    @JsonKey(name: 'internal_sku') String? internalSku,
    @JsonKey(name: 'supplier_sku') String? supplierSku,
    @JsonKey(name: 'customer_sku') String? customerSku,
  ) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
