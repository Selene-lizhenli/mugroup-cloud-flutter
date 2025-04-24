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
    @JsonKey(name: 'outer_capacity') double? outerCapacity,
    @JsonKey(name: 'outer_volume') double? outerVolume,
    @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
    @JsonKey(name: 'sample_location') String? sampleLocation,
  ) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
