import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventoryItems.freezed.dart';
part 'inventoryItems.g.dart';

@freezed
abstract class InventoryItems with _$InventoryItems {
  const factory InventoryItems({
    int? id,
    @JsonKey(name: 'inventory_id') int? inventoryId,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'previous_qty') int? previousQty,
    @JsonKey(name: 'new_qty') int? newQty,
  }) = _InventoryItems;

  factory InventoryItems.fromJson(Map<String, Object?> json) =>
      _$InventoryItemsFromJson(json);
}
