// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventoryItems.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemsImpl _$$InventoryItemsImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemsImpl(
      id: (json['id'] as num?)?.toInt(),
      inventoryId: (json['inventory_id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      previousQty: (json['previous_qty'] as num?)?.toInt(),
      newQty: (json['new_qty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InventoryItemsImplToJson(
        _$InventoryItemsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventory_id': instance.inventoryId,
      'product_id': instance.productId,
      'previous_qty': instance.previousQty,
      'new_qty': instance.newQty,
    };
