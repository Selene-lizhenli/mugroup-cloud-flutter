import 'package:cloud/models/wms/inventoryItem.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

@freezed
abstract class Inventory with _$Inventory {
  const factory Inventory({
    int? id,
    String? status,
    @JsonKey(name: 'order_no') String? orderNo,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'items') List<InventoryItem>? items,
  }) = _Inventory;

  factory Inventory.fromJson(Map<String, Object?> json) =>
      _$InventoryFromJson(json);
}
