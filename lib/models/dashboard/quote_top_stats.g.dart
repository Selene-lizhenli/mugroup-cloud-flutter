// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_top_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteTopStatsImpl _$$QuoteTopStatsImplFromJson(Map<String, dynamic> json) =>
    _$QuoteTopStatsImpl(
      sampleNo: json['sample_no'] as String?,
      sampleId: (json['sample_id'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      sampleName: json['sample_name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      thumbUrl: json['thumb_url'] as String?,
    );

Map<String, dynamic> _$$QuoteTopStatsImplToJson(_$QuoteTopStatsImpl instance) =>
    <String, dynamic>{
      'sample_no': instance.sampleNo,
      'sample_id': instance.sampleId,
      'count': instance.count,
      'sample_name': instance.sampleName,
      'id': instance.id,
      'thumb_url': instance.thumbUrl,
    };
