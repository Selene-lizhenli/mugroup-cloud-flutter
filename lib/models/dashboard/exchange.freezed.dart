// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExchangeRate _$ExchangeRateFromJson(Map<String, dynamic> json) {
  return _ExchangeRate.fromJson(json);
}

/// @nodoc
mixin _$ExchangeRate {
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'exchange_rate')
  String? get exchangeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'reverse_exchange_rate')
  String? get reverseExchangeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_name')
  String? get shortName => throw _privateConstructorUsedError;
  @JsonKey(name: 'xh_buy_rate')
  String? get xhBuyRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'xz_buy_rate')
  String? get xzBuyRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'xh_sell_rate')
  String? get xhSellRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'xz_sell_rate')
  String? get xzSellRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'mid_rate')
  String? get midRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'pushed_at')
  String? get pushedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExchangeRateCopyWith<ExchangeRate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateCopyWith<$Res> {
  factory $ExchangeRateCopyWith(
          ExchangeRate value, $Res Function(ExchangeRate) then) =
      _$ExchangeRateCopyWithImpl<$Res, ExchangeRate>;
  @useResult
  $Res call(
      {String? name,
      @JsonKey(name: 'exchange_rate') String? exchangeRate,
      @JsonKey(name: 'reverse_exchange_rate') String? reverseExchangeRate,
      @JsonKey(name: 'date') String? date,
      @JsonKey(name: 'short_name') String? shortName,
      @JsonKey(name: 'xh_buy_rate') String? xhBuyRate,
      @JsonKey(name: 'xz_buy_rate') String? xzBuyRate,
      @JsonKey(name: 'xh_sell_rate') String? xhSellRate,
      @JsonKey(name: 'xz_sell_rate') String? xzSellRate,
      @JsonKey(name: 'mid_rate') String? midRate,
      @JsonKey(name: 'pushed_at') String? pushedAt});
}

/// @nodoc
class _$ExchangeRateCopyWithImpl<$Res, $Val extends ExchangeRate>
    implements $ExchangeRateCopyWith<$Res> {
  _$ExchangeRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? exchangeRate = freezed,
    Object? reverseExchangeRate = freezed,
    Object? date = freezed,
    Object? shortName = freezed,
    Object? xhBuyRate = freezed,
    Object? xzBuyRate = freezed,
    Object? xhSellRate = freezed,
    Object? xzSellRate = freezed,
    Object? midRate = freezed,
    Object? pushedAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as String?,
      reverseExchangeRate: freezed == reverseExchangeRate
          ? _value.reverseExchangeRate
          : reverseExchangeRate // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      xhBuyRate: freezed == xhBuyRate
          ? _value.xhBuyRate
          : xhBuyRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xzBuyRate: freezed == xzBuyRate
          ? _value.xzBuyRate
          : xzBuyRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xhSellRate: freezed == xhSellRate
          ? _value.xhSellRate
          : xhSellRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xzSellRate: freezed == xzSellRate
          ? _value.xzSellRate
          : xzSellRate // ignore: cast_nullable_to_non_nullable
              as String?,
      midRate: freezed == midRate
          ? _value.midRate
          : midRate // ignore: cast_nullable_to_non_nullable
              as String?,
      pushedAt: freezed == pushedAt
          ? _value.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeRateImplCopyWith<$Res>
    implements $ExchangeRateCopyWith<$Res> {
  factory _$$ExchangeRateImplCopyWith(
          _$ExchangeRateImpl value, $Res Function(_$ExchangeRateImpl) then) =
      __$$ExchangeRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      @JsonKey(name: 'exchange_rate') String? exchangeRate,
      @JsonKey(name: 'reverse_exchange_rate') String? reverseExchangeRate,
      @JsonKey(name: 'date') String? date,
      @JsonKey(name: 'short_name') String? shortName,
      @JsonKey(name: 'xh_buy_rate') String? xhBuyRate,
      @JsonKey(name: 'xz_buy_rate') String? xzBuyRate,
      @JsonKey(name: 'xh_sell_rate') String? xhSellRate,
      @JsonKey(name: 'xz_sell_rate') String? xzSellRate,
      @JsonKey(name: 'mid_rate') String? midRate,
      @JsonKey(name: 'pushed_at') String? pushedAt});
}

