// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QrcodeImpl _$$QrcodeImplFromJson(Map<String, dynamic> json) => _$QrcodeImpl(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$$QrcodeImplToJson(_$QrcodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'code': instance.code,
    };
