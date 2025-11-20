// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['address'] as String?,
      json['industry'] as String?,
      json['location'] as String?,
      json['source'] as String?,
      (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['email'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['facebook'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['linkedin'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['whatsapp'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'industry': instance.industry,
      'location': instance.location,
      'source': instance.source,
      'domain': instance.domain,
      'email': instance.email,
      'facebook': instance.facebook,
      'linkedin': instance.linkedin,
      'whatsapp': instance.whatsapp,
    };
