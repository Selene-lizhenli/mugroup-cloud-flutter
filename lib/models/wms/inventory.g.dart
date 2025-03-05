// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryImpl _$$InventoryImplFromJson(Map<String, dynamic> json) =>
    _$InventoryImpl(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      orderNo: json['order_no'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InventoryImplToJson(_$InventoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'order_no': instance.orderNo,
      'user_id': instance.userId,
      'items': instance.items,
    };
