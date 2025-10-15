// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotationImpl _$$QuotationImplFromJson(Map<String, dynamic> json) =>
    _$QuotationImpl(
      id: (json['id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      exchange: (json['exchange'] as num?)?.toDouble(),
      showPrice: json['showPrice'] as bool?,
      quotationSamples: (json['quotationSamples'] as List<dynamic>?)
          ?.map((e) => QuotationSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      commissionRate: (json['commission_rate'] as num?)?.toDouble(),
      inquiryAt: json['inquiry_at'] == null
          ? null
          : DateTime.parse(json['inquiry_at'] as String),
      quoteAt: json['quote_at'] == null
          ? null
          : DateTime.parse(json['quote_at'] as String),
    );

Map<String, dynamic> _$$QuotationImplToJson(_$QuotationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'exchange': instance.exchange,
      'showPrice': instance.showPrice,
      'quotationSamples': instance.quotationSamples,
      'commission_rate': instance.commissionRate,
      'inquiry_at': instance.inquiryAt?.toIso8601String(),
      'quote_at': instance.quoteAt?.toIso8601String(),
    };
