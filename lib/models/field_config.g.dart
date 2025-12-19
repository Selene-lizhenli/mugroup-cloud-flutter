// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FieldConfigImpl _$$FieldConfigImplFromJson(Map<String, dynamic> json) =>
    _$FieldConfigImpl(
      label: json['label'] as String,
      name: json['name'] as String,
      isVisible: json['isVisible'] as bool? ?? true,
    );

Map<String, dynamic> _$$FieldConfigImplToJson(_$FieldConfigImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'name': instance.name,
      'isVisible': instance.isVisible,
    };
