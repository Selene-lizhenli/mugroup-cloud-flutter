// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseLocationImpl _$$WarehouseLocationImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseLocationImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      zoneId: (json['zone_id'] as num?)?.toInt(),
      zone: json['zone'] == null
          ? null
          : WarehouseZone.fromJson(json['zone'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WarehouseLocationImplToJson(
        _$WarehouseLocationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'zone_id': instance.zoneId,
      'zone': instance.zone,
    };
