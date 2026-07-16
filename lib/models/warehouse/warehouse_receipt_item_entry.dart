import 'package:cloud/models/warehouse/warehouse_location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_receipt_item_entry.freezed.dart';
part 'warehouse_receipt_item_entry.g.dart';

class _LocationConverter implements JsonConverter<WarehouseLocation?, Object?> {
  const _LocationConverter();

  @override
  WarehouseLocation? fromJson(Object? json) {
    if (json == null) return null;
    return WarehouseLocation.fromJson(json as Map<String, dynamic>);
  }

  @override
  Object? toJson(WarehouseLocation? object) => null;
}

@freezed
abstract class WarehouseReceiptItemEntry with _$WarehouseReceiptItemEntry {
  const factory WarehouseReceiptItemEntry({
    int? id,
    @JsonKey(name: 'item_id') int? itemId,
    @JsonKey(name: 'location_id') int? locationId,
    @_LocationConverter()
    @JsonKey(name: 'location')
    WarehouseLocation? location,
    @JsonKey(name: 'actual_carton_qty') num? actualCartonQty,
    @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
    @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
    @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
    @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
    @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
    @JsonKey(name: 'entered_at') DateTime? enteredAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WarehouseReceiptItemEntry;

  factory WarehouseReceiptItemEntry.fromJson(Map<String, Object?> json) =>
      _$WarehouseReceiptItemEntryFromJson(json);
}
