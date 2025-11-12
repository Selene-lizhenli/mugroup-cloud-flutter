import 'package:cloud/models/supply/supplier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
class Quote with _$Quote {
  factory Quote(
    int? id,
    Supplier? supplier,
    String? packing,
    @JsonKey(name: 'outer_capacity') String? outerCapacity,
    @JsonKey(name: 'outer_volume') String? outerVolume,
    @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
    @JsonKey(name: 'sample_location') String? sampleLocation,
    @JsonKey(name: 'record_user') String? recordUser,
    @JsonKey(name: 'can_bill') bool? canBill,
    @JsonKey(name: 'tax_rate') String? taxRate,
    @JsonKey(name: 'purchase_cost') String? purchaseCost,
    @JsonKey(name: 'currency') String? currency,
  ) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
