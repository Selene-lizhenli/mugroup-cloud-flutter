// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseReceipt _$WarehouseReceiptFromJson(Map<String, dynamic> json) {
  return _WarehouseReceipt.fromJson(json);
}

/// @nodoc
mixin _$WarehouseReceipt {
  int? get id => throw _privateConstructorUsedError;
  String? get hashid => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'seller')
  User? get seller => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchaser')
  User? get purchaser => throw _privateConstructorUsedError;
  @JsonKey(name: 'merchandiser')
  User? get merchandiser => throw _privateConstructorUsedError;
  @JsonKey(name: 'department')
  Department? get department => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_no')
  String? get orderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_no')
  String? get supplierNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_short_name')
  String? get supplierShortName => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_zone')
  String? get deliveryZone => throw _privateConstructorUsedError;
  @JsonKey(name: 'zone_id')
  int? get zoneId => throw _privateConstructorUsedError;
  WarehouseZone? get zone => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw')
  Object? get raw => throw _privateConstructorUsedError;
  @JsonKey(name: 'items')
  List<WarehouseReceiptItem>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseReceiptCopyWith<WarehouseReceipt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseReceiptCopyWith<$Res> {
  factory $WarehouseReceiptCopyWith(
          WarehouseReceipt value, $Res Function(WarehouseReceipt) then) =
      _$WarehouseReceiptCopyWithImpl<$Res, WarehouseReceipt>;
  @useResult
  $Res call(
      {int? id,
      String? hashid,
      @JsonKey(name: 'user') User? user,
      @JsonKey(name: 'seller') User? seller,
      @JsonKey(name: 'purchaser') User? purchaser,
      @JsonKey(name: 'merchandiser') User? merchandiser,
      @JsonKey(name: 'department') Department? department,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'supplier_short_name') String? supplierShortName,
      @JsonKey(name: 'delivery_zone') String? deliveryZone,
      @JsonKey(name: 'zone_id') int? zoneId,
      WarehouseZone? zone,
      @JsonKey(name: 'raw') Object? raw,
      @JsonKey(name: 'items') List<WarehouseReceiptItem>? items,
      @JsonKey(name: 'shipped_at') DateTime? shippedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get seller;
  $UserCopyWith<$Res>? get purchaser;
  $UserCopyWith<$Res>? get merchandiser;
  $DepartmentCopyWith<$Res>? get department;
  $WarehouseZoneCopyWith<$Res>? get zone;
}

/// @nodoc
class _$WarehouseReceiptCopyWithImpl<$Res, $Val extends WarehouseReceipt>
    implements $WarehouseReceiptCopyWith<$Res> {
  _$WarehouseReceiptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? hashid = freezed,
    Object? user = freezed,
    Object? seller = freezed,
    Object? purchaser = freezed,
    Object? merchandiser = freezed,
    Object? department = freezed,
    Object? orderNo = freezed,
    Object? supplierNo = freezed,
    Object? supplierShortName = freezed,
    Object? deliveryZone = freezed,
    Object? zoneId = freezed,
    Object? zone = freezed,
    Object? raw = freezed,
    Object? items = freezed,
    Object? shippedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      hashid: freezed == hashid
          ? _value.hashid
          : hashid // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as User?,
      purchaser: freezed == purchaser
          ? _value.purchaser
          : purchaser // ignore: cast_nullable_to_non_nullable
              as User?,
      merchandiser: freezed == merchandiser
          ? _value.merchandiser
          : merchandiser // ignore: cast_nullable_to_non_nullable
              as User?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as Department?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierShortName: freezed == supplierShortName
          ? _value.supplierShortName
          : supplierShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryZone: freezed == deliveryZone
          ? _value.deliveryZone
          : deliveryZone // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int?,
      zone: freezed == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as WarehouseZone?,
      raw: freezed == raw ? _value.raw : raw,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WarehouseReceiptItem>?,
      shippedAt: freezed == shippedAt
          ? _value.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
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
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get seller {
    if (_value.seller == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.seller!, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get purchaser {
    if (_value.purchaser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.purchaser!, (value) {
      return _then(_value.copyWith(purchaser: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get merchandiser {
    if (_value.merchandiser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.merchandiser!, (value) {
      return _then(_value.copyWith(merchandiser: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DepartmentCopyWith<$Res>? get department {
    if (_value.department == null) {
      return null;
    }

    return $DepartmentCopyWith<$Res>(_value.department!, (value) {
      return _then(_value.copyWith(department: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseZoneCopyWith<$Res>? get zone {
    if (_value.zone == null) {
      return null;
    }

    return $WarehouseZoneCopyWith<$Res>(_value.zone!, (value) {
      return _then(_value.copyWith(zone: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarehouseReceiptImplCopyWith<$Res>
    implements $WarehouseReceiptCopyWith<$Res> {
  factory _$$WarehouseReceiptImplCopyWith(_$WarehouseReceiptImpl value,
          $Res Function(_$WarehouseReceiptImpl) then) =
      __$$WarehouseReceiptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? hashid,
      @JsonKey(name: 'user') User? user,
      @JsonKey(name: 'seller') User? seller,
      @JsonKey(name: 'purchaser') User? purchaser,
      @JsonKey(name: 'merchandiser') User? merchandiser,
      @JsonKey(name: 'department') Department? department,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'supplier_short_name') String? supplierShortName,
      @JsonKey(name: 'delivery_zone') String? deliveryZone,
      @JsonKey(name: 'zone_id') int? zoneId,
      WarehouseZone? zone,
      @JsonKey(name: 'raw') Object? raw,
      @JsonKey(name: 'items') List<WarehouseReceiptItem>? items,
      @JsonKey(name: 'shipped_at') DateTime? shippedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get seller;
  @override
  $UserCopyWith<$Res>? get purchaser;
  @override
  $UserCopyWith<$Res>? get merchandiser;
  @override
  $DepartmentCopyWith<$Res>? get department;
  @override
  $WarehouseZoneCopyWith<$Res>? get zone;
}

/// @nodoc
class __$$WarehouseReceiptImplCopyWithImpl<$Res>
    extends _$WarehouseReceiptCopyWithImpl<$Res, _$WarehouseReceiptImpl>
    implements _$$WarehouseReceiptImplCopyWith<$Res> {
  __$$WarehouseReceiptImplCopyWithImpl(_$WarehouseReceiptImpl _value,
      $Res Function(_$WarehouseReceiptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? hashid = freezed,
    Object? user = freezed,
    Object? seller = freezed,
    Object? purchaser = freezed,
    Object? merchandiser = freezed,
    Object? department = freezed,
    Object? orderNo = freezed,
    Object? supplierNo = freezed,
    Object? supplierShortName = freezed,
    Object? deliveryZone = freezed,
    Object? zoneId = freezed,
    Object? zone = freezed,
    Object? raw = freezed,
    Object? items = freezed,
    Object? shippedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WarehouseReceiptImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      hashid: freezed == hashid
          ? _value.hashid
          : hashid // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as User?,
      purchaser: freezed == purchaser
          ? _value.purchaser
          : purchaser // ignore: cast_nullable_to_non_nullable
              as User?,
      merchandiser: freezed == merchandiser
          ? _value.merchandiser
          : merchandiser // ignore: cast_nullable_to_non_nullable
              as User?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as Department?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierShortName: freezed == supplierShortName
          ? _value.supplierShortName
          : supplierShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryZone: freezed == deliveryZone
          ? _value.deliveryZone
          : deliveryZone // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int?,
      zone: freezed == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as WarehouseZone?,
      raw: freezed == raw ? _value.raw : raw,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<WarehouseReceiptItem>?,
      shippedAt: freezed == shippedAt
          ? _value.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
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
class _$WarehouseReceiptImpl implements _WarehouseReceipt {
  const _$WarehouseReceiptImpl(
      {this.id,
      this.hashid,
      @JsonKey(name: 'user') this.user,
      @JsonKey(name: 'seller') this.seller,
      @JsonKey(name: 'purchaser') this.purchaser,
      @JsonKey(name: 'merchandiser') this.merchandiser,
      @JsonKey(name: 'department') this.department,
      @JsonKey(name: 'order_no') this.orderNo,
      @JsonKey(name: 'supplier_no') this.supplierNo,
      @JsonKey(name: 'supplier_short_name') this.supplierShortName,
      @JsonKey(name: 'delivery_zone') this.deliveryZone,
      @JsonKey(name: 'zone_id') this.zoneId,
      this.zone,
      @JsonKey(name: 'raw') this.raw,
      @JsonKey(name: 'items') final List<WarehouseReceiptItem>? items,
      @JsonKey(name: 'shipped_at') this.shippedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _items = items;

  factory _$WarehouseReceiptImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseReceiptImplFromJson(json);

  @override
  final int? id;
  @override
  final String? hashid;
  @override
  @JsonKey(name: 'user')
  final User? user;
  @override
  @JsonKey(name: 'seller')
  final User? seller;
  @override
  @JsonKey(name: 'purchaser')
  final User? purchaser;
  @override
  @JsonKey(name: 'merchandiser')
  final User? merchandiser;
  @override
  @JsonKey(name: 'department')
  final Department? department;
  @override
  @JsonKey(name: 'order_no')
  final String? orderNo;
  @override
  @JsonKey(name: 'supplier_no')
  final String? supplierNo;
  @override
  @JsonKey(name: 'supplier_short_name')
  final String? supplierShortName;
  @override
  @JsonKey(name: 'delivery_zone')
  final String? deliveryZone;
  @override
  @JsonKey(name: 'zone_id')
  final int? zoneId;
  @override
  final WarehouseZone? zone;
  @override
  @JsonKey(name: 'raw')
  final Object? raw;
  final List<WarehouseReceiptItem>? _items;
  @override
  @JsonKey(name: 'items')
  List<WarehouseReceiptItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'shipped_at')
  final DateTime? shippedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WarehouseReceipt(id: $id, hashid: $hashid, user: $user, seller: $seller, purchaser: $purchaser, merchandiser: $merchandiser, department: $department, orderNo: $orderNo, supplierNo: $supplierNo, supplierShortName: $supplierShortName, deliveryZone: $deliveryZone, zoneId: $zoneId, zone: $zone, raw: $raw, items: $items, shippedAt: $shippedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseReceiptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hashid, hashid) || other.hashid == hashid) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            (identical(other.purchaser, purchaser) ||
                other.purchaser == purchaser) &&
            (identical(other.merchandiser, merchandiser) ||
                other.merchandiser == merchandiser) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.supplierNo, supplierNo) ||
                other.supplierNo == supplierNo) &&
            (identical(other.supplierShortName, supplierShortName) ||
                other.supplierShortName == supplierShortName) &&
            (identical(other.deliveryZone, deliveryZone) ||
                other.deliveryZone == deliveryZone) &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            const DeepCollectionEquality().equals(other.raw, raw) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
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
      hashid,
      user,
      seller,
      purchaser,
      merchandiser,
      department,
      orderNo,
      supplierNo,
      supplierShortName,
      deliveryZone,
      zoneId,
      zone,
      const DeepCollectionEquality().hash(raw),
      const DeepCollectionEquality().hash(_items),
      shippedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseReceiptImplCopyWith<_$WarehouseReceiptImpl> get copyWith =>
      __$$WarehouseReceiptImplCopyWithImpl<_$WarehouseReceiptImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseReceiptImplToJson(
      this,
    );
  }
}

abstract class _WarehouseReceipt implements WarehouseReceipt {
  const factory _WarehouseReceipt(
          {final int? id,
          final String? hashid,
          @JsonKey(name: 'user') final User? user,
          @JsonKey(name: 'seller') final User? seller,
          @JsonKey(name: 'purchaser') final User? purchaser,
          @JsonKey(name: 'merchandiser') final User? merchandiser,
          @JsonKey(name: 'department') final Department? department,
          @JsonKey(name: 'order_no') final String? orderNo,
          @JsonKey(name: 'supplier_no') final String? supplierNo,
          @JsonKey(name: 'supplier_short_name') final String? supplierShortName,
          @JsonKey(name: 'delivery_zone') final String? deliveryZone,
          @JsonKey(name: 'zone_id') final int? zoneId,
          final WarehouseZone? zone,
          @JsonKey(name: 'raw') final Object? raw,
          @JsonKey(name: 'items') final List<WarehouseReceiptItem>? items,
          @JsonKey(name: 'shipped_at') final DateTime? shippedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$WarehouseReceiptImpl;

  factory _WarehouseReceipt.fromJson(Map<String, dynamic> json) =
      _$WarehouseReceiptImpl.fromJson;

  @override
  int? get id;
  @override
  String? get hashid;
  @override
  @JsonKey(name: 'user')
  User? get user;
  @override
  @JsonKey(name: 'seller')
  User? get seller;
  @override
  @JsonKey(name: 'purchaser')
  User? get purchaser;
  @override
  @JsonKey(name: 'merchandiser')
  User? get merchandiser;
  @override
  @JsonKey(name: 'department')
  Department? get department;
  @override
  @JsonKey(name: 'order_no')
  String? get orderNo;
  @override
  @JsonKey(name: 'supplier_no')
  String? get supplierNo;
  @override
  @JsonKey(name: 'supplier_short_name')
  String? get supplierShortName;
  @override
  @JsonKey(name: 'delivery_zone')
  String? get deliveryZone;
  @override
  @JsonKey(name: 'zone_id')
  int? get zoneId;
  @override
  WarehouseZone? get zone;
  @override
  @JsonKey(name: 'raw')
  Object? get raw;
  @override
  @JsonKey(name: 'items')
  List<WarehouseReceiptItem>? get items;
  @override
  @JsonKey(name: 'shipped_at')
  DateTime? get shippedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseReceiptImplCopyWith<_$WarehouseReceiptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
