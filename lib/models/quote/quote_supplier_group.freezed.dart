// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_supplier_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteSupplierGroup _$QuoteSupplierGroupFromJson(Map<String, dynamic> json) {
  return _QuoteSupplierGroup.fromJson(json);
}

/// @nodoc
mixin _$QuoteSupplierGroup {
  int? get count => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;

  /// ⚠️ 注意：这里不是 Supplier，而是 QuoteSupplier
  @JsonKey(name: 'supplier')
  QuoteSupplier? get supplier => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuoteSupplierGroupCopyWith<QuoteSupplierGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteSupplierGroupCopyWith<$Res> {
  factory $QuoteSupplierGroupCopyWith(
          QuoteSupplierGroup value, $Res Function(QuoteSupplierGroup) then) =
      _$QuoteSupplierGroupCopyWithImpl<$Res, QuoteSupplierGroup>;
  @useResult
  $Res call(
      {int? count,
      int? qty,
      @JsonKey(name: 'supplier') QuoteSupplier? supplier});

  $QuoteSupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class _$QuoteSupplierGroupCopyWithImpl<$Res, $Val extends QuoteSupplierGroup>
    implements $QuoteSupplierGroupCopyWith<$Res> {
  _$QuoteSupplierGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? qty = freezed,
    Object? supplier = freezed,
  }) {
    return _then(_value.copyWith(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as QuoteSupplier?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $QuoteSupplierCopyWith<$Res>? get supplier {
    if (_value.supplier == null) {
      return null;
    }

    return $QuoteSupplierCopyWith<$Res>(_value.supplier!, (value) {
      return _then(_value.copyWith(supplier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuoteSupplierGroupImplCopyWith<$Res>
    implements $QuoteSupplierGroupCopyWith<$Res> {
  factory _$$QuoteSupplierGroupImplCopyWith(_$QuoteSupplierGroupImpl value,
          $Res Function(_$QuoteSupplierGroupImpl) then) =
      __$$QuoteSupplierGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? count,
      int? qty,
      @JsonKey(name: 'supplier') QuoteSupplier? supplier});

  @override
  $QuoteSupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class __$$QuoteSupplierGroupImplCopyWithImpl<$Res>
    extends _$QuoteSupplierGroupCopyWithImpl<$Res, _$QuoteSupplierGroupImpl>
    implements _$$QuoteSupplierGroupImplCopyWith<$Res> {
  __$$QuoteSupplierGroupImplCopyWithImpl(_$QuoteSupplierGroupImpl _value,
      $Res Function(_$QuoteSupplierGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? qty = freezed,
    Object? supplier = freezed,
  }) {
    return _then(_$QuoteSupplierGroupImpl(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as QuoteSupplier?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteSupplierGroupImpl implements _QuoteSupplierGroup {
  const _$QuoteSupplierGroupImpl(
      {this.count, this.qty, @JsonKey(name: 'supplier') this.supplier});

  factory _$QuoteSupplierGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteSupplierGroupImplFromJson(json);

  @override
  final int? count;
  @override
  final int? qty;

  /// ⚠️ 注意：这里不是 Supplier，而是 QuoteSupplier
  @override
  @JsonKey(name: 'supplier')
  final QuoteSupplier? supplier;

  @override
  String toString() {
    return 'QuoteSupplierGroup(count: $count, qty: $qty, supplier: $supplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteSupplierGroupImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, count, qty, supplier);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteSupplierGroupImplCopyWith<_$QuoteSupplierGroupImpl> get copyWith =>
      __$$QuoteSupplierGroupImplCopyWithImpl<_$QuoteSupplierGroupImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteSupplierGroupImplToJson(
      this,
    );
  }
}

abstract class _QuoteSupplierGroup implements QuoteSupplierGroup {
  const factory _QuoteSupplierGroup(
          {final int? count,
          final int? qty,
          @JsonKey(name: 'supplier') final QuoteSupplier? supplier}) =
      _$QuoteSupplierGroupImpl;

  factory _QuoteSupplierGroup.fromJson(Map<String, dynamic> json) =
      _$QuoteSupplierGroupImpl.fromJson;

  @override
  int? get count;
  @override
  int? get qty;
  @override

  /// ⚠️ 注意：这里不是 Supplier，而是 QuoteSupplier
  @JsonKey(name: 'supplier')
  QuoteSupplier? get supplier;
  @override
  @JsonKey(ignore: true)
  _$$QuoteSupplierGroupImplCopyWith<_$QuoteSupplierGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuoteSupplier _$QuoteSupplierFromJson(Map<String, dynamic> json) {
  return _QuoteSupplier.fromJson(json);
}

/// @nodoc
mixin _$QuoteSupplier {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get annual => throw _privateConstructorUsedError;
  List<dynamic>? get advantages => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_no')
  String? get supplierNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'usci_code')
  String? get usciCode => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account')
  String? get bankAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_title')
  String? get businessTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'bill_type')
  String? get billType => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_id')
  int? get typeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_corporate')
  String? get isCorporate => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_type')
  String? get supplierType => throw _privateConstructorUsedError;
  @JsonKey(name: 'corp_customer')
  String? get corpCustomer => throw _privateConstructorUsedError;
  @JsonKey(name: 'corp_company')
  String? get corpCompany => throw _privateConstructorUsedError;
  @JsonKey(name: 'showroom_area')
  String? get showroomArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'corp_skuid')
  String? get corpSkuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'market_rate')
  String? get marketRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'land_type')
  String? get landType => throw _privateConstructorUsedError;
  @JsonKey(name: 'factory_area')
  String? get factoryArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_count')
  String? get employeeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'developed_at')
  String? get developedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_photos')
  List<Media>? get sitePhotos => throw _privateConstructorUsedError;
  @JsonKey(name: 'showroom_photos')
  List<Media>? get showroomPhotos => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_photos')
  List<Media>? get devicePhotos => throw _privateConstructorUsedError;
  List<Contact>? get contacts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuoteSupplierCopyWith<QuoteSupplier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteSupplierCopyWith<$Res> {
  factory $QuoteSupplierCopyWith(
          QuoteSupplier value, $Res Function(QuoteSupplier) then) =
      _$QuoteSupplierCopyWithImpl<$Res, QuoteSupplier>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? city,
      String? province,
      String? address,
      String? annual,
      List<dynamic>? advantages,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'usci_code') String? usciCode,
      @JsonKey(name: 'is_core') bool? isCore,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'business_scope') String? businessScope,
      @JsonKey(name: 'export_market') String? exportMarket,
      @JsonKey(name: 'shipping_amount') String? shippingAmount,
      @JsonKey(name: 'short_name') String? shortName,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'business_title') String? businessTitle,
      @JsonKey(name: 'bill_type') String? billType,
      @JsonKey(name: 'type_id') int? typeId,
      @JsonKey(name: 'is_corporate') String? isCorporate,
      @JsonKey(name: 'supplier_type') String? supplierType,
      @JsonKey(name: 'corp_customer') String? corpCustomer,
      @JsonKey(name: 'corp_company') String? corpCompany,
      @JsonKey(name: 'showroom_area') String? showroomArea,
      @JsonKey(name: 'corp_skuid') String? corpSkuid,
      @JsonKey(name: 'market_rate') String? marketRate,
      @JsonKey(name: 'land_type') String? landType,
      @JsonKey(name: 'factory_area') String? factoryArea,
      @JsonKey(name: 'employee_count') String? employeeCount,
      @JsonKey(name: 'developed_at') String? developedAt,
      @JsonKey(name: 'site_photos') List<Media>? sitePhotos,
      @JsonKey(name: 'showroom_photos') List<Media>? showroomPhotos,
      @JsonKey(name: 'device_photos') List<Media>? devicePhotos,
      List<Contact>? contacts});
}

/// @nodoc
class _$QuoteSupplierCopyWithImpl<$Res, $Val extends QuoteSupplier>
    implements $QuoteSupplierCopyWith<$Res> {
  _$QuoteSupplierCopyWithImpl(this._value, this._then);

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
    Object? address = freezed,
    Object? annual = freezed,
    Object? advantages = freezed,
    Object? supplierNo = freezed,
    Object? usciCode = freezed,
    Object? isCore = freezed,
    Object? canBill = freezed,
    Object? businessScope = freezed,
    Object? exportMarket = freezed,
    Object? shippingAmount = freezed,
    Object? shortName = freezed,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? businessTitle = freezed,
    Object? billType = freezed,
    Object? typeId = freezed,
    Object? isCorporate = freezed,
    Object? supplierType = freezed,
    Object? corpCustomer = freezed,
    Object? corpCompany = freezed,
    Object? showroomArea = freezed,
    Object? corpSkuid = freezed,
    Object? marketRate = freezed,
    Object? landType = freezed,
    Object? factoryArea = freezed,
    Object? employeeCount = freezed,
    Object? developedAt = freezed,
    Object? sitePhotos = freezed,
    Object? showroomPhotos = freezed,
    Object? devicePhotos = freezed,
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      annual: freezed == annual
          ? _value.annual
          : annual // ignore: cast_nullable_to_non_nullable
              as String?,
      advantages: freezed == advantages
          ? _value.advantages
          : advantages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      usciCode: freezed == usciCode
          ? _value.usciCode
          : usciCode // ignore: cast_nullable_to_non_nullable
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
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      businessTitle: freezed == businessTitle
          ? _value.businessTitle
          : businessTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      billType: freezed == billType
          ? _value.billType
          : billType // ignore: cast_nullable_to_non_nullable
              as String?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCorporate: freezed == isCorporate
          ? _value.isCorporate
          : isCorporate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierType: freezed == supplierType
          ? _value.supplierType
          : supplierType // ignore: cast_nullable_to_non_nullable
              as String?,
      corpCustomer: freezed == corpCustomer
          ? _value.corpCustomer
          : corpCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      corpCompany: freezed == corpCompany
          ? _value.corpCompany
          : corpCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      showroomArea: freezed == showroomArea
          ? _value.showroomArea
          : showroomArea // ignore: cast_nullable_to_non_nullable
              as String?,
      corpSkuid: freezed == corpSkuid
          ? _value.corpSkuid
          : corpSkuid // ignore: cast_nullable_to_non_nullable
              as String?,
      marketRate: freezed == marketRate
          ? _value.marketRate
          : marketRate // ignore: cast_nullable_to_non_nullable
              as String?,
      landType: freezed == landType
          ? _value.landType
          : landType // ignore: cast_nullable_to_non_nullable
              as String?,
      factoryArea: freezed == factoryArea
          ? _value.factoryArea
          : factoryArea // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      developedAt: freezed == developedAt
          ? _value.developedAt
          : developedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      sitePhotos: freezed == sitePhotos
          ? _value.sitePhotos
          : sitePhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      showroomPhotos: freezed == showroomPhotos
          ? _value.showroomPhotos
          : showroomPhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      devicePhotos: freezed == devicePhotos
          ? _value.devicePhotos
          : devicePhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      contacts: freezed == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteSupplierImplCopyWith<$Res>
    implements $QuoteSupplierCopyWith<$Res> {
  factory _$$QuoteSupplierImplCopyWith(
          _$QuoteSupplierImpl value, $Res Function(_$QuoteSupplierImpl) then) =
      __$$QuoteSupplierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? city,
      String? province,
      String? address,
      String? annual,
      List<dynamic>? advantages,
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'usci_code') String? usciCode,
      @JsonKey(name: 'is_core') bool? isCore,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'business_scope') String? businessScope,
      @JsonKey(name: 'export_market') String? exportMarket,
      @JsonKey(name: 'shipping_amount') String? shippingAmount,
      @JsonKey(name: 'short_name') String? shortName,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'business_title') String? businessTitle,
      @JsonKey(name: 'bill_type') String? billType,
      @JsonKey(name: 'type_id') int? typeId,
      @JsonKey(name: 'is_corporate') String? isCorporate,
      @JsonKey(name: 'supplier_type') String? supplierType,
      @JsonKey(name: 'corp_customer') String? corpCustomer,
      @JsonKey(name: 'corp_company') String? corpCompany,
      @JsonKey(name: 'showroom_area') String? showroomArea,
      @JsonKey(name: 'corp_skuid') String? corpSkuid,
      @JsonKey(name: 'market_rate') String? marketRate,
      @JsonKey(name: 'land_type') String? landType,
      @JsonKey(name: 'factory_area') String? factoryArea,
      @JsonKey(name: 'employee_count') String? employeeCount,
      @JsonKey(name: 'developed_at') String? developedAt,
      @JsonKey(name: 'site_photos') List<Media>? sitePhotos,
      @JsonKey(name: 'showroom_photos') List<Media>? showroomPhotos,
      @JsonKey(name: 'device_photos') List<Media>? devicePhotos,
      List<Contact>? contacts});
}

