// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogImpl _$$LogImplFromJson(Map<String, dynamic> json) => _$LogImpl(
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      properties: json['properties'] as Map<String, dynamic>?,
      causer: json['causer'] == null
          ? null
          : User.fromJson(json['causer'] as Map<String, dynamic>),
      event: json['event'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$LogImplToJson(_$LogImpl instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'properties': instance.properties,
      'causer': instance.causer,
      'event': instance.event,
      'attachments': instance.attachments,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
