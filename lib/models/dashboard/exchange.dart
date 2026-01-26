import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange.freezed.dart';
part 'exchange.g.dart';

/// 汇率列表数据模型
@freezed
class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    String? name,
    @JsonKey(name: 'exchange_rate') String? exchangeRate,
    @JsonKey(name: 'reverse_exchange_rate') String? reverseExchangeRate,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'short_name') String? shortName,
  }) = _ExchangeRate;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);
}

/// 汇率波动数据项
@freezed
class ExchangeRateDataItem with _$ExchangeRateDataItem {
  const factory ExchangeRateDataItem({
    required String? date,
    required String? rate,
  }) = _ExchangeRateDataItem;

  factory ExchangeRateDataItem.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateDataItemFromJson(json);
}

/// 汇率历史数据响应
@freezed
class ExchangeRateHistory with _$ExchangeRateHistory {
  const factory ExchangeRateHistory({
    required String? currency,
    @JsonKey(name: 'data') List<ExchangeRateDataItem>? data,
  }) = _ExchangeRateHistory;

  factory ExchangeRateHistory.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateHistoryFromJson(json);
}
