import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    int? id,
    @JsonKey(name: 'inventory_id') int? inventoryId,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'previous_qty') int? previousQty,
    @JsonKey(name: 'new_qty') int? newQty,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, Object?> json) =>
      _$InventoryItemFromJson(json);
}
