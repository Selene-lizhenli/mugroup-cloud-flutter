// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseImpl _$$WarehouseImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      address: json['address'] as String?,
      type: json['type'] as String?,
      permission: json['permission'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      tenantId: (json['tenant_id'] as num?)?.toInt(),
      orderColumn: _stringFromAny(json['order_column']),
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => WarehouseImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      abandoned: json['abandoned'] as bool?,
    );

Map<String, dynamic> _$$WarehouseImplToJson(_$WarehouseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'type': instance.type,
      'permission': instance.permission,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'tenant_id': instance.tenantId,
      'order_column': instance.orderColumn,
      'image': instance.image,
      'abandoned': instance.abandoned,
    };
