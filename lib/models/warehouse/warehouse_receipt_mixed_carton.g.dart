// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_receipt_mixed_carton.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseReceiptMixedCartonImpl _$$WarehouseReceiptMixedCartonImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseReceiptMixedCartonImpl(
      id: (json['id'] as num?)?.toInt(),
      receiptId: (json['receipt_id'] as num?)?.toInt(),
      code: json['code'] as String?,
      actualOuterCapacity: (json['actual_outer_capacity'] as num?)?.toInt(),
      actualOuterLength: json['actual_outer_length'] as num?,
      actualOuterWidth: json['actual_outer_width'] as num?,
      actualOuterHeight: json['actual_outer_height'] as num?,
      actualOuterGrossWeight: json['actual_outer_gross_weight'] as num?,
      entriesCount: (json['entries_count'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WarehouseReceiptMixedCartonImplToJson(
        _$WarehouseReceiptMixedCartonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receipt_id': instance.receiptId,
      'code': instance.code,
      'actual_outer_capacity': instance.actualOuterCapacity,
      'actual_outer_length': instance.actualOuterLength,
      'actual_outer_width': instance.actualOuterWidth,
      'actual_outer_height': instance.actualOuterHeight,
      'actual_outer_gross_weight': instance.actualOuterGrossWeight,
      'entries_count': instance.entriesCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
