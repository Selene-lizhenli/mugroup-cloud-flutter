// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) => _$QuoteImpl(
      (json['id'] as num?)?.toInt(),
      json['supplier'] == null
          ? null
          : Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      json['packing'] as String?,
      json['outer_capacity'] as String?,
      json['outer_volume'] as String?,
      json['chuhuo_at'] == null
          ? null
          : DateTime.parse(json['chuhuo_at'] as String),
      json['sample_location'] as String?,
      json['record_user'] as String?,
    );

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier': instance.supplier,
      'packing': instance.packing,
      'outer_capacity': instance.outerCapacity,
      'outer_volume': instance.outerVolume,
      'chuhuo_at': instance.chuhuoAt?.toIso8601String(),
      'sample_location': instance.sampleLocation,
      'record_user': instance.recordUser,
    };
