// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExchangeRateImpl _$$ExchangeRateImplFromJson(Map<String, dynamic> json) =>
    _$ExchangeRateImpl(
      name: json['name'] as String?,
      exchangeRate: json['exchange_rate'] as String?,
      reverseExchangeRate: json['reverse_exchange_rate'] as String?,
      date: json['date'] as String?,
      shortName: json['short_name'] as String?,
      xhBuyRate: json['xh_buy_rate'] as String?,
      xzBuyRate: json['xz_buy_rate'] as String?,
      xhSellRate: json['xh_sell_rate'] as String?,
      xzSellRate: json['xz_sell_rate'] as String?,
      midRate: json['mid_rate'] as String?,
      pushedAt: json['pushed_at'] as String?,
    );

Map<String, dynamic> _$$ExchangeRateImplToJson(_$ExchangeRateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exchange_rate': instance.exchangeRate,
      'reverse_exchange_rate': instance.reverseExchangeRate,
      'date': instance.date,
      'short_name': instance.shortName,
      'xh_buy_rate': instance.xhBuyRate,
      'xz_buy_rate': instance.xzBuyRate,
      'xh_sell_rate': instance.xhSellRate,
      'xz_sell_rate': instance.xzSellRate,
      'mid_rate': instance.midRate,
      'pushed_at': instance.pushedAt,
    };

_$ExchangeRateDataItemImpl _$$ExchangeRateDataItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ExchangeRateDataItemImpl(
      date: json['date'] as String?,
      rate: json['rate'] as String?,
    );

Map<String, dynamic> _$$ExchangeRateDataItemImplToJson(
        _$ExchangeRateDataItemImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'rate': instance.rate,
    };

_$ExchangeRateHistoryImpl _$$ExchangeRateHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExchangeRateHistoryImpl(
      currency: json['currency'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExchangeRateDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ExchangeRateHistoryImplToJson(
        _$ExchangeRateHistoryImpl instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'data': instance.data,
    };