/// @nodoc
class __$$QuoteSupplierImplCopyWithImpl<$Res>
    extends _$QuoteSupplierCopyWithImpl<$Res, _$QuoteSupplierImpl>
    implements _$$QuoteSupplierImplCopyWith<$Res> {
  __$$QuoteSupplierImplCopyWithImpl(
      _$QuoteSupplierImpl _value, $Res Function(_$QuoteSupplierImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? city = freezed,
    Object? province = freezed,
    Object? address = freezed,
    Object? annual = freezed,
    Object? advantages = freezed,
    Object? supplierNo = freezed,
    Object? usciCode = freezed,
    Object? isCore = freezed,
    Object? canBill = freezed,
    Object? businessScope = freezed,
    Object? exportMarket = freezed,
    Object? shippingAmount = freezed,
    Object? shortName = freezed,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? businessTitle = freezed,
    Object? billType = freezed,
    Object? typeId = freezed,
    Object? isCorporate = freezed,
    Object? supplierType = freezed,
    Object? corpCustomer = freezed,
    Object? corpCompany = freezed,
    Object? showroomArea = freezed,
    Object? corpSkuid = freezed,
    Object? marketRate = freezed,
    Object? landType = freezed,
    Object? factoryArea = freezed,
    Object? employeeCount = freezed,
    Object? developedAt = freezed,
    Object? sitePhotos = freezed,
    Object? showroomPhotos = freezed,
    Object? devicePhotos = freezed,
    Object? contacts = freezed,
  }) {
    return _then(_$QuoteSupplierImpl(
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      annual: freezed == annual
          ? _value.annual
          : annual // ignore: cast_nullable_to_non_nullable
              as String?,
      advantages: freezed == advantages
          ? _value._advantages
          : advantages // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      usciCode: freezed == usciCode
          ? _value.usciCode
          : usciCode // ignore: cast_nullable_to_non_nullable
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
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      businessTitle: freezed == businessTitle
          ? _value.businessTitle
          : businessTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      billType: freezed == billType
          ? _value.billType
          : billType // ignore: cast_nullable_to_non_nullable
              as String?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCorporate: freezed == isCorporate
          ? _value.isCorporate
          : isCorporate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierType: freezed == supplierType
          ? _value.supplierType
          : supplierType // ignore: cast_nullable_to_non_nullable
              as String?,
      corpCustomer: freezed == corpCustomer
          ? _value.corpCustomer
          : corpCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      corpCompany: freezed == corpCompany
          ? _value.corpCompany
          : corpCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      showroomArea: freezed == showroomArea
          ? _value.showroomArea
          : showroomArea // ignore: cast_nullable_to_non_nullable
              as String?,
      corpSkuid: freezed == corpSkuid
          ? _value.corpSkuid
          : corpSkuid // ignore: cast_nullable_to_non_nullable
              as String?,
      marketRate: freezed == marketRate
          ? _value.marketRate
          : marketRate // ignore: cast_nullable_to_non_nullable
              as String?,
      landType: freezed == landType
          ? _value.landType
          : landType // ignore: cast_nullable_to_non_nullable
              as String?,
      factoryArea: freezed == factoryArea
          ? _value.factoryArea
          : factoryArea // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      developedAt: freezed == developedAt
          ? _value.developedAt
          : developedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      sitePhotos: freezed == sitePhotos
          ? _value._sitePhotos
          : sitePhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      showroomPhotos: freezed == showroomPhotos
          ? _value._showroomPhotos
          : showroomPhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      devicePhotos: freezed == devicePhotos
          ? _value._devicePhotos
          : devicePhotos // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      contacts: freezed == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteSupplierImpl implements _QuoteSupplier {
  const _$QuoteSupplierImpl(
      {this.id,
      this.name,
      this.city,
      this.province,
      this.address,
      this.annual,
      final List<dynamic>? advantages,
      @JsonKey(name: 'supplier_no') this.supplierNo,
      @JsonKey(name: 'usci_code') this.usciCode,
      @JsonKey(name: 'is_core') this.isCore,
      @JsonKey(name: 'can_bill') this.canBill,
      @JsonKey(name: 'business_scope') this.businessScope,
      @JsonKey(name: 'export_market') this.exportMarket,
      @JsonKey(name: 'shipping_amount') this.shippingAmount,
      @JsonKey(name: 'short_name') this.shortName,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'bank_account') this.bankAccount,
      @JsonKey(name: 'business_title') this.businessTitle,
      @JsonKey(name: 'bill_type') this.billType,
      @JsonKey(name: 'type_id') this.typeId,
      @JsonKey(name: 'is_corporate') this.isCorporate,
      @JsonKey(name: 'supplier_type') this.supplierType,
      @JsonKey(name: 'corp_customer') this.corpCustomer,
      @JsonKey(name: 'corp_company') this.corpCompany,
      @JsonKey(name: 'showroom_area') this.showroomArea,
      @JsonKey(name: 'corp_skuid') this.corpSkuid,
      @JsonKey(name: 'market_rate') this.marketRate,
      @JsonKey(name: 'land_type') this.landType,
      @JsonKey(name: 'factory_area') this.factoryArea,
      @JsonKey(name: 'employee_count') this.employeeCount,
      @JsonKey(name: 'developed_at') this.developedAt,
      @JsonKey(name: 'site_photos') final List<Media>? sitePhotos,
      @JsonKey(name: 'showroom_photos') final List<Media>? showroomPhotos,
      @JsonKey(name: 'device_photos') final List<Media>? devicePhotos,
      final List<Contact>? contacts})
      : _advantages = advantages,
        _sitePhotos = sitePhotos,
        _showroomPhotos = showroomPhotos,
        _devicePhotos = devicePhotos,
        _contacts = contacts;

  factory _$QuoteSupplierImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteSupplierImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? city;
  @override
  final String? province;
  @override
  final String? address;
  @override
  final String? annual;
  final List<dynamic>? _advantages;
  @override
  List<dynamic>? get advantages {
    final value = _advantages;
    if (value == null) return null;
    if (_advantages is EqualUnmodifiableListView) return _advantages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'supplier_no')
  final String? supplierNo;
  @override
  @JsonKey(name: 'usci_code')
  final String? usciCode;
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
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'bank_account')
  final String? bankAccount;
  @override
  @JsonKey(name: 'business_title')
  final String? businessTitle;
  @override
  @JsonKey(name: 'bill_type')
  final String? billType;
  @override
  @JsonKey(name: 'type_id')
  final int? typeId;
  @override
  @JsonKey(name: 'is_corporate')
  final String? isCorporate;
  @override
  @JsonKey(name: 'supplier_type')
  final String? supplierType;
  @override
  @JsonKey(name: 'corp_customer')
  final String? corpCustomer;
  @override
  @JsonKey(name: 'corp_company')
  final String? corpCompany;
  @override
  @JsonKey(name: 'showroom_area')
  final String? showroomArea;
  @override
  @JsonKey(name: 'corp_skuid')
  final String? corpSkuid;
  @override
  @JsonKey(name: 'market_rate')
  final String? marketRate;
  @override
  @JsonKey(name: 'land_type')
  final String? landType;
  @override
  @JsonKey(name: 'factory_area')
  final String? factoryArea;
  @override
  @JsonKey(name: 'employee_count')
  final String? employeeCount;
  @override
  @JsonKey(name: 'developed_at')
  final String? developedAt;
  final List<Media>? _sitePhotos;
  @override
  @JsonKey(name: 'site_photos')
  List<Media>? get sitePhotos {
    final value = _sitePhotos;
    if (value == null) return null;
    if (_sitePhotos is EqualUnmodifiableListView) return _sitePhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Media>? _showroomPhotos;
  @override
  @JsonKey(name: 'showroom_photos')
  List<Media>? get showroomPhotos {
    final value = _showroomPhotos;
    if (value == null) return null;
    if (_showroomPhotos is EqualUnmodifiableListView) return _showroomPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Media>? _devicePhotos;
  @override
  @JsonKey(name: 'device_photos')
  List<Media>? get devicePhotos {
    final value = _devicePhotos;
    if (value == null) return null;
    if (_devicePhotos is EqualUnmodifiableListView) return _devicePhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'QuoteSupplier(id: $id, name: $name, city: $city, province: $province, address: $address, annual: $annual, advantages: $advantages, supplierNo: $supplierNo, usciCode: $usciCode, isCore: $isCore, canBill: $canBill, businessScope: $businessScope, exportMarket: $exportMarket, shippingAmount: $shippingAmount, shortName: $shortName, bankName: $bankName, bankAccount: $bankAccount, businessTitle: $businessTitle, billType: $billType, typeId: $typeId, isCorporate: $isCorporate, supplierType: $supplierType, corpCustomer: $corpCustomer, corpCompany: $corpCompany, showroomArea: $showroomArea, corpSkuid: $corpSkuid, marketRate: $marketRate, landType: $landType, factoryArea: $factoryArea, employeeCount: $employeeCount, developedAt: $developedAt, sitePhotos: $sitePhotos, showroomPhotos: $showroomPhotos, devicePhotos: $devicePhotos, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteSupplierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.annual, annual) || other.annual == annual) &&
            const DeepCollectionEquality()
                .equals(other._advantages, _advantages) &&
            (identical(other.supplierNo, supplierNo) ||
                other.supplierNo == supplierNo) &&
            (identical(other.usciCode, usciCode) ||
                other.usciCode == usciCode) &&
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
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.businessTitle, businessTitle) ||
                other.businessTitle == businessTitle) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.isCorporate, isCorporate) ||
                other.isCorporate == isCorporate) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            (identical(other.corpCustomer, corpCustomer) ||
                other.corpCustomer == corpCustomer) &&
            (identical(other.corpCompany, corpCompany) ||
                other.corpCompany == corpCompany) &&
            (identical(other.showroomArea, showroomArea) ||
                other.showroomArea == showroomArea) &&
            (identical(other.corpSkuid, corpSkuid) ||
                other.corpSkuid == corpSkuid) &&
            (identical(other.marketRate, marketRate) ||
                other.marketRate == marketRate) &&
            (identical(other.landType, landType) ||
                other.landType == landType) &&
            (identical(other.factoryArea, factoryArea) ||
                other.factoryArea == factoryArea) &&
            (identical(other.employeeCount, employeeCount) ||
                other.employeeCount == employeeCount) &&
            (identical(other.developedAt, developedAt) ||
                other.developedAt == developedAt) &&
            const DeepCollectionEquality()
                .equals(other._sitePhotos, _sitePhotos) &&
            const DeepCollectionEquality()
                .equals(other._showroomPhotos, _showroomPhotos) &&
            const DeepCollectionEquality()
                .equals(other._devicePhotos, _devicePhotos) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        city,
        province,
        address,
        annual,
        const DeepCollectionEquality().hash(_advantages),
        supplierNo,
        usciCode,
        isCore,
        canBill,
        businessScope,
        exportMarket,
        shippingAmount,
        shortName,
        bankName,
        bankAccount,
        businessTitle,
        billType,
        typeId,
        isCorporate,
        supplierType,
        corpCustomer,
        corpCompany,
        showroomArea,
        corpSkuid,
        marketRate,
        landType,
        factoryArea,
        employeeCount,
        developedAt,
        const DeepCollectionEquality().hash(_sitePhotos),
        const DeepCollectionEquality().hash(_showroomPhotos),
        const DeepCollectionEquality().hash(_devicePhotos),
        const DeepCollectionEquality().hash(_contacts)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteSupplierImplCopyWith<_$QuoteSupplierImpl> get copyWith =>
      __$$QuoteSupplierImplCopyWithImpl<_$QuoteSupplierImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteSupplierImplToJson(
      this,
    );
  }
}

