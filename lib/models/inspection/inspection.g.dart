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
      (json['collaborators'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['items'] as List<dynamic>?)
          ?.map((e) => InspectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['created_at'] as String?,
    );

Map<String, dynamic> _$$InspectionImplToJson(_$InspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'collaborators': instance.collaborators,
      'items': instance.items,
      'created_at': instance.createdAt,
    };
