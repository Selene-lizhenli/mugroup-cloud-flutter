import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_receipt_mixed_carton.freezed.dart';
part 'warehouse_receipt_mixed_carton.g.dart';

/// Identifies one physical mixed carton shared by multiple item entries.
@freezed
abstract class WarehouseReceiptMixedCarton with _$WarehouseReceiptMixedCarton {
  const factory WarehouseReceiptMixedCarton({
    int? id,
    @JsonKey(name: 'receipt_id') int? receiptId,
    String? code,
    @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
    @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
    @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
    @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
    @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
    @JsonKey(name: 'entries_count') int? entriesCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WarehouseReceiptMixedCarton;

  factory WarehouseReceiptMixedCarton.fromJson(Map<String, Object?> json) =>
      _$WarehouseReceiptMixedCartonFromJson(json);
}
