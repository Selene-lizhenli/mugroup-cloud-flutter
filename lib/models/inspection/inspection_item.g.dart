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
      json['barcode'] as String?,
      json['std_barcode'] as String?,
      json['scan_barcode'] as String?,
      json['description'] as String?,
      (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['task_id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      (json['sample_id'] as num?)?.toInt(),
      json['item_no'] as String?,
      (json['unit_per_ctn'] as num?)?.toInt(),
      json['created_at'] as String?,
      _inspectionDynamicTemplateIdFromJson(
          json['inspection_dynamic_template_id']),
      _inspectionDynamicTemplateJsonFromJson(
          json['inspection_dynamic_template_json']),
      _rawMapFromJson(json['raw']),
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
      'barcode': instance.barcode,
      'std_barcode': instance.stdBarcode,
      'scan_barcode': instance.scanBarcode,
      'description': instance.description,
      'media': instance.media,
      'task_id': instance.taskId,
      'user_id': instance.userId,
      'sample_id': instance.sampleId,
      'item_no': instance.itemNo,
      'unit_per_ctn': instance.unitPerCtn,
      'created_at': instance.createdAt,
      'inspection_dynamic_template_id': _inspectionDynamicTemplateIdToJson(
          instance.inspectionDynamicTemplateId),
      'inspection_dynamic_template_json': _inspectionDynamicTemplateJsonToJson(
          instance.inspectionDynamicTemplateJson),
      'raw': _rawMapToJson(instance.raw),
    };