abstract class _QuoteSupplier implements QuoteSupplier {
  const factory _QuoteSupplier(
      {final int? id,
      final String? name,
      final String? city,
      final String? province,
      final String? address,
      final String? annual,
      final List<dynamic>? advantages,
      @JsonKey(name: 'supplier_no') final String? supplierNo,
      @JsonKey(name: 'usci_code') final String? usciCode,
      @JsonKey(name: 'is_core') final bool? isCore,
      @JsonKey(name: 'can_bill') final bool? canBill,
      @JsonKey(name: 'business_scope') final String? businessScope,
      @JsonKey(name: 'export_market') final String? exportMarket,
      @JsonKey(name: 'shipping_amount') final String? shippingAmount,
      @JsonKey(name: 'short_name') final String? shortName,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'bank_account') final String? bankAccount,
      @JsonKey(name: 'business_title') final String? businessTitle,
      @JsonKey(name: 'bill_type') final String? billType,
      @JsonKey(name: 'type_id') final int? typeId,
      @JsonKey(name: 'is_corporate') final String? isCorporate,
      @JsonKey(name: 'supplier_type') final String? supplierType,
      @JsonKey(name: 'corp_customer') final String? corpCustomer,
      @JsonKey(name: 'corp_company') final String? corpCompany,
      @JsonKey(name: 'showroom_area') final String? showroomArea,
      @JsonKey(name: 'corp_skuid') final String? corpSkuid,
      @JsonKey(name: 'market_rate') final String? marketRate,
      @JsonKey(name: 'land_type') final String? landType,
      @JsonKey(name: 'factory_area') final String? factoryArea,
      @JsonKey(name: 'employee_count') final String? employeeCount,
      @JsonKey(name: 'developed_at') final String? developedAt,
      @JsonKey(name: 'site_photos') final List<Media>? sitePhotos,
      @JsonKey(name: 'showroom_photos') final List<Media>? showroomPhotos,
      @JsonKey(name: 'device_photos') final List<Media>? devicePhotos,
      final List<Contact>? contacts}) = _$QuoteSupplierImpl;

  factory _QuoteSupplier.fromJson(Map<String, dynamic> json) =
      _$QuoteSupplierImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get city;
  @override
  String? get province;
  @override
  String? get address;
  @override
  String? get annual;
  @override
  List<dynamic>? get advantages;
  @override
  @JsonKey(name: 'supplier_no')
  String? get supplierNo;
  @override
  @JsonKey(name: 'usci_code')
  String? get usciCode;
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
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'bank_account')
  String? get bankAccount;
  @override
  @JsonKey(name: 'business_title')
  String? get businessTitle;
  @override
  @JsonKey(name: 'bill_type')
  String? get billType;
  @override
  @JsonKey(name: 'type_id')
  int? get typeId;
  @override
  @JsonKey(name: 'is_corporate')
  String? get isCorporate;
  @override
  @JsonKey(name: 'supplier_type')
  String? get supplierType;
  @override
  @JsonKey(name: 'corp_customer')
  String? get corpCustomer;
  @override
  @JsonKey(name: 'corp_company')
  String? get corpCompany;
  @override
  @JsonKey(name: 'showroom_area')
  String? get showroomArea;
  @override
  @JsonKey(name: 'corp_skuid')
  String? get corpSkuid;
  @override
  @JsonKey(name: 'market_rate')
  String? get marketRate;
  @override
  @JsonKey(name: 'land_type')
  String? get landType;
  @override
  @JsonKey(name: 'factory_area')
  String? get factoryArea;
  @override
  @JsonKey(name: 'employee_count')
  String? get employeeCount;
  @override
  @JsonKey(name: 'developed_at')
  String? get developedAt;
  @override
  @JsonKey(name: 'site_photos')
  List<Media>? get sitePhotos;
  @override
  @JsonKey(name: 'showroom_photos')
  List<Media>? get showroomPhotos;
  @override
  @JsonKey(name: 'device_photos')
  List<Media>? get devicePhotos;
  @override
  List<Contact>? get contacts;
  @override
  @JsonKey(ignore: true)
  _$$QuoteSupplierImplCopyWith<_$QuoteSupplierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
