// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantWxworkImpl _$$TenantWxworkImplFromJson(Map<String, dynamic> json) =>
    _$TenantWxworkImpl(
      agentId: json['agent_id'] as String?,
      corpId: json['corp_id'] as String?,
      schema: json['schema'] as String?,
    );

Map<String, dynamic> _$$TenantWxworkImplToJson(_$TenantWxworkImpl instance) =>
    <String, dynamic>{
      'agent_id': instance.agentId,
      'corp_id': instance.corpId,
      'schema': instance.schema,
    };

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      loginWays: (json['login_ways'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      baseUrl: json['base_url'] as String?,
      wxwork: json['wxwork'] == null
          ? null
          : TenantWxwork.fromJson(json['wxwork'] as Map<String, dynamic>),
      appFeatures: (json['app_features'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'login_ways': instance.loginWays,
      'base_url': instance.baseUrl,
      'wxwork': instance.wxwork,
      'app_features': instance.appFeatures,
    };
