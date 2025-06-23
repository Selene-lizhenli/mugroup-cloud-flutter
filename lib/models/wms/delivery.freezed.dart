// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Delivery _$DeliveryFromJson(Map<String, dynamic> json) {
  return _Delivery.fromJson(json);
}

/// @nodoc
mixin _$Delivery {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "order_no")
  String? get orderNo => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  DeliveryStatus? get status => throw _privateConstructorUsedError;
  Warehouse? get warehouse => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: "item_sum_qty")
  int? get itemSumQty => throw _privateConstructorUsedError;
  @JsonKey(name: "item_count_qty")
  int? get itemCountQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'items')
  List<DeliveryItem>? get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeliveryCopyWith<Delivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) then) =
      _$DeliveryCopyWithImpl<$Res, Delivery>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: "order_no") String? orderNo,
      String? remark,
      DeliveryStatus? status,
      Warehouse? warehouse,
      User? user,
      @JsonKey(name: "item_sum_qty") int? itemSumQty,
      @JsonKey(name: "item_count_qty") int? itemCountQty,
      @JsonKey(name: 'items') List<DeliveryItem>? items});

  $WarehouseCopyWith<$Res>? get warehouse;
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$DeliveryCopyWithImpl<$Res, $Val extends Delivery>
    implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? remark = freezed,
    Object? status = freezed,
    Object? warehouse = freezed,
    Object? user = freezed,
    Object? itemSumQty = freezed,
    Object? itemCountQty = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus?,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      itemSumQty: freezed == itemSumQty
          ? _value.itemSumQty
          : itemSumQty // ignore: cast_nullable_to_non_nullable
              as int?,
      itemCountQty: freezed == itemCountQty
          ? _value.itemCountQty
          : itemCountQty // ignore: cast_nullable_to_non_nullable
              as int?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DeliveryItem>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseCopyWith<$Res>? get warehouse {
    if (_value.warehouse == null) {
      return null;
    }

    return $WarehouseCopyWith<$Res>(_value.warehouse!, (value) {
      return _then(_value.copyWith(warehouse: value) as $Val);
    });
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
abstract class _$$DeliveryImplCopyWith<$Res>
    implements $DeliveryCopyWith<$Res> {
  factory _$$DeliveryImplCopyWith(
          _$DeliveryImpl value, $Res Function(_$DeliveryImpl) then) =
      __$$DeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: "order_no") String? orderNo,
      String? remark,
      DeliveryStatus? status,
      Warehouse? warehouse,
      User? user,
      @JsonKey(name: "item_sum_qty") int? itemSumQty,
      @JsonKey(name: "item_count_qty") int? itemCountQty,
      @JsonKey(name: 'items') List<DeliveryItem>? items});

  @override
  $WarehouseCopyWith<$Res>? get warehouse;
  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$DeliveryImplCopyWithImpl<$Res>
    extends _$DeliveryCopyWithImpl<$Res, _$DeliveryImpl>
    implements _$$DeliveryImplCopyWith<$Res> {
  __$$DeliveryImplCopyWithImpl(
      _$DeliveryImpl _value, $Res Function(_$DeliveryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? remark = freezed,
    Object? status = freezed,
    Object? warehouse = freezed,
    Object? user = freezed,
    Object? itemSumQty = freezed,
    Object? itemCountQty = freezed,
    Object? items = freezed,
  }) {
    return _then(_$DeliveryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeliveryStatus?,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      itemSumQty: freezed == itemSumQty
          ? _value.itemSumQty
          : itemSumQty // ignore: cast_nullable_to_non_nullable
              as int?,
      itemCountQty: freezed == itemCountQty
          ? _value.itemCountQty
          : itemCountQty // ignore: cast_nullable_to_non_nullable
              as int?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<DeliveryItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryImpl implements _Delivery {
  _$DeliveryImpl(
      {this.id,
      @JsonKey(name: "order_no") this.orderNo,
      this.remark,
      this.status,
      this.warehouse,
      this.user,
      @JsonKey(name: "item_sum_qty") this.itemSumQty,
      @JsonKey(name: "item_count_qty") this.itemCountQty,
      @JsonKey(name: 'items') final List<DeliveryItem>? items})
      : _items = items;

  factory _$DeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: "order_no")
  final String? orderNo;
  @override
  final String? remark;
  @override
  final DeliveryStatus? status;
  @override
  final Warehouse? warehouse;
  @override
  final User? user;
  @override
  @JsonKey(name: "item_sum_qty")
  final int? itemSumQty;
  @override
  @JsonKey(name: "item_count_qty")
  final int? itemCountQty;
  final List<DeliveryItem>? _items;
  @override
  @JsonKey(name: 'items')
  List<DeliveryItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Delivery(id: $id, orderNo: $orderNo, remark: $remark, status: $status, warehouse: $warehouse, user: $user, itemSumQty: $itemSumQty, itemCountQty: $itemCountQty, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.warehouse, warehouse) ||
                other.warehouse == warehouse) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.itemSumQty, itemSumQty) ||
                other.itemSumQty == itemSumQty) &&
            (identical(other.itemCountQty, itemCountQty) ||
                other.itemCountQty == itemCountQty) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNo,
      remark,
      status,
      warehouse,
      user,
      itemSumQty,
      itemCountQty,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      __$$DeliveryImplCopyWithImpl<_$DeliveryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryImplToJson(
      this,
    );
  }
}

abstract class _Delivery implements Delivery {
  factory _Delivery(
          {final int? id,
          @JsonKey(name: "order_no") final String? orderNo,
          final String? remark,
          final DeliveryStatus? status,
          final Warehouse? warehouse,
          final User? user,
          @JsonKey(name: "item_sum_qty") final int? itemSumQty,
          @JsonKey(name: "item_count_qty") final int? itemCountQty,
          @JsonKey(name: 'items') final List<DeliveryItem>? items}) =
      _$DeliveryImpl;

  factory _Delivery.fromJson(Map<String, dynamic> json) =
      _$DeliveryImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: "order_no")
  String? get orderNo;
  @override
  String? get remark;
  @override
  DeliveryStatus? get status;
  @override
  Warehouse? get warehouse;
  @override
  User? get user;
  @override
  @JsonKey(name: "item_sum_qty")
  int? get itemSumQty;
  @override
  @JsonKey(name: "item_count_qty")
  int? get itemCountQty;
  @override
  @JsonKey(name: 'items')
  List<DeliveryItem>? get items;
  @override
  @JsonKey(ignore: true)
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
