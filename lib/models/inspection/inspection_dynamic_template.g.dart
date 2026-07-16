// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_dynamic_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionDynamicTemplateImpl _$$InspectionDynamicTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$InspectionDynamicTemplateImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      inspectionScope: json['inspection_scope'] as String?,
    );

Map<String, dynamic> _$$InspectionDynamicTemplateImplToJson(
        _$InspectionDynamicTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inspection_scope': instance.inspectionScope,
    };