/// @nodoc
class __$$ExchangeRateImplCopyWithImpl<$Res>
    extends _$ExchangeRateCopyWithImpl<$Res, _$ExchangeRateImpl>
    implements _$$ExchangeRateImplCopyWith<$Res> {
  __$$ExchangeRateImplCopyWithImpl(
      _$ExchangeRateImpl _value, $Res Function(_$ExchangeRateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? exchangeRate = freezed,
    Object? reverseExchangeRate = freezed,
    Object? date = freezed,
    Object? shortName = freezed,
    Object? xhBuyRate = freezed,
    Object? xzBuyRate = freezed,
    Object? xhSellRate = freezed,
    Object? xzSellRate = freezed,
    Object? midRate = freezed,
    Object? pushedAt = freezed,
  }) {
    return _then(_$ExchangeRateImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as String?,
      reverseExchangeRate: freezed == reverseExchangeRate
          ? _value.reverseExchangeRate
          : reverseExchangeRate // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      xhBuyRate: freezed == xhBuyRate
          ? _value.xhBuyRate
          : xhBuyRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xzBuyRate: freezed == xzBuyRate
          ? _value.xzBuyRate
          : xzBuyRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xhSellRate: freezed == xhSellRate
          ? _value.xhSellRate
          : xhSellRate // ignore: cast_nullable_to_non_nullable
              as String?,
      xzSellRate: freezed == xzSellRate
          ? _value.xzSellRate
          : xzSellRate // ignore: cast_nullable_to_non_nullable
              as String?,
      midRate: freezed == midRate
          ? _value.midRate
          : midRate // ignore: cast_nullable_to_non_nullable
              as String?,
      pushedAt: freezed == pushedAt
          ? _value.pushedAt
          : pushedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeRateImpl implements _ExchangeRate {
  const _$ExchangeRateImpl(
      {this.name,
      @JsonKey(name: 'exchange_rate') this.exchangeRate,
      @JsonKey(name: 'reverse_exchange_rate') this.reverseExchangeRate,
      @JsonKey(name: 'date') this.date,
      @JsonKey(name: 'short_name') this.shortName,
      @JsonKey(name: 'xh_buy_rate') this.xhBuyRate,
      @JsonKey(name: 'xz_buy_rate') this.xzBuyRate,
      @JsonKey(name: 'xh_sell_rate') this.xhSellRate,
      @JsonKey(name: 'xz_sell_rate') this.xzSellRate,
      @JsonKey(name: 'mid_rate') this.midRate,
      @JsonKey(name: 'pushed_at') this.pushedAt});

  factory _$ExchangeRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateImplFromJson(json);

  @override
  final String? name;
  @override
  @JsonKey(name: 'exchange_rate')
  final String? exchangeRate;
  @override
  @JsonKey(name: 'reverse_exchange_rate')
  final String? reverseExchangeRate;
  @override
  @JsonKey(name: 'date')
  final String? date;
  @override
  @JsonKey(name: 'short_name')
  final String? shortName;
  @override
  @JsonKey(name: 'xh_buy_rate')
  final String? xhBuyRate;
  @override
  @JsonKey(name: 'xz_buy_rate')
  final String? xzBuyRate;
  @override
  @JsonKey(name: 'xh_sell_rate')
  final String? xhSellRate;
  @override
  @JsonKey(name: 'xz_sell_rate')
  final String? xzSellRate;
  @override
  @JsonKey(name: 'mid_rate')
  final String? midRate;
  @override
  @JsonKey(name: 'pushed_at')
  final String? pushedAt;

  @override
  String toString() {
    return 'ExchangeRate(name: $name, exchangeRate: $exchangeRate, reverseExchangeRate: $reverseExchangeRate, date: $date, shortName: $shortName, xhBuyRate: $xhBuyRate, xzBuyRate: $xzBuyRate, xhSellRate: $xhSellRate, xzSellRate: $xzSellRate, midRate: $midRate, pushedAt: $pushedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.reverseExchangeRate, reverseExchangeRate) ||
                other.reverseExchangeRate == reverseExchangeRate) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.xhBuyRate, xhBuyRate) ||
                other.xhBuyRate == xhBuyRate) &&
            (identical(other.xzBuyRate, xzBuyRate) ||
                other.xzBuyRate == xzBuyRate) &&
            (identical(other.xhSellRate, xhSellRate) ||
                other.xhSellRate == xhSellRate) &&
            (identical(other.xzSellRate, xzSellRate) ||
                other.xzSellRate == xzSellRate) &&
            (identical(other.midRate, midRate) || other.midRate == midRate) &&
            (identical(other.pushedAt, pushedAt) ||
                other.pushedAt == pushedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      exchangeRate,
      reverseExchangeRate,
      date,
      shortName,
      xhBuyRate,
      xzBuyRate,
      xhSellRate,
      xzSellRate,
      midRate,
      pushedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      __$$ExchangeRateImplCopyWithImpl<_$ExchangeRateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeRateImplToJson(
      this,
    );
  }
}

abstract class _ExchangeRate implements ExchangeRate {
  const factory _ExchangeRate(
      {final String? name,
      @JsonKey(name: 'exchange_rate') final String? exchangeRate,
      @JsonKey(name: 'reverse_exchange_rate') final String? reverseExchangeRate,
      @JsonKey(name: 'date') final String? date,
      @JsonKey(name: 'short_name') final String? shortName,
      @JsonKey(name: 'xh_buy_rate') final String? xhBuyRate,
      @JsonKey(name: 'xz_buy_rate') final String? xzBuyRate,
      @JsonKey(name: 'xh_sell_rate') final String? xhSellRate,
      @JsonKey(name: 'xz_sell_rate') final String? xzSellRate,
      @JsonKey(name: 'mid_rate') final String? midRate,
      @JsonKey(name: 'pushed_at') final String? pushedAt}) = _$ExchangeRateImpl;

  factory _ExchangeRate.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateImpl.fromJson;

  @override
  String? get name;
  @override
  @JsonKey(name: 'exchange_rate')
  String? get exchangeRate;
  @override
  @JsonKey(name: 'reverse_exchange_rate')
  String? get reverseExchangeRate;
  @override
  @JsonKey(name: 'date')
  String? get date;
  @override
  @JsonKey(name: 'short_name')
  String? get shortName;
  @override
  @JsonKey(name: 'xh_buy_rate')
  String? get xhBuyRate;
  @override
  @JsonKey(name: 'xz_buy_rate')
  String? get xzBuyRate;
  @override
  @JsonKey(name: 'xh_sell_rate')
  String? get xhSellRate;
  @override
  @JsonKey(name: 'xz_sell_rate')
  String? get xzSellRate;
  @override
  @JsonKey(name: 'mid_rate')
  String? get midRate;
  @override
  @JsonKey(name: 'pushed_at')
  String? get pushedAt;
  @override
  @JsonKey(ignore: true)
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExchangeRateDataItem _$ExchangeRateDataItemFromJson(Map<String, dynamic> json) {
  return _ExchangeRateDataItem.fromJson(json);
}

/// @nodoc
mixin _$ExchangeRateDataItem {
  String? get date => throw _privateConstructorUsedError;
  String? get rate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExchangeRateDataItemCopyWith<ExchangeRateDataItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateDataItemCopyWith<$Res> {
  factory $ExchangeRateDataItemCopyWith(ExchangeRateDataItem value,
          $Res Function(ExchangeRateDataItem) then) =
      _$ExchangeRateDataItemCopyWithImpl<$Res, ExchangeRateDataItem>;
  @useResult
  $Res call({String? date, String? rate});
}

/// @nodoc
class _$ExchangeRateDataItemCopyWithImpl<$Res,
        $Val extends ExchangeRateDataItem>
    implements $ExchangeRateDataItemCopyWith<$Res> {
  _$ExchangeRateDataItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? rate = freezed,
  }) {
    return _then(_value.copyWith(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeRateDataItemImplCopyWith<$Res>
    implements $ExchangeRateDataItemCopyWith<$Res> {
  factory _$$ExchangeRateDataItemImplCopyWith(_$ExchangeRateDataItemImpl value,
          $Res Function(_$ExchangeRateDataItemImpl) then) =
      __$$ExchangeRateDataItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? date, String? rate});
}

/// @nodoc
class __$$ExchangeRateDataItemImplCopyWithImpl<$Res>
    extends _$ExchangeRateDataItemCopyWithImpl<$Res, _$ExchangeRateDataItemImpl>
    implements _$$ExchangeRateDataItemImplCopyWith<$Res> {
  __$$ExchangeRateDataItemImplCopyWithImpl(_$ExchangeRateDataItemImpl _value,
      $Res Function(_$ExchangeRateDataItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? rate = freezed,
  }) {
    return _then(_$ExchangeRateDataItemImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeRateDataItemImpl implements _ExchangeRateDataItem {
  const _$ExchangeRateDataItemImpl({required this.date, required this.rate});

  factory _$ExchangeRateDataItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateDataItemImplFromJson(json);

  @override
  final String? date;
  @override
  final String? rate;

  @override
  String toString() {
    return 'ExchangeRateDataItem(date: $date, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateDataItemImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.rate, rate) || other.rate == rate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, rate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateDataItemImplCopyWith<_$ExchangeRateDataItemImpl>
      get copyWith =>
          __$$ExchangeRateDataItemImplCopyWithImpl<_$ExchangeRateDataItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeRateDataItemImplToJson(
      this,
    );
  }
}

abstract class _ExchangeRateDataItem implements ExchangeRateDataItem {
  const factory _ExchangeRateDataItem(
      {required final String? date,
      required final String? rate}) = _$ExchangeRateDataItemImpl;

  factory _ExchangeRateDataItem.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateDataItemImpl.fromJson;

  @override
  String? get date;
  @override
  String? get rate;
  @override
  @JsonKey(ignore: true)
  _$$ExchangeRateDataItemImplCopyWith<_$ExchangeRateDataItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExchangeRateHistory _$ExchangeRateHistoryFromJson(Map<String, dynamic> json) {
  return _ExchangeRateHistory.fromJson(json);
}

/// @nodoc
mixin _$ExchangeRateHistory {
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  List<ExchangeRateDataItem>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExchangeRateHistoryCopyWith<ExchangeRateHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateHistoryCopyWith<$Res> {
  factory $ExchangeRateHistoryCopyWith(
          ExchangeRateHistory value, $Res Function(ExchangeRateHistory) then) =
      _$ExchangeRateHistoryCopyWithImpl<$Res, ExchangeRateHistory>;
  @useResult
  $Res call(
      {String? currency,
      @JsonKey(name: 'data') List<ExchangeRateDataItem>? data});
}

/// @nodoc
class _$ExchangeRateHistoryCopyWithImpl<$Res, $Val extends ExchangeRateHistory>
    implements $ExchangeRateHistoryCopyWith<$Res> {
  _$ExchangeRateHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ExchangeRateDataItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeRateHistoryImplCopyWith<$Res>
    implements $ExchangeRateHistoryCopyWith<$Res> {
  factory _$$ExchangeRateHistoryImplCopyWith(_$ExchangeRateHistoryImpl value,
          $Res Function(_$ExchangeRateHistoryImpl) then) =
      __$$ExchangeRateHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currency,
      @JsonKey(name: 'data') List<ExchangeRateDataItem>? data});
}

/// @nodoc
class __$$ExchangeRateHistoryImplCopyWithImpl<$Res>
    extends _$ExchangeRateHistoryCopyWithImpl<$Res, _$ExchangeRateHistoryImpl>
    implements _$$ExchangeRateHistoryImplCopyWith<$Res> {
  __$$ExchangeRateHistoryImplCopyWithImpl(_$ExchangeRateHistoryImpl _value,
      $Res Function(_$ExchangeRateHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ExchangeRateHistoryImpl(
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ExchangeRateDataItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeRateHistoryImpl implements _ExchangeRateHistory {
  const _$ExchangeRateHistoryImpl(
      {required this.currency,
      @JsonKey(name: 'data') final List<ExchangeRateDataItem>? data})
      : _data = data;

  factory _$ExchangeRateHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateHistoryImplFromJson(json);

  @override
  final String? currency;
  final List<ExchangeRateDataItem>? _data;
  @override
  @JsonKey(name: 'data')
  List<ExchangeRateDataItem>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ExchangeRateHistory(currency: $currency, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateHistoryImpl &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, currency, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateHistoryImplCopyWith<_$ExchangeRateHistoryImpl> get copyWith =>
      __$$ExchangeRateHistoryImplCopyWithImpl<_$ExchangeRateHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeRateHistoryImplToJson(
      this,
    );
  }
}

abstract class _ExchangeRateHistory implements ExchangeRateHistory {
  const factory _ExchangeRateHistory(
          {required final String? currency,
          @JsonKey(name: 'data') final List<ExchangeRateDataItem>? data}) =
      _$ExchangeRateHistoryImpl;

  factory _ExchangeRateHistory.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateHistoryImpl.fromJson;

  @override
  String? get currency;
  @override
  @JsonKey(name: 'data')
  List<ExchangeRateDataItem>? get data;
  @override
  @JsonKey(ignore: true)
  _$$ExchangeRateHistoryImplCopyWith<_$ExchangeRateHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
