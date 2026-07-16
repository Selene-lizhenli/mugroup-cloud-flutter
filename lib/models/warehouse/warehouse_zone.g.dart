// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseZoneImpl _$$WarehouseZoneImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseZoneImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      locationsCount: (json['locations_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WarehouseZoneImplToJson(_$WarehouseZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'locations_count': instance.locationsCount,
    };
