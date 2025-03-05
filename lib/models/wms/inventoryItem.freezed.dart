// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventoryItem.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) {
  return _InventoryItem.fromJson(json);
}

/// @nodoc
mixin _$InventoryItem {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int? get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'previous_qty')
  int? get previousQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_qty')
  int? get newQty => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryItemCopyWith<InventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemCopyWith<$Res> {
  factory $InventoryItemCopyWith(
          InventoryItem value, $Res Function(InventoryItem) then) =
      _$InventoryItemCopyWithImpl<$Res, InventoryItem>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'previous_qty') int? previousQty,
      @JsonKey(name: 'new_qty') int? newQty});
}

/// @nodoc
class _$InventoryItemCopyWithImpl<$Res, $Val extends InventoryItem>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? inventoryId = freezed,
    Object? productId = freezed,
    Object? previousQty = freezed,
    Object? newQty = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      previousQty: freezed == previousQty
          ? _value.previousQty
          : previousQty // ignore: cast_nullable_to_non_nullable
              as int?,
      newQty: freezed == newQty
          ? _value.newQty
          : newQty // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryItemImplCopyWith<$Res>
    implements $InventoryItemCopyWith<$Res> {
  factory _$$InventoryItemImplCopyWith(
          _$InventoryItemImpl value, $Res Function(_$InventoryItemImpl) then) =
      __$$InventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'previous_qty') int? previousQty,
      @JsonKey(name: 'new_qty') int? newQty});
}

/// @nodoc
class __$$InventoryItemImplCopyWithImpl<$Res>
    extends _$InventoryItemCopyWithImpl<$Res, _$InventoryItemImpl>
    implements _$$InventoryItemImplCopyWith<$Res> {
  __$$InventoryItemImplCopyWithImpl(
      _$InventoryItemImpl _value, $Res Function(_$InventoryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? inventoryId = freezed,
    Object? productId = freezed,
    Object? previousQty = freezed,
    Object? newQty = freezed,
  }) {
    return _then(_$InventoryItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      previousQty: freezed == previousQty
          ? _value.previousQty
          : previousQty // ignore: cast_nullable_to_non_nullable
              as int?,
      newQty: freezed == newQty
          ? _value.newQty
          : newQty // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemImpl implements _InventoryItem {
  const _$InventoryItemImpl(
      {this.id,
      @JsonKey(name: 'inventory_id') this.inventoryId,
      @JsonKey(name: 'product_id') this.productId,
      @JsonKey(name: 'previous_qty') this.previousQty,
      @JsonKey(name: 'new_qty') this.newQty});

  factory _$InventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'inventory_id')
  final int? inventoryId;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;
  @override
  @JsonKey(name: 'previous_qty')
  final int? previousQty;
  @override
  @JsonKey(name: 'new_qty')
  final int? newQty;

  @override
  String toString() {
    return 'InventoryItem(id: $id, inventoryId: $inventoryId, productId: $productId, previousQty: $previousQty, newQty: $newQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.previousQty, previousQty) ||
                other.previousQty == previousQty) &&
            (identical(other.newQty, newQty) || other.newQty == newQty));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, inventoryId, productId, previousQty, newQty);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      __$$InventoryItemImplCopyWithImpl<_$InventoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemImplToJson(
      this,
    );
  }
}

abstract class _InventoryItem implements InventoryItem {
  const factory _InventoryItem(
      {final int? id,
      @JsonKey(name: 'inventory_id') final int? inventoryId,
      @JsonKey(name: 'product_id') final int? productId,
      @JsonKey(name: 'previous_qty') final int? previousQty,
      @JsonKey(name: 'new_qty') final int? newQty}) = _$InventoryItemImpl;

  factory _InventoryItem.fromJson(Map<String, dynamic> json) =
      _$InventoryItemImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'inventory_id')
  int? get inventoryId;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;
  @override
  @JsonKey(name: 'previous_qty')
  int? get previousQty;
  @override
  @JsonKey(name: 'new_qty')
  int? get newQty;
  @override
  @JsonKey(ignore: true)
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
