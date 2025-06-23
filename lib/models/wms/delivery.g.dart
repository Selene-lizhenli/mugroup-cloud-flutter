// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryImpl _$$DeliveryImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryImpl(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['order_no'] as String?,
      remark: json['remark'] as String?,
      status: $enumDecodeNullable(_$DeliveryStatusEnumMap, json['status']),
      warehouse: json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      itemSumQty: (json['item_sum_qty'] as num?)?.toInt(),
      itemCountQty: (json['item_count_qty'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => DeliveryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DeliveryImplToJson(_$DeliveryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'remark': instance.remark,
      'status': _$DeliveryStatusEnumMap[instance.status],
      'warehouse': instance.warehouse,
      'user': instance.user,
      'item_sum_qty': instance.itemSumQty,
      'item_count_qty': instance.itemCountQty,
      'items': instance.items,
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.finished: 'finished',
};
