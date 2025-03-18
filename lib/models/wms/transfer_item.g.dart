// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferItemImpl _$$TransferItemImplFromJson(Map<String, dynamic> json) =>
    _$TransferItemImpl(
      (json['id'] as num?)?.toInt(),
      json['product'] == null
          ? null
          : Sample.fromJson(json['product'] as Map<String, dynamic>),
      (json['in_qty'] as num?)?.toInt(),
      (json['out_qty'] as num?)?.toInt(),
      json['notes'] as String?,
    );

Map<String, dynamic> _$$TransferItemImplToJson(_$TransferItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'in_qty': instance.inQty,
      'out_qty': instance.outQty,
      'notes': instance.notes,
    };
