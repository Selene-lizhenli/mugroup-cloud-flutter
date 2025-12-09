// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseDataImpl<T> _$$ApiResponseDataImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiResponseDataImpl<T>(
      fromJsonT(json['data']),
      json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApiResponseDataImplToJson<T>(
  _$ApiResponseDataImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'meta': instance.meta,
    };

_$MetaImpl _$$MetaImplFromJson(Map<String, dynamic> json) => _$MetaImpl(
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      facetCounts: (json['facet_counts'] as List<dynamic>?)
          ?.map((e) => FacetCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MetaImplToJson(_$MetaImpl instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'facet_counts': instance.facetCounts,
    };

_$PaginationImpl _$$PaginationImplFromJson(Map<String, dynamic> json) =>
    _$PaginationImpl(
      total: (json['total'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationImplToJson(_$PaginationImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'count': instance.count,
      'total_pages': instance.totalPages,
    };

_$FacetCountImpl _$$FacetCountImplFromJson(Map<String, dynamic> json) =>
    _$FacetCountImpl(
      counts: (json['counts'] as List<dynamic>)
          .map((e) => FacetCountCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      fieldName: json['field_name'] as String,
    );

Map<String, dynamic> _$$FacetCountImplToJson(_$FacetCountImpl instance) =>
    <String, dynamic>{
      'counts': instance.counts,
      'field_name': instance.fieldName,
    };

_$FacetCountCountImpl _$$FacetCountCountImplFromJson(
        Map<String, dynamic> json) =>
    _$FacetCountCountImpl(
      count: (json['count'] as num).toInt(),
      value: json['value'] as String,
    );

Map<String, dynamic> _$$FacetCountCountImplToJson(
        _$FacetCountCountImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'value': instance.value,
    };
