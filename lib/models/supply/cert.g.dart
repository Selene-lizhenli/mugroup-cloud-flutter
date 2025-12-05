// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CertImpl _$$CertImplFromJson(Map<String, dynamic> json) => _$CertImpl(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['remark'] as String?,
    );

Map<String, dynamic> _$$CertImplToJson(_$CertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remark': instance.remark,
    };
