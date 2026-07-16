// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_receipt_item_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseReceiptItemEntry _$WarehouseReceiptItemEntryFromJson(
    Map<String, dynamic> json) {
  return _WarehouseReceiptItemEntry.fromJson(json);
}

/// @nodoc
mixin _$WarehouseReceiptItemEntry {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  int? get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  int? get locationId => throw _privateConstructorUsedError;
  @_LocationConverter()
  @JsonKey(name: 'location')
  WarehouseLocation? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_carton_qty')
  num? get actualCartonQty => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'entered_at')
  DateTime? get enteredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseReceiptItemEntryCopyWith<WarehouseReceiptItemEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseReceiptItemEntryCopyWith<$Res> {
  factory $WarehouseReceiptItemEntryCopyWith(WarehouseReceiptItemEntry value,
          $Res Function(WarehouseReceiptItemEntry) then) =
      _$WarehouseReceiptItemEntryCopyWithImpl<$Res, WarehouseReceiptItemEntry>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'item_id') int? itemId,
      @JsonKey(name: 'location_id') int? locationId,
      @_LocationConverter()
      @JsonKey(name: 'location')
      WarehouseLocation? location,
      @JsonKey(name: 'actual_carton_qty') num? actualCartonQty,
      @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
      @JsonKey(name: 'entered_at') DateTime? enteredAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $WarehouseLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$WarehouseReceiptItemEntryCopyWithImpl<$Res,
        $Val extends WarehouseReceiptItemEntry>
    implements $WarehouseReceiptItemEntryCopyWith<$Res> {
  _$WarehouseReceiptItemEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemId = freezed,
    Object? locationId = freezed,
    Object? location = freezed,
    Object? actualCartonQty = freezed,
    Object? actualOuterCapacity = freezed,
    Object? actualOuterLength = freezed,
    Object? actualOuterWidth = freezed,
    Object? actualOuterHeight = freezed,
    Object? actualOuterGrossWeight = freezed,
    Object? enteredAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as WarehouseLocation?,
      actualCartonQty: freezed == actualCartonQty
          ? _value.actualCartonQty
          : actualCartonQty // ignore: cast_nullable_to_non_nullable
              as num?,
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
      enteredAt: freezed == enteredAt
          ? _value.enteredAt
          : enteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

  @override
  @pragma('vm:prefer-inline')
  $WarehouseLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $WarehouseLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarehouseReceiptItemEntryImplCopyWith<$Res>
    implements $WarehouseReceiptItemEntryCopyWith<$Res> {
  factory _$$WarehouseReceiptItemEntryImplCopyWith(
          _$WarehouseReceiptItemEntryImpl value,
          $Res Function(_$WarehouseReceiptItemEntryImpl) then) =
      __$$WarehouseReceiptItemEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'item_id') int? itemId,
      @JsonKey(name: 'location_id') int? locationId,
      @_LocationConverter()
      @JsonKey(name: 'location')
      WarehouseLocation? location,
      @JsonKey(name: 'actual_carton_qty') num? actualCartonQty,
      @JsonKey(name: 'actual_outer_capacity') int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') num? actualOuterGrossWeight,
      @JsonKey(name: 'entered_at') DateTime? enteredAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $WarehouseLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$WarehouseReceiptItemEntryImplCopyWithImpl<$Res>
    extends _$WarehouseReceiptItemEntryCopyWithImpl<$Res,
        _$WarehouseReceiptItemEntryImpl>
    implements _$$WarehouseReceiptItemEntryImplCopyWith<$Res> {
  __$$WarehouseReceiptItemEntryImplCopyWithImpl(
      _$WarehouseReceiptItemEntryImpl _value,
      $Res Function(_$WarehouseReceiptItemEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemId = freezed,
    Object? locationId = freezed,
    Object? location = freezed,
    Object? actualCartonQty = freezed,
    Object? actualOuterCapacity = freezed,
    Object? actualOuterLength = freezed,
    Object? actualOuterWidth = freezed,
    Object? actualOuterHeight = freezed,
    Object? actualOuterGrossWeight = freezed,
    Object? enteredAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WarehouseReceiptItemEntryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as WarehouseLocation?,
      actualCartonQty: freezed == actualCartonQty
          ? _value.actualCartonQty
          : actualCartonQty // ignore: cast_nullable_to_non_nullable
              as num?,
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
      enteredAt: freezed == enteredAt
          ? _value.enteredAt
          : enteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$WarehouseReceiptItemEntryImpl implements _WarehouseReceiptItemEntry {
  const _$WarehouseReceiptItemEntryImpl(
      {this.id,
      @JsonKey(name: 'item_id') this.itemId,
      @JsonKey(name: 'location_id') this.locationId,
      @_LocationConverter() @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'actual_carton_qty') this.actualCartonQty,
      @JsonKey(name: 'actual_outer_capacity') this.actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') this.actualOuterLength,
      @JsonKey(name: 'actual_outer_width') this.actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') this.actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight') this.actualOuterGrossWeight,
      @JsonKey(name: 'entered_at') this.enteredAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$WarehouseReceiptItemEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseReceiptItemEntryImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'item_id')
  final int? itemId;
  @override
  @JsonKey(name: 'location_id')
  final int? locationId;
  @override
  @_LocationConverter()
  @JsonKey(name: 'location')
  final WarehouseLocation? location;
  @override
  @JsonKey(name: 'actual_carton_qty')
  final num? actualCartonQty;
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
  @JsonKey(name: 'entered_at')
  final DateTime? enteredAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WarehouseReceiptItemEntry(id: $id, itemId: $itemId, locationId: $locationId, location: $location, actualCartonQty: $actualCartonQty, actualOuterCapacity: $actualOuterCapacity, actualOuterLength: $actualOuterLength, actualOuterWidth: $actualOuterWidth, actualOuterHeight: $actualOuterHeight, actualOuterGrossWeight: $actualOuterGrossWeight, enteredAt: $enteredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseReceiptItemEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.actualCartonQty, actualCartonQty) ||
                other.actualCartonQty == actualCartonQty) &&
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
            (identical(other.enteredAt, enteredAt) ||
                other.enteredAt == enteredAt) &&
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
      itemId,
      locationId,
      location,
      actualCartonQty,
      actualOuterCapacity,
      actualOuterLength,
      actualOuterWidth,
      actualOuterHeight,
      actualOuterGrossWeight,
      enteredAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseReceiptItemEntryImplCopyWith<_$WarehouseReceiptItemEntryImpl>
      get copyWith => __$$WarehouseReceiptItemEntryImplCopyWithImpl<
          _$WarehouseReceiptItemEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseReceiptItemEntryImplToJson(
      this,
    );
  }
}

abstract class _WarehouseReceiptItemEntry implements WarehouseReceiptItemEntry {
  const factory _WarehouseReceiptItemEntry(
      {final int? id,
      @JsonKey(name: 'item_id') final int? itemId,
      @JsonKey(name: 'location_id') final int? locationId,
      @_LocationConverter()
      @JsonKey(name: 'location')
      final WarehouseLocation? location,
      @JsonKey(name: 'actual_carton_qty') final num? actualCartonQty,
      @JsonKey(name: 'actual_outer_capacity') final int? actualOuterCapacity,
      @JsonKey(name: 'actual_outer_length') final num? actualOuterLength,
      @JsonKey(name: 'actual_outer_width') final num? actualOuterWidth,
      @JsonKey(name: 'actual_outer_height') final num? actualOuterHeight,
      @JsonKey(name: 'actual_outer_gross_weight')
      final num? actualOuterGrossWeight,
      @JsonKey(name: 'entered_at') final DateTime? enteredAt,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$WarehouseReceiptItemEntryImpl;

  factory _WarehouseReceiptItemEntry.fromJson(Map<String, dynamic> json) =
      _$WarehouseReceiptItemEntryImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'item_id')
  int? get itemId;
  @override
  @JsonKey(name: 'location_id')
  int? get locationId;
  @override
  @_LocationConverter()
  @JsonKey(name: 'location')
  WarehouseLocation? get location;
  @override
  @JsonKey(name: 'actual_carton_qty')
  num? get actualCartonQty;
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
  @JsonKey(name: 'entered_at')
  DateTime? get enteredAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseReceiptItemEntryImplCopyWith<_$WarehouseReceiptItemEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
