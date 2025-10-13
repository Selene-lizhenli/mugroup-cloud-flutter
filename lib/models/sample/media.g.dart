// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemporaryMediaImpl _$$TemporaryMediaImplFromJson(Map<String, dynamic> json) =>
    _$TemporaryMediaImpl(
      id: (json['id'] as num).toInt(),
      thumbUrl: json['thumb_url'] as String?,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$TemporaryMediaImplToJson(
        _$TemporaryMediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thumb_url': instance.thumbUrl,
      'url': instance.url,
    };
