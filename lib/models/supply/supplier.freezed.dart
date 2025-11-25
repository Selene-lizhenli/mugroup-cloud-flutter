// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Supplier _$SupplierFromJson(Map<String, dynamic> json) {
  return _Supplier.fromJson(json);
}

/// @nodoc
mixin _$Supplier {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_no')
  String? get supplierNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_core')
  bool? get isCore => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_bill')
  bool? get canBill => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_scope')
  String? get businessScope => throw _privateConstructorUsedError;
  @JsonKey(name: 'export_market')
  String? get exportMarket => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_amount')
  String? get shippingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_name')
  String? get shortName => throw _privateConstructorUsedError;
  List<Contact>? get contacts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupplierCopyWith<Supplier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierCopyWith<$Res> {
  factory $SupplierCopyWith(Supplier value, $Res Function(Supplier) then) =
      _$SupplierCopyWithImpl<$Res, Supplier>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? city,
      String? province,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'is_core') bool? isCore,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'business_scope') String? businessScope,
      @JsonKey(name: 'export_market') String? exportMarket,
      @JsonKey(name: 'shipping_amount') String? shippingAmount,
      @JsonKey(name: 'short_name') String? shortName,
      List<Contact>? contacts});
}

/// @nodoc
class _$SupplierCopyWithImpl<$Res, $Val extends Supplier>
    implements $SupplierCopyWith<$Res> {
  _$SupplierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? supplierNo = freezed,
    Object? isCore = freezed,
    Object? canBill = freezed,
    Object? businessScope = freezed,
    Object? exportMarket = freezed,
    Object? shippingAmount = freezed,
    Object? shortName = freezed,
    Object? contacts = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      isCore: freezed == isCore
          ? _value.isCore
          : isCore // ignore: cast_nullable_to_non_nullable
              as bool?,
      canBill: freezed == canBill
          ? _value.canBill
          : canBill // ignore: cast_nullable_to_non_nullable
              as bool?,
      businessScope: freezed == businessScope
          ? _value.businessScope
          : businessScope // ignore: cast_nullable_to_non_nullable
              as String?,
      exportMarket: freezed == exportMarket
          ? _value.exportMarket
          : exportMarket // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAmount: freezed == shippingAmount
          ? _value.shippingAmount
          : shippingAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      contacts: freezed == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupplierImplCopyWith<$Res>
    implements $SupplierCopyWith<$Res> {
  factory _$$SupplierImplCopyWith(
          _$SupplierImpl value, $Res Function(_$SupplierImpl) then) =
      __$$SupplierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? city,
      String? province,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'is_core') bool? isCore,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'business_scope') String? businessScope,
      @JsonKey(name: 'export_market') String? exportMarket,
      @JsonKey(name: 'shipping_amount') String? shippingAmount,
      @JsonKey(name: 'short_name') String? shortName,
      List<Contact>? contacts});
}

