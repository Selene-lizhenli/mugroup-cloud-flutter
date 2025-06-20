// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      loginWays: (json['login_ways'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      baseUrl: json['base_url'] as String?,
    );

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'login_ways': instance.loginWays,
      'base_url': instance.baseUrl,
    };
