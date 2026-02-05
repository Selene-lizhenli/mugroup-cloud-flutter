// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_station_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StationSampleImpl _$$StationSampleImplFromJson(Map<String, dynamic> json) =>
    _$StationSampleImpl(
      id: (json['id'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      active: json['active'] as bool?,
      stationId: (json['station_id'] as num?)?.toInt(),
      sampleId: (json['sample_id'] as num?)?.toInt(),
      quoteId: (json['quote_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      showroomSample: json['showroomSample'] == null
          ? null
          : Sample.fromJson(json['showroomSample'] as Map<String, dynamic>),
      supplyQuote: json['supplyQuote'] == null
          ? null
          : Quote.fromJson(json['supplyQuote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StationSampleImplToJson(_$StationSampleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qty': instance.qty,
      'price': instance.price,
      'active': instance.active,
      'station_id': instance.stationId,
      'sample_id': instance.sampleId,
      'quote_id': instance.quoteId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'showroomSample': instance.showroomSample,
      'supplyQuote': instance.supplyQuote,
    };