/// @nodoc
class __$$SupplierImplCopyWithImpl<$Res>
    extends _$SupplierCopyWithImpl<$Res, _$SupplierImpl>
    implements _$$SupplierImplCopyWith<$Res> {
  __$$SupplierImplCopyWithImpl(
      _$SupplierImpl _value, $Res Function(_$SupplierImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? supplierNo = freezed,
    Object? isCore = freezed,
    Object? canBill = freezed,
    Object? businessScope = freezed,
    Object? exportMarket = freezed,
    Object? shippingAmount = freezed,
    Object? shortName = freezed,
    Object? contacts = freezed,
  }) {
    return _then(_$SupplierImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == isCore
          ? _value.isCore
          : isCore // ignore: cast_nullable_to_non_nullable
              as bool?,
      freezed == canBill
          ? _value.canBill
          : canBill // ignore: cast_nullable_to_non_nullable
              as bool?,
      freezed == businessScope
          ? _value.businessScope
          : businessScope // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == exportMarket
          ? _value.exportMarket
          : exportMarket // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == shippingAmount
          ? _value.shippingAmount
          : shippingAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierImpl implements _Supplier {
  _$SupplierImpl(
      this.id,
      this.name,
      this.city,
      this.province,
      @JsonKey(name: 'supplier_no') this.supplierNo,
      @JsonKey(name: 'is_core') this.isCore,
      @JsonKey(name: 'can_bill') this.canBill,
      @JsonKey(name: 'business_scope') this.businessScope,
      @JsonKey(name: 'export_market') this.exportMarket,
      @JsonKey(name: 'shipping_amount') this.shippingAmount,
      @JsonKey(name: 'short_name') this.shortName,
      final List<Contact>? contacts)
      : _contacts = contacts;

  factory _$SupplierImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? city;
  @override
  final String? province;
  @override
  @JsonKey(name: 'supplier_no')
  final String? supplierNo;
  @override
  @JsonKey(name: 'is_core')
  final bool? isCore;
  @override
  @JsonKey(name: 'can_bill')
  final bool? canBill;
  @override
  @JsonKey(name: 'business_scope')
  final String? businessScope;
  @override
  @JsonKey(name: 'export_market')
  final String? exportMarket;
  @override
  @JsonKey(name: 'shipping_amount')
  final String? shippingAmount;
  @override
  @JsonKey(name: 'short_name')
  final String? shortName;
  final List<Contact>? _contacts;
  @override
  List<Contact>? get contacts {
    final value = _contacts;
    if (value == null) return null;
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Supplier(id: $id, name: $name, city: $city, province: $province, supplierNo: $supplierNo, isCore: $isCore, canBill: $canBill, businessScope: $businessScope, exportMarket: $exportMarket, shippingAmount: $shippingAmount, shortName: $shortName, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.supplierNo, supplierNo) ||
                other.supplierNo == supplierNo) &&
            (identical(other.isCore, isCore) || other.isCore == isCore) &&
            (identical(other.canBill, canBill) || other.canBill == canBill) &&
            (identical(other.businessScope, businessScope) ||
                other.businessScope == businessScope) &&
            (identical(other.exportMarket, exportMarket) ||
                other.exportMarket == exportMarket) &&
            (identical(other.shippingAmount, shippingAmount) ||
                other.shippingAmount == shippingAmount) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      city,
      province,
      supplierNo,
      isCore,
      canBill,
      businessScope,
      exportMarket,
      shippingAmount,
      shortName,
      const DeepCollectionEquality().hash(_contacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierImplCopyWith<_$SupplierImpl> get copyWith =>
      __$$SupplierImplCopyWithImpl<_$SupplierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplierImplToJson(
      this,
    );
  }
}

abstract class _Supplier implements Supplier {
  factory _Supplier(
      final int? id,
      final String? name,
      final String? city,
      final String? province,
      @JsonKey(name: 'supplier_no') final String? supplierNo,
      @JsonKey(name: 'is_core') final bool? isCore,
      @JsonKey(name: 'can_bill') final bool? canBill,
      @JsonKey(name: 'business_scope') final String? businessScope,
      @JsonKey(name: 'export_market') final String? exportMarket,
      @JsonKey(name: 'shipping_amount') final String? shippingAmount,
      @JsonKey(name: 'short_name') final String? shortName,
      final List<Contact>? contacts) = _$SupplierImpl;

  factory _Supplier.fromJson(Map<String, dynamic> json) =
      _$SupplierImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get city;
  @override
  String? get province;
  @override
  @JsonKey(name: 'supplier_no')
  String? get supplierNo;
  @override
  @JsonKey(name: 'is_core')
  bool? get isCore;
  @override
  @JsonKey(name: 'can_bill')
  bool? get canBill;
  @override
  @JsonKey(name: 'business_scope')
  String? get businessScope;
  @override
  @JsonKey(name: 'export_market')
  String? get exportMarket;
  @override
  @JsonKey(name: 'shipping_amount')
  String? get shippingAmount;
  @override
  @JsonKey(name: 'short_name')
  String? get shortName;
  @override
  List<Contact>? get contacts;
  @override
  @JsonKey(ignore: true)
  _$$SupplierImplCopyWith<_$SupplierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
