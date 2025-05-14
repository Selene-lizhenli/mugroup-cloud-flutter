// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CloudImpl _$$CloudImplFromJson(Map<String, dynamic> json) => _$CloudImpl(
      currentTenantId: (json['currentTenantId'] as num?)?.toInt(),
      tenants: (json['tenants'] as List<dynamic>)
          .map((e) => Tenant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CloudImplToJson(_$CloudImpl instance) =>
    <String, dynamic>{
      'currentTenantId': instance.currentTenantId,
      'tenants': instance.tenants,
    };
