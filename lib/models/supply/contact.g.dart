// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['mobile'] as String?,
      json['department'] as String?,
      json['sex'] as String?,
      json['position'] as String?,
      json['phone'] as String?,
      json['fax'] as String?,
      json['email'] as String?,
      json['qq'] as String?,
      json['wechat'] as String?,
      json['remark'] as String?,
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobile': instance.mobile,
      'department': instance.department,
      'sex': instance.sex,
      'position': instance.position,
      'phone': instance.phone,
      'fax': instance.fax,
      'email': instance.email,
      'qq': instance.qq,
      'wechat': instance.wechat,
      'remark': instance.remark,
    };
