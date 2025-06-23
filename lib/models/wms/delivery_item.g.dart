// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryItemImpl _$$DeliveryItemImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryItemImpl(
      (json['id'] as num?)?.toInt(),
      json['product'] == null
          ? null
          : Sample.fromJson(json['product'] as Map<String, dynamic>),
      (json['qty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DeliveryItemImplToJson(_$DeliveryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'qty': instance.qty,
    };
