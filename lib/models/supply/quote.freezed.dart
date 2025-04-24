// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Quote _$QuoteFromJson(Map<String, dynamic> json) {
  return _Quote.fromJson(json);
}

/// @nodoc
mixin _$Quote {
  int? get id => throw _privateConstructorUsedError;
  Supplier? get supplier => throw _privateConstructorUsedError;
  String? get packing => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_capacity')
  double? get outerCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_volume')
  double? get outerVolume => throw _privateConstructorUsedError;
  @JsonKey(name: 'chuhuo_at')
  DateTime? get chuhuoAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_location')
  String? get sampleLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuoteCopyWith<Quote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteCopyWith<$Res> {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) then) =
      _$QuoteCopyWithImpl<$Res, Quote>;
  @useResult
  $Res call(
      {int? id,
      Supplier? supplier,
      String? packing,
      @JsonKey(name: 'outer_capacity') double? outerCapacity,
      @JsonKey(name: 'outer_volume') double? outerVolume,
      @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
      @JsonKey(name: 'sample_location') String? sampleLocation});

  $SupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class _$QuoteCopyWithImpl<$Res, $Val extends Quote>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? supplier = freezed,
    Object? packing = freezed,
    Object? outerCapacity = freezed,
    Object? outerVolume = freezed,
    Object? chuhuoAt = freezed,
    Object? sampleLocation = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      packing: freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      outerCapacity: freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      outerVolume: freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as double?,
      chuhuoAt: freezed == chuhuoAt
          ? _value.chuhuoAt
          : chuhuoAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sampleLocation: freezed == sampleLocation
          ? _value.sampleLocation
          : sampleLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SupplierCopyWith<$Res>? get supplier {
    if (_value.supplier == null) {
      return null;
    }

    return $SupplierCopyWith<$Res>(_value.supplier!, (value) {
      return _then(_value.copyWith(supplier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuoteImplCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$$QuoteImplCopyWith(
          _$QuoteImpl value, $Res Function(_$QuoteImpl) then) =
      __$$QuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      Supplier? supplier,
      String? packing,
      @JsonKey(name: 'outer_capacity') double? outerCapacity,
      @JsonKey(name: 'outer_volume') double? outerVolume,
      @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
      @JsonKey(name: 'sample_location') String? sampleLocation});

  @override
  $SupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class __$$QuoteImplCopyWithImpl<$Res>
    extends _$QuoteCopyWithImpl<$Res, _$QuoteImpl>
    implements _$$QuoteImplCopyWith<$Res> {
  __$$QuoteImplCopyWithImpl(
      _$QuoteImpl _value, $Res Function(_$QuoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? supplier = freezed,
    Object? packing = freezed,
    Object? outerCapacity = freezed,
    Object? outerVolume = freezed,
    Object? chuhuoAt = freezed,
    Object? sampleLocation = freezed,
  }) {
    return _then(_$QuoteImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as double?,
      freezed == chuhuoAt
          ? _value.chuhuoAt
          : chuhuoAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      freezed == sampleLocation
          ? _value.sampleLocation
          : sampleLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteImpl implements _Quote {
  _$QuoteImpl(
      this.id,
      this.supplier,
      this.packing,
      @JsonKey(name: 'outer_capacity') this.outerCapacity,
      @JsonKey(name: 'outer_volume') this.outerVolume,
      @JsonKey(name: 'chuhuo_at') this.chuhuoAt,
      @JsonKey(name: 'sample_location') this.sampleLocation);

  factory _$QuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteImplFromJson(json);

  @override
  final int? id;
  @override
  final Supplier? supplier;
  @override
  final String? packing;
  @override
  @JsonKey(name: 'outer_capacity')
  final double? outerCapacity;
  @override
  @JsonKey(name: 'outer_volume')
  final double? outerVolume;
  @override
  @JsonKey(name: 'chuhuo_at')
  final DateTime? chuhuoAt;
  @override
  @JsonKey(name: 'sample_location')
  final String? sampleLocation;

  @override
  String toString() {
    return 'Quote(id: $id, supplier: $supplier, packing: $packing, outerCapacity: $outerCapacity, outerVolume: $outerVolume, chuhuoAt: $chuhuoAt, sampleLocation: $sampleLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.packing, packing) || other.packing == packing) &&
            (identical(other.outerCapacity, outerCapacity) ||
                other.outerCapacity == outerCapacity) &&
            (identical(other.outerVolume, outerVolume) ||
                other.outerVolume == outerVolume) &&
            (identical(other.chuhuoAt, chuhuoAt) ||
                other.chuhuoAt == chuhuoAt) &&
            (identical(other.sampleLocation, sampleLocation) ||
                other.sampleLocation == sampleLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, supplier, packing,
      outerCapacity, outerVolume, chuhuoAt, sampleLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      __$$QuoteImplCopyWithImpl<_$QuoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteImplToJson(
      this,
    );
  }
}

abstract class _Quote implements Quote {
  factory _Quote(
          final int? id,
          final Supplier? supplier,
          final String? packing,
          @JsonKey(name: 'outer_capacity') final double? outerCapacity,
          @JsonKey(name: 'outer_volume') final double? outerVolume,
          @JsonKey(name: 'chuhuo_at') final DateTime? chuhuoAt,
          @JsonKey(name: 'sample_location') final String? sampleLocation) =
      _$QuoteImpl;

  factory _Quote.fromJson(Map<String, dynamic> json) = _$QuoteImpl.fromJson;

  @override
  int? get id;
  @override
  Supplier? get supplier;
  @override
  String? get packing;
  @override
  @JsonKey(name: 'outer_capacity')
  double? get outerCapacity;
  @override
  @JsonKey(name: 'outer_volume')
  double? get outerVolume;
  @override
  @JsonKey(name: 'chuhuo_at')
  DateTime? get chuhuoAt;
  @override
  @JsonKey(name: 'sample_location')
  String? get sampleLocation;
  @override
  @JsonKey(ignore: true)
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
