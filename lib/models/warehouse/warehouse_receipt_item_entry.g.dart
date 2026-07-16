// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_receipt_item_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseReceiptItemEntryImpl _$$WarehouseReceiptItemEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseReceiptItemEntryImpl(
      id: (json['id'] as num?)?.toInt(),
      itemId: (json['item_id'] as num?)?.toInt(),
      locationId: (json['location_id'] as num?)?.toInt(),
      location: const _LocationConverter().fromJson(json['location']),
      actualCartonQty: json['actual_carton_qty'] as num?,
      actualOuterCapacity: (json['actual_outer_capacity'] as num?)?.toInt(),
      actualOuterLength: json['actual_outer_length'] as num?,
      actualOuterWidth: json['actual_outer_width'] as num?,
      actualOuterHeight: json['actual_outer_height'] as num?,
      actualOuterGrossWeight: json['actual_outer_gross_weight'] as num?,
      enteredAt: json['entered_at'] == null
          ? null
          : DateTime.parse(json['entered_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WarehouseReceiptItemEntryImplToJson(
        _$WarehouseReceiptItemEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'location_id': instance.locationId,
      'location': const _LocationConverter().toJson(instance.location),
      'actual_carton_qty': instance.actualCartonQty,
      'actual_outer_capacity': instance.actualOuterCapacity,
      'actual_outer_length': instance.actualOuterLength,
      'actual_outer_width': instance.actualOuterWidth,
      'actual_outer_height': instance.actualOuterHeight,
      'actual_outer_gross_weight': instance.actualOuterGrossWeight,
      'entered_at': instance.enteredAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
