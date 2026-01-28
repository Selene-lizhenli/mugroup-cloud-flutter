// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['location'] as String?,
      json['position'] as String?,
      json['birthday'] as String?,
      json['tel_number'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      (json['whatsapp'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['linkedin'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['facebook'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['head'] == null
          ? null
          : User.fromJson(json['head'] as Map<String, dynamic>),
      json['mobile'] as String?,
      (json['logs'] as List<dynamic>?)
          ?.map((e) => Log.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'position': instance.position,
      'birthday': instance.birthday,
      'tel_number': instance.telNumber,
      'company_id': instance.companyId,
      'company': instance.company,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'linkedin': instance.linkedin,
      'facebook': instance.facebook,
      'head': instance.head,
      'mobile': instance.mobile,
      'logs': instance.logs,
    };
