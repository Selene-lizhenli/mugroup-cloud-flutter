// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionItemImpl _$$InspectionItemImplFromJson(Map<String, dynamic> json) =>
    _$InspectionItemImpl(
      (json['id'] as num?)?.toInt(),
      (json['type'] as num?)?.toInt(),
      json['name'] as String?,
      (json['status'] as num?)?.toInt(),
      (json['ctns'] as num?)?.toInt(),
      (json['qty'] as num?)?.toInt(),
      json['remark'] as String?,
      (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['task_id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      (json['sample_id'] as num?)?.toInt(),
      json['item_no'] as String?,
      (json['unit_per_ctn'] as num?)?.toInt(),
      json['created_at'] as String?,
    );

Map<String, dynamic> _$$InspectionItemImplToJson(
        _$InspectionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'status': instance.status,
      'ctns': instance.ctns,
      'qty': instance.qty,
      'remark': instance.remark,
      'media': instance.media,
      'task_id': instance.taskId,
      'user_id': instance.userId,
      'sample_id': instance.sampleId,
      'item_no': instance.itemNo,
      'unit_per_ctn': instance.unitPerCtn,
      'created_at': instance.createdAt,
    };
