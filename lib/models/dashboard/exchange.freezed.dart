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
  double? get reverseExchangeRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_name')
  String? get shortName => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'reverse_exchange_rate') double? reverseExchangeRate,
      @JsonKey(name: 'date') String? date,
      @JsonKey(name: 'short_name') String? shortName});
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
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'reverse_exchange_rate') double? reverseExchangeRate,
      @JsonKey(name: 'date') String? date,
      @JsonKey(name: 'short_name') String? shortName});
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
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'short_name') this.shortName});

  factory _$ExchangeRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateImplFromJson(json);

  @override
  final String? name;
  @override
  @JsonKey(name: 'exchange_rate')
  final String? exchangeRate;
  @override
  @JsonKey(name: 'reverse_exchange_rate')
  final double? reverseExchangeRate;
  @override
  @JsonKey(name: 'date')
  final String? date;
  @override
  @JsonKey(name: 'short_name')
  final String? shortName;

  @override
  String toString() {
    return 'ExchangeRate(name: $name, exchangeRate: $exchangeRate, reverseExchangeRate: $reverseExchangeRate, date: $date, shortName: $shortName)';
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
                other.shortName == shortName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, exchangeRate, reverseExchangeRate, date, shortName);

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
      @JsonKey(name: 'reverse_exchange_rate') final double? reverseExchangeRate,
      @JsonKey(name: 'date') final String? date,
      @JsonKey(name: 'short_name')
      final String? shortName}) = _$ExchangeRateImpl;

  factory _ExchangeRate.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateImpl.fromJson;

  @override
  String? get name;
  @override
  @JsonKey(name: 'exchange_rate')
  String? get exchangeRate;
  @override
  @JsonKey(name: 'reverse_exchange_rate')
  double? get reverseExchangeRate;
  @override
  @JsonKey(name: 'date')
  String? get date;
  @override
  @JsonKey(name: 'short_name')
  String? get shortName;
  @override
  @JsonKey(ignore: true)
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
