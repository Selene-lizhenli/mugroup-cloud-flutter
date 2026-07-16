// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quotation_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuotationSample _$QuotationSampleFromJson(Map<String, dynamic> json) {
  return _QuotationSample.fromJson(json);
}

/// @nodoc
mixin _$QuotationSample {
  int? get id => throw _privateConstructorUsedError;
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_product_no')
  String? get customerProductNo => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'showroomSample')
  Sample? get showroomSample => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  Quote? get supplyQuote => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotationSampleCopyWith<QuotationSample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotationSampleCopyWith<$Res> {
  factory $QuotationSampleCopyWith(
          QuotationSample value, $Res Function(QuotationSample) then) =
      _$QuotationSampleCopyWithImpl<$Res, QuotationSample>;
  @useResult
  $Res call(
      {int? id,
      String? price,
      @JsonKey(name: 'customer_product_no') String? customerProductNo,
      int? qty,
      @JsonKey(name: 'showroomSample') Sample? showroomSample,
      @JsonKey(name: 'created_at') String? createdAt,
      Quote? supplyQuote});

  $SampleCopyWith<$Res>? get showroomSample;
  $QuoteCopyWith<$Res>? get supplyQuote;
}

/// @nodoc
class _$QuotationSampleCopyWithImpl<$Res, $Val extends QuotationSample>
    implements $QuotationSampleCopyWith<$Res> {
  _$QuotationSampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? price = freezed,
    Object? customerProductNo = freezed,
    Object? qty = freezed,
    Object? showroomSample = freezed,
    Object? createdAt = freezed,
    Object? supplyQuote = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      customerProductNo: freezed == customerProductNo
          ? _value.customerProductNo
          : customerProductNo // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      showroomSample: freezed == showroomSample
          ? _value.showroomSample
          : showroomSample // ignore: cast_nullable_to_non_nullable
              as Sample?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      supplyQuote: freezed == supplyQuote
          ? _value.supplyQuote
          : supplyQuote // ignore: cast_nullable_to_non_nullable
              as Quote?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCopyWith<$Res>? get showroomSample {
    if (_value.showroomSample == null) {
      return null;
    }

    return $SampleCopyWith<$Res>(_value.showroomSample!, (value) {
      return _then(_value.copyWith(showroomSample: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QuoteCopyWith<$Res>? get supplyQuote {
    if (_value.supplyQuote == null) {
      return null;
    }

    return $QuoteCopyWith<$Res>(_value.supplyQuote!, (value) {
      return _then(_value.copyWith(supplyQuote: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotationSampleImplCopyWith<$Res>
    implements $QuotationSampleCopyWith<$Res> {
  factory _$$QuotationSampleImplCopyWith(_$QuotationSampleImpl value,
          $Res Function(_$QuotationSampleImpl) then) =
      __$$QuotationSampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? price,
      @JsonKey(name: 'customer_product_no') String? customerProductNo,
      int? qty,
      @JsonKey(name: 'showroomSample') Sample? showroomSample,
      @JsonKey(name: 'created_at') String? createdAt,
      Quote? supplyQuote});

  @override
  $SampleCopyWith<$Res>? get showroomSample;
  @override
  $QuoteCopyWith<$Res>? get supplyQuote;
}

/// @nodoc
class __$$QuotationSampleImplCopyWithImpl<$Res>
    extends _$QuotationSampleCopyWithImpl<$Res, _$QuotationSampleImpl>
    implements _$$QuotationSampleImplCopyWith<$Res> {
  __$$QuotationSampleImplCopyWithImpl(
      _$QuotationSampleImpl _value, $Res Function(_$QuotationSampleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? price = freezed,
    Object? customerProductNo = freezed,
    Object? qty = freezed,
    Object? showroomSample = freezed,
    Object? createdAt = freezed,
    Object? supplyQuote = freezed,
  }) {
    return _then(_$QuotationSampleImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      customerProductNo: freezed == customerProductNo
          ? _value.customerProductNo
          : customerProductNo // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      showroomSample: freezed == showroomSample
          ? _value.showroomSample
          : showroomSample // ignore: cast_nullable_to_non_nullable
              as Sample?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      supplyQuote: freezed == supplyQuote
          ? _value.supplyQuote
          : supplyQuote // ignore: cast_nullable_to_non_nullable
              as Quote?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotationSampleImpl implements _QuotationSample {
  _$QuotationSampleImpl(
      {this.id,
      this.price,
      @JsonKey(name: 'customer_product_no') this.customerProductNo,
      this.qty,
      @JsonKey(name: 'showroomSample') this.showroomSample,
      @JsonKey(name: 'created_at') this.createdAt,
      this.supplyQuote});

  factory _$QuotationSampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotationSampleImplFromJson(json);

  @override
  final int? id;
  @override
  final String? price;
  @override
  @JsonKey(name: 'customer_product_no')
  final String? customerProductNo;
  @override
  final int? qty;
  @override
  @JsonKey(name: 'showroomSample')
  final Sample? showroomSample;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  final Quote? supplyQuote;

  @override
  String toString() {
    return 'QuotationSample(id: $id, price: $price, customerProductNo: $customerProductNo, qty: $qty, showroomSample: $showroomSample, createdAt: $createdAt, supplyQuote: $supplyQuote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotationSampleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.customerProductNo, customerProductNo) ||
                other.customerProductNo == customerProductNo) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.showroomSample, showroomSample) ||
                other.showroomSample == showroomSample) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.supplyQuote, supplyQuote) ||
                other.supplyQuote == supplyQuote));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, customerProductNo,
      qty, showroomSample, createdAt, supplyQuote);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotationSampleImplCopyWith<_$QuotationSampleImpl> get copyWith =>
      __$$QuotationSampleImplCopyWithImpl<_$QuotationSampleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotationSampleImplToJson(
      this,
    );
  }
}

abstract class _QuotationSample implements QuotationSample {
  factory _QuotationSample(
      {final int? id,
      final String? price,
      @JsonKey(name: 'customer_product_no') final String? customerProductNo,
      final int? qty,
      @JsonKey(name: 'showroomSample') final Sample? showroomSample,
      @JsonKey(name: 'created_at') final String? createdAt,
      final Quote? supplyQuote}) = _$QuotationSampleImpl;

  factory _QuotationSample.fromJson(Map<String, dynamic> json) =
      _$QuotationSampleImpl.fromJson;

  @override
  int? get id;
  @override
  String? get price;
  @override
  @JsonKey(name: 'customer_product_no')
  String? get customerProductNo;
  @override
  int? get qty;
  @override
  @JsonKey(name: 'showroomSample')
  Sample? get showroomSample;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  Quote? get supplyQuote;
  @override
  @JsonKey(ignore: true)
  _$$QuotationSampleImplCopyWith<_$QuotationSampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
