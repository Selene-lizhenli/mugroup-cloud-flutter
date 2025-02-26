// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QrcodeImpl _$$QrcodeImplFromJson(Map<String, dynamic> json) => _$QrcodeImpl(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      code: json['code'] as String?,
      userId: json['user_id'] as String?,
      expiredAt: json['expired_at'] as String?,
      usedAt: json['used_at'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QrcodeImplToJson(_$QrcodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'code': instance.code,
      'user_id': instance.userId,
      'expired_at': instance.expiredAt,
      'used_at': instance.usedAt,
      'user': instance.user,
    };
