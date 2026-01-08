// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyStatsImpl _$$MonthlyStatsImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyStatsImpl(
      crmCompany: (json['crm_company'] as num?)?.toInt(),
      marketProduct: (json['market_product'] as num?)?.toInt(),
      supplySupplier: (json['supply_supplier'] as num?)?.toInt(),
      inspectionTask: (json['inspection_task'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MonthlyStatsImplToJson(_$MonthlyStatsImpl instance) =>
    <String, dynamic>{
      'crm_company': instance.crmCompany,
      'market_product': instance.marketProduct,
      'supply_supplier': instance.supplySupplier,
      'inspection_task': instance.inspectionTask,
    };
