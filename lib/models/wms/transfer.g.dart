// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['order_no'] as String?,
      outWarehouse: json['outWarehouse'] == null
          ? null
          : Warehouse.fromJson(json['outWarehouse'] as Map<String, dynamic>),
      inWarehouse: json['inWarehouse'] == null
          ? null
          : Warehouse.fromJson(json['inWarehouse'] as Map<String, dynamic>),
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$TransferStatusEnumMap, json['status']),
      transferAt: json['transfer_at'] == null
          ? null
          : DateTime.parse(json['transfer_at'] as String),
      remark: json['remark'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransferItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'outWarehouse': instance.outWarehouse,
      'inWarehouse': instance.inWarehouse,
      'creator': instance.creator,
      'status': _$TransferStatusEnumMap[instance.status],
      'transfer_at': instance.transferAt?.toIso8601String(),
      'remark': instance.remark,
      'items': instance.items,
    };

const _$TransferStatusEnumMap = {
  TransferStatus.draft: 'draft',
  TransferStatus.finished: 'finished',
  TransferStatus.processing: 'processing',
  TransferStatus.cancelled: 'cancelled',
};
