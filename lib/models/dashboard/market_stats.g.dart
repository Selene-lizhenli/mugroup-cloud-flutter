// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketPurchaseStatsImpl _$$MarketPurchaseStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketPurchaseStatsImpl(
      timeLabels: (json['time_labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      productData: (json['product_data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      customerData: (json['customer_data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      serviceProviderData: (json['service_provider_data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      inspectionData: (json['inspection_data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$MarketPurchaseStatsImplToJson(
        _$MarketPurchaseStatsImpl instance) =>
    <String, dynamic>{
      'time_labels': instance.timeLabels,
      'product_data': instance.productData,
      'customer_data': instance.customerData,
      'service_provider_data': instance.serviceProviderData,
      'inspection_data': instance.inspectionData,
    };
