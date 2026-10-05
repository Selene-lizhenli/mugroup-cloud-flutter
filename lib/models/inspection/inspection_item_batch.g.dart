// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_item_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionItemBatchImpl _$$InspectionItemBatchImplFromJson(
        Map<String, dynamic> json) =>
    _$InspectionItemBatchImpl(
      id: (json['id'] as num?)?.toInt(),
      taskId: (json['task_id'] as num?)?.toInt(),
      itemId: (json['item_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      batchNo: json['batch_no'] as String?,
      status: (json['status'] as num?)?.toInt(),
      ctns: (json['ctns'] as num?)?.toInt(),
      unitPerCtn: (json['unit_per_ctn'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toInt(),
      raw: _rawMapFromJson(json['raw']),
      remark: json['remark'] as String?,
      stdBarcode: json['std_barcode'] as String?,
      scanBarcode: json['scan_barcode'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      rounds: _roundsFromJson(json['rounds']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      duplicateCount: (json['duplicate_count'] as num?)?.toInt(),
      batchNoSequence: (json['batch_no_sequence'] as num?)?.toInt(),
      inspectorName: json['inspector_name'] as String?,
      round: (json['round'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InspectionItemBatchImplToJson(
        _$InspectionItemBatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'item_id': instance.itemId,
      'user_id': instance.userId,
      'batch_no': instance.batchNo,
      'status': instance.status,
      'ctns': instance.ctns,
      'unit_per_ctn': instance.unitPerCtn,
      'qty': instance.qty,
      'raw': _rawMapToJson(instance.raw),
      'remark': instance.remark,
      'std_barcode': instance.stdBarcode,
      'scan_barcode': instance.scanBarcode,
      'media': instance.media,
      'rounds': instance.rounds,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'duplicate_count': instance.duplicateCount,
      'batch_no_sequence': instance.batchNoSequence,
      'inspector_name': instance.inspectorName,
      'round': instance.round,
    };
