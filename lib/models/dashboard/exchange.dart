import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange.freezed.dart';
part 'exchange.g.dart';

/// 汇率列表数据模型
@freezed
class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    String? name,
    @JsonKey(name: 'exchange_rate') String? exchangeRate,
    @JsonKey(name: 'reverse_exchange_rate') double? reverseExchangeRate,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'short_name') String? shortName,
  }) = _ExchangeRate;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);
}
