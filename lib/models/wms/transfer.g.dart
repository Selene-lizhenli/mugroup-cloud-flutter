// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['order_no'] as String?,
      outWarehouse: json['out_warehouse'] as String?,
      inWarehouse: json['in_warehouse'] as String?,
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$TransferStatusEnumMap, json['status']),
      transferAt: json['transfer_at'] == null
          ? null
          : DateTime.parse(json['transfer_at'] as String),
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'out_warehouse': instance.outWarehouse,
      'in_warehouse': instance.inWarehouse,
      'creator': instance.creator,
      'status': _$TransferStatusEnumMap[instance.status],
      'transfer_at': instance.transferAt?.toIso8601String(),
      'remark': instance.remark,
    };

const _$TransferStatusEnumMap = {
  TransferStatus.draft: 'draft',
  TransferStatus.finished: 'finished',
  TransferStatus.processing: 'processing',
  TransferStatus.cancelled: 'cancelled',
};
