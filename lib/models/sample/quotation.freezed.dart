// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quotation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Quotation _$QuotationFromJson(Map<String, dynamic> json) {
  return _Quotation.fromJson(json);
}

/// @nodoc
mixin _$Quotation {
  int? get id => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  double? get exchange => throw _privateConstructorUsedError;
  @JsonKey(name: 'commission_rate')
  double? get commissionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'inquiry_at')
  DateTime? get inquiryAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_at')
  DateTime? get quoteAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotationCopyWith<Quotation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotationCopyWith<$Res> {
  factory $QuotationCopyWith(Quotation value, $Res Function(Quotation) then) =
      _$QuotationCopyWithImpl<$Res, Quotation>;
  @useResult
  $Res call(
      {int? id,
      User? user,
      double? exchange,
      @JsonKey(name: 'commission_rate') double? commissionRate,
      @JsonKey(name: 'inquiry_at') DateTime? inquiryAt,
      @JsonKey(name: 'quote_at') DateTime? quoteAt});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$QuotationCopyWithImpl<$Res, $Val extends Quotation>
    implements $QuotationCopyWith<$Res> {
  _$QuotationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? exchange = freezed,
    Object? commissionRate = freezed,
    Object? inquiryAt = freezed,
    Object? quoteAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as double?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double?,
      inquiryAt: freezed == inquiryAt
          ? _value.inquiryAt
          : inquiryAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quoteAt: freezed == quoteAt
          ? _value.quoteAt
          : quoteAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotationImplCopyWith<$Res>
    implements $QuotationCopyWith<$Res> {
  factory _$$QuotationImplCopyWith(
          _$QuotationImpl value, $Res Function(_$QuotationImpl) then) =
      __$$QuotationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      User? user,
      double? exchange,
      @JsonKey(name: 'commission_rate') double? commissionRate,
      @JsonKey(name: 'inquiry_at') DateTime? inquiryAt,
      @JsonKey(name: 'quote_at') DateTime? quoteAt});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$QuotationImplCopyWithImpl<$Res>
    extends _$QuotationCopyWithImpl<$Res, _$QuotationImpl>
    implements _$$QuotationImplCopyWith<$Res> {
  __$$QuotationImplCopyWithImpl(
      _$QuotationImpl _value, $Res Function(_$QuotationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? exchange = freezed,
    Object? commissionRate = freezed,
    Object? inquiryAt = freezed,
    Object? quoteAt = freezed,
  }) {
    return _then(_$QuotationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as double?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double?,
      inquiryAt: freezed == inquiryAt
          ? _value.inquiryAt
          : inquiryAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quoteAt: freezed == quoteAt
          ? _value.quoteAt
          : quoteAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotationImpl implements _Quotation {
  _$QuotationImpl(
      {this.id,
      this.user,
      this.exchange,
      @JsonKey(name: 'commission_rate') this.commissionRate,
      @JsonKey(name: 'inquiry_at') this.inquiryAt,
      @JsonKey(name: 'quote_at') this.quoteAt});

  factory _$QuotationImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotationImplFromJson(json);

  @override
  final int? id;
  @override
  final User? user;
  @override
  final double? exchange;
  @override
  @JsonKey(name: 'commission_rate')
  final double? commissionRate;
  @override
  @JsonKey(name: 'inquiry_at')
  final DateTime? inquiryAt;
  @override
  @JsonKey(name: 'quote_at')
  final DateTime? quoteAt;

  @override
  String toString() {
    return 'Quotation(id: $id, user: $user, exchange: $exchange, commissionRate: $commissionRate, inquiryAt: $inquiryAt, quoteAt: $quoteAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.inquiryAt, inquiryAt) ||
                other.inquiryAt == inquiryAt) &&
            (identical(other.quoteAt, quoteAt) || other.quoteAt == quoteAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, user, exchange, commissionRate, inquiryAt, quoteAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotationImplCopyWith<_$QuotationImpl> get copyWith =>
      __$$QuotationImplCopyWithImpl<_$QuotationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotationImplToJson(
      this,
    );
  }
}

abstract class _Quotation implements Quotation {
  factory _Quotation(
      {final int? id,
      final User? user,
      final double? exchange,
      @JsonKey(name: 'commission_rate') final double? commissionRate,
      @JsonKey(name: 'inquiry_at') final DateTime? inquiryAt,
      @JsonKey(name: 'quote_at') final DateTime? quoteAt}) = _$QuotationImpl;

  factory _Quotation.fromJson(Map<String, dynamic> json) =
      _$QuotationImpl.fromJson;

  @override
  int? get id;
  @override
  User? get user;
  @override
  double? get exchange;
  @override
  @JsonKey(name: 'commission_rate')
  double? get commissionRate;
  @override
  @JsonKey(name: 'inquiry_at')
  DateTime? get inquiryAt;
  @override
  @JsonKey(name: 'quote_at')
  DateTime? get quoteAt;
  @override
  @JsonKey(ignore: true)
  _$$QuotationImplCopyWith<_$QuotationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
