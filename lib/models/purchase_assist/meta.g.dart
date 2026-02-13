// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseAssistMetaImpl _$$PurchaseAssistMetaImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseAssistMetaImpl(
      platform: json['platform'] as String?,
      pagination: json['pagination'] == null
          ? null
          : PurchaseAssistPagination.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PurchaseAssistMetaImplToJson(
        _$PurchaseAssistMetaImpl instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'pagination': instance.pagination,
    };

_$PurchaseAssistPaginationImpl _$$PurchaseAssistPaginationImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseAssistPaginationImpl(
      total: (json['total'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      currentPage: (json['current_page'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      links: json['links'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PurchaseAssistPaginationImplToJson(
        _$PurchaseAssistPaginationImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'count': instance.count,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'links': instance.links,
    };
