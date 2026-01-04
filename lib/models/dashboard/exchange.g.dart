// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExchangeRateImpl _$$ExchangeRateImplFromJson(Map<String, dynamic> json) =>
    _$ExchangeRateImpl(
      name: json['name'] as String?,
      exchangeRate: json['exchange_rate'] as String?,
      reverseExchangeRate: (json['reverse_exchange_rate'] as num?)?.toDouble(),
      date: json['date'] as String?,
      shortName: json['short_name'] as String?,
    );

Map<String, dynamic> _$$ExchangeRateImplToJson(_$ExchangeRateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exchange_rate': instance.exchangeRate,
      'reverse_exchange_rate': instance.reverseExchangeRate,
      'date': instance.date,
      'short_name': instance.shortName,
    };
