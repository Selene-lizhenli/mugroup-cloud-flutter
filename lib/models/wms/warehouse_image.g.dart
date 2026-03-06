// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseImageImpl _$$WarehouseImageImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseImageImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      whiteUrl: json['white_url'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      type: json['type'] as String?,
      filename: json['filename'] as String?,
      address: json['address'] as String?,
      shotAt: json['shot_at'] as String?,
      collectionName: json['collection_name'] as String?,
    );

Map<String, dynamic> _$$WarehouseImageImplToJson(
        _$WarehouseImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'categoryId': instance.categoryId,
      'white_url': instance.whiteUrl,
      'thumb_url': instance.thumbUrl,
      'type': instance.type,
      'filename': instance.filename,
      'address': instance.address,
      'shot_at': instance.shotAt,
      'collection_name': instance.collectionName,
    };
