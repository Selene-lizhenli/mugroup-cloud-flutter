// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship_top_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipTopStatsImpl _$$ShipTopStatsImplFromJson(Map<String, dynamic> json) =>
    _$ShipTopStatsImpl(
      id: (json['id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      sampleNo: json['sample_no'] as String?,
      sampleName: json['sample_name'] as String?,
      shippingAmount: (json['shipping_amount'] as num?)?.toInt(),
      shippingCount: (json['shipping_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ShipTopStatsImplToJson(_$ShipTopStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
      'thumb_url': instance.thumbUrl,
      'sample_no': instance.sampleNo,
      'sample_name': instance.sampleName,
      'shipping_amount': instance.shippingAmount,
      'shipping_count': instance.shippingCount,
    };
