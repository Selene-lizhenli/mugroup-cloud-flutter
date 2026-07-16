// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionImpl _$$InspectionImplFromJson(Map<String, dynamic> json) =>
    _$InspectionImpl(
      (json['id'] as num?)?.toInt(),
      (json['type'] as num?)?.toInt(),
      json['name'] as String?,
      json['remark'] as String?,
      json['notes'] as String?,
      (json['status'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      (json['collaborators'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['items'] as List<dynamic>?)
          ?.map((e) => InspectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      _inspectionDynamicTemplateIdFromJson(
          json['inspection_dynamic_template_id']),
      _inspectionDynamicTemplateJsonFromJson(
          json['inspection_dynamic_template_json']),
      json['inspection_dynamic_template'] == null
          ? null
          : InspectionDynamicTemplate.fromJson(
              json['inspection_dynamic_template'] as Map<String, dynamic>),
      json['created_at'] as String?,
    );

Map<String, dynamic> _$$InspectionImplToJson(_$InspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'remark': instance.remark,
      'notes': instance.notes,
      'status': instance.status,
      'user': instance.user,
      'collaborators': instance.collaborators,
      'items': instance.items,
      'media': instance.media,
      'inspection_dynamic_template_id': _inspectionDynamicTemplateIdToJson(
          instance.inspectionDynamicTemplateId),
      'inspection_dynamic_template_json': _inspectionDynamicTemplateJsonToJson(
          instance.inspectionDynamicTemplateJson),
      'inspection_dynamic_template': instance.inspectionDynamicTemplate,
      'created_at': instance.createdAt,
    };
