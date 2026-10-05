// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_receipt_mixed_carton.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseReceiptMixedCarton _$WarehouseReceiptMixedCartonFromJson(
    Map<String, dynamic> json) {
  return _WarehouseReceiptMixedCarton.fromJson(json);
}

/// @nodoc
mixin _$WarehouseReceiptMixedCarton {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_id')
  int? get receiptId => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_outer_capacity')
  int? get actualOuterCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_outer_length')
  num? get actualOuterLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_outer_width')
  num? get actualOuterWidth => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_outer_height')
  num? get actualOuterHeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_outer_gross_weight')
  num? get actualOuterGrossWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'entries_count')
  int? get entriesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseReceiptMixedCartonCopyWith<WarehouseReceiptMixedCarton>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseReceiptMixedCartonCopyWith<$Res> {
  factory $WarehouseReceiptMixedCartonCopyWith(
          WarehouseReceiptMixedCarton value,
          $Res Function(WarehouseReceiptMixedCarton) then) =
      _$WarehouseReceiptMixedCartonCopyWithImpl<$Res,
          WarehouseReceiptMixedCarton>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'receipt_id') int? receiptId,
      String? code,
      @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
      @JsonKey(name: 'entries_count') int? entriesCount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$WarehouseReceiptMixedCartonCopyWithImpl<$Res,
        $Val extends WarehouseReceiptMixedCarton>
    implements $WarehouseReceiptMixedCartonCopyWith<$Res> {
  _$WarehouseReceiptMixedCartonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? receiptId = freezed,
    Object? code = freezed,
    Object? actualOuterCapacity = freezed,
    Object? actualOuterLength = freezed,
    Object? actualOuterWidth = freezed,
    Object? actualOuterHeight = freezed,
    Object? actualOuterGrossWeight = freezed,
    Object? entriesCount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      receiptId: freezed == receiptId
          ? _value.receiptId
          : receiptId // ignore: cast_nullable_to_non_nullable
              as int?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      actualOuterCapacity: freezed == actualOuterCapacity
          ? _value.actualOuterCapacity
          : actualOuterCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      actualOuterLength: freezed == actualOuterLength
          ? _value.actualOuterLength
          : actualOuterLength // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterWidth: freezed == actualOuterWidth
          ? _value.actualOuterWidth
          : actualOuterWidth // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterHeight: freezed == actualOuterHeight
          ? _value.actualOuterHeight
          : actualOuterHeight // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterGrossWeight: freezed == actualOuterGrossWeight
          ? _value.actualOuterGrossWeight
          : actualOuterGrossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      entriesCount: freezed == entriesCount
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarehouseReceiptMixedCartonImplCopyWith<$Res>
    implements $WarehouseReceiptMixedCartonCopyWith<$Res> {
  factory _$$WarehouseReceiptMixedCartonImplCopyWith(
          _$WarehouseReceiptMixedCartonImpl value,
          $Res Function(_$WarehouseReceiptMixedCartonImpl) then) =
      __$$WarehouseReceiptMixedCartonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'receipt_id') int? receiptId,
      String? code,
      @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
      @JsonKey(name: 'entries_count') int? entriesCount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$WarehouseReceiptMixedCartonImplCopyWithImpl<$Res>
    extends _$WarehouseReceiptMixedCartonCopyWithImpl<$Res,
        _$WarehouseReceiptMixedCartonImpl>
    implements _$$WarehouseReceiptMixedCartonImplCopyWith<$Res> {
  __$$WarehouseReceiptMixedCartonImplCopyWithImpl(
      _$WarehouseReceiptMixedCartonImpl _value,
      $Res Function(_$WarehouseReceiptMixedCartonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? receiptId = freezed,
    Object? code = freezed,
    Object? actualOuterCapacity = freezed,
    Object? actualOuterLength = freezed,
    Object? actualOuterWidth = freezed,
    Object? actualOuterHeight = freezed,
    Object? actualOuterGrossWeight = freezed,
    Object? entriesCount = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WarehouseReceiptMixedCartonImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      receiptId: freezed == receiptId
          ? _value.receiptId
          : receiptId // ignore: cast_nullable_to_non_nullable
              as int?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      actualOuterCapacity: freezed == actualOuterCapacity
          ? _value.actualOuterCapacity
          : actualOuterCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      actualOuterLength: freezed == actualOuterLength
          ? _value.actualOuterLength
          : actualOuterLength // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterWidth: freezed == actualOuterWidth
          ? _value.actualOuterWidth
          : actualOuterWidth // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterHeight: freezed == actualOuterHeight
          ? _value.actualOuterHeight
          : actualOuterHeight // ignore: cast_nullable_to_non_nullable
              as num?,
      actualOuterGrossWeight: freezed == actualOuterGrossWeight
          ? _value.actualOuterGrossWeight
          : actualOuterGrossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      entriesCount: freezed == entriesCount
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseReceiptMixedCartonImpl
    implements _WarehouseReceiptMixedCarton {
  const _$WarehouseReceiptMixedCartonImpl(
      {this.id,
      @JsonKey(name: 'receipt_id') this.receiptId,
      this.code,
      @JsonKey(name: 'actual_outer_capacity') this.actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') this.actualOuterLength,
      @JsonKey(name: 'actual_outer_width') this.actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') this.actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') this.actualOuterGrossWeight,
      @JsonKey(name: 'entries_count') this.entriesCount,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$WarehouseReceiptMixedCartonImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WarehouseReceiptMixedCartonImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'receipt_id')
  final int? receiptId;
  @override
  final String? code;
  @override
  @JsonKey(name: 'actual_outer_capacity')
  final int? actualOuterCapacity;
  @override
  @JsonKey(name: 'actual_outer_length')
  final num? actualOuterLength;
  @override
  @JsonKey(name: 'actual_outer_width')
  final num? actualOuterWidth;
  @override
  @JsonKey(name: 'actual_outer_height')
  final num? actualOuterHeight;
  @override
  @JsonKey(name: 'actual_outer_gross_weight')
  final num? actualOuterGrossWeight;
  @override
  @JsonKey(name: 'entries_count')
  final int? entriesCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WarehouseReceiptMixedCarton(id: $id, receiptId: $receiptId, code: $code, actualOuterCapacity: $actualOuterCapacity, actualOuterLength: $actualOuterLength, actualOuterWidth: $actualOuterWidth, actualOuterHeight: $actualOuterHeight, actualOuterGrossWeight: $actualOuterGrossWeight, entriesCount: $entriesCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseReceiptMixedCartonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receiptId, receiptId) ||
                other.receiptId == receiptId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.actualOuterCapacity, actualOuterCapacity) ||
                other.actualOuterCapacity == actualOuterCapacity) &&
            (identical(other.actualOuterLength, actualOuterLength) ||
                other.actualOuterLength == actualOuterLength) &&
            (identical(other.actualOuterWidth, actualOuterWidth) ||
                other.actualOuterWidth == actualOuterWidth) &&
            (identical(other.actualOuterHeight, actualOuterHeight) ||
                other.actualOuterHeight == actualOuterHeight) &&
            (identical(other.actualOuterGrossWeight, actualOuterGrossWeight) ||
                other.actualOuterGrossWeight == actualOuterGrossWeight) &&
            (identical(other.entriesCount, entriesCount) ||
                other.entriesCount == entriesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      receiptId,
      code,
      actualOuterCapacity,
      actualOuterLength,
      actualOuterWidth,
      actualOuterHeight,
      actualOuterGrossWeight,
      entriesCount,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseReceiptMixedCartonImplCopyWith<_$WarehouseReceiptMixedCartonImpl>
      get copyWith => __$$WarehouseReceiptMixedCartonImplCopyWithImpl<
          _$WarehouseReceiptMixedCartonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseReceiptMixedCartonImplToJson(
      this,
    );
  }
}

abstract class _WarehouseReceiptMixedCarton
    implements WarehouseReceiptMixedCarton {
  const factory _WarehouseReceiptMixedCarton(
      {final int? id,
      @JsonKey(name: 'receipt_id') final int? receiptId,
      final String? code,
      @JsonKey(name: 'actual_outer_capacity') final int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') final num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') final num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') final num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight')
      final num? actualOuterGrossWeight,
      @JsonKey(name: 'entries_count') final int? entriesCount,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$WarehouseReceiptMixedCartonImpl;

  factory _WarehouseReceiptMixedCarton.fromJson(Map<String, dynamic> json) =
      _$WarehouseReceiptMixedCartonImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'receipt_id')
  int? get receiptId;
  @override
  String? get code;
  @override
  @JsonKey(name: 'actual_outer_capacity')
  int? get actualOuterCapacity;
  @override
  @JsonKey(name: 'actual_outer_length')
  num? get actualOuterLength;
  @override
  @JsonKey(name: 'actual_outer_width')
  num? get actualOuterWidth;
  @override
  @JsonKey(name: 'actual_outer_height')
  num? get actualOuterHeight;
  @override
  @JsonKey(name: 'actual_outer_gross_weight')
  num? get actualOuterGrossWeight;
  @override
  @JsonKey(name: 'entries_count')
  int? get entriesCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseReceiptMixedCartonImplCopyWith<_$WarehouseReceiptMixedCartonImpl>
      get copyWith => throw _privateConstructorUsedError;
}
