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
  int? get moq => throw _privateConstructorUsedError;
  Supplier? get supplier => throw _privateConstructorUsedError;
  String? get packing => throw _privateConstructorUsedError;
  String? get material => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_capacity')
  String? get outerCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_volume')
  String? get outerVolume => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_gross_weight')
  String? get outerGrossWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'chuhuo_at')
  DateTime? get chuhuoAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_location')
  String? get sampleLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_user')
  String? get recordUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_bill')
  bool? get canBill => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  String? get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_product_no')
  String? get supplierProductNo => throw _privateConstructorUsedError;

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
      int? moq,
      Supplier? supplier,
      String? packing,
      String? material,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'outer_capacity') String? outerCapacity,
      @JsonKey(name: 'outer_volume') String? outerVolume,
      @JsonKey(name: 'outer_gross_weight') String? outerGrossWeight,
      @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
      @JsonKey(name: 'sample_location') String? sampleLocation,
      @JsonKey(name: 'record_user') String? recordUser,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'tax_rate') String? taxRate,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'supplier_product_no') String? supplierProductNo});

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
    Object? moq = freezed,
    Object? supplier = freezed,
    Object? packing = freezed,
    Object? material = freezed,
    Object? supplierId = freezed,
    Object? outerCapacity = freezed,
    Object? outerVolume = freezed,
    Object? outerGrossWeight = freezed,
    Object? chuhuoAt = freezed,
    Object? sampleLocation = freezed,
    Object? recordUser = freezed,
    Object? canBill = freezed,
    Object? taxRate = freezed,
    Object? purchaseCost = freezed,
    Object? currency = freezed,
    Object? supplierProductNo = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      moq: freezed == moq
          ? _value.moq
          : moq // ignore: cast_nullable_to_non_nullable
              as int?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      packing: freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      material: freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      outerCapacity: freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as String?,
      outerVolume: freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as String?,
      outerGrossWeight: freezed == outerGrossWeight
          ? _value.outerGrossWeight
          : outerGrossWeight // ignore: cast_nullable_to_non_nullable
              as String?,
      chuhuoAt: freezed == chuhuoAt
          ? _value.chuhuoAt
          : chuhuoAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sampleLocation: freezed == sampleLocation
          ? _value.sampleLocation
          : sampleLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      recordUser: freezed == recordUser
          ? _value.recordUser
          : recordUser // ignore: cast_nullable_to_non_nullable
              as String?,
      canBill: freezed == canBill
          ? _value.canBill
          : canBill // ignore: cast_nullable_to_non_nullable
              as bool?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCost: freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierProductNo: freezed == supplierProductNo
          ? _value.supplierProductNo
          : supplierProductNo // ignore: cast_nullable_to_non_nullable
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
      int? moq,
      Supplier? supplier,
      String? packing,
      String? material,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'outer_capacity') String? outerCapacity,
      @JsonKey(name: 'outer_volume') String? outerVolume,
      @JsonKey(name: 'outer_gross_weight') String? outerGrossWeight,
      @JsonKey(name: 'chuhuo_at') DateTime? chuhuoAt,
      @JsonKey(name: 'sample_location') String? sampleLocation,
      @JsonKey(name: 'record_user') String? recordUser,
      @JsonKey(name: 'can_bill') bool? canBill,
      @JsonKey(name: 'tax_rate') String? taxRate,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'supplier_product_no') String? supplierProductNo});

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
    Object? moq = freezed,
    Object? supplier = freezed,
    Object? packing = freezed,
    Object? material = freezed,
    Object? supplierId = freezed,
    Object? outerCapacity = freezed,
    Object? outerVolume = freezed,
    Object? outerGrossWeight = freezed,
    Object? chuhuoAt = freezed,
    Object? sampleLocation = freezed,
    Object? recordUser = freezed,
    Object? canBill = freezed,
    Object? taxRate = freezed,
    Object? purchaseCost = freezed,
    Object? currency = freezed,
    Object? supplierProductNo = freezed,
  }) {
    return _then(_$QuoteImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == moq
          ? _value.moq
          : moq // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == outerGrossWeight
          ? _value.outerGrossWeight
          : outerGrossWeight // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == chuhuoAt
          ? _value.chuhuoAt
          : chuhuoAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      freezed == sampleLocation
          ? _value.sampleLocation
          : sampleLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == recordUser
          ? _value.recordUser
          : recordUser // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == canBill
          ? _value.canBill
          : canBill // ignore: cast_nullable_to_non_nullable
              as bool?,
      freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == supplierProductNo
          ? _value.supplierProductNo
          : supplierProductNo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteImpl implements _Quote {
  _$QuoteImpl(
      this.id,
      this.moq,
      this.supplier,
      this.packing,
      this.material,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'outer_capacity') this.outerCapacity,
      @JsonKey(name: 'outer_volume') this.outerVolume,
      @JsonKey(name: 'outer_gross_weight') this.outerGrossWeight,
      @JsonKey(name: 'chuhuo_at') this.chuhuoAt,
      @JsonKey(name: 'sample_location') this.sampleLocation,
      @JsonKey(name: 'record_user') this.recordUser,
      @JsonKey(name: 'can_bill') this.canBill,
      @JsonKey(name: 'tax_rate') this.taxRate,
      @JsonKey(name: 'purchase_cost') this.purchaseCost,
      @JsonKey(name: 'currency') this.currency,
      @JsonKey(name: 'supplier_product_no') this.supplierProductNo);

  factory _$QuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteImplFromJson(json);

  @override
  final int? id;
  @override
  final int? moq;
  @override
  final Supplier? supplier;
  @override
  final String? packing;
  @override
  final String? material;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'outer_capacity')
  final String? outerCapacity;
  @override
  @JsonKey(name: 'outer_volume')
  final String? outerVolume;
  @override
  @JsonKey(name: 'outer_gross_weight')
  final String? outerGrossWeight;
  @override
  @JsonKey(name: 'chuhuo_at')
  final DateTime? chuhuoAt;
  @override
  @JsonKey(name: 'sample_location')
  final String? sampleLocation;
  @override
  @JsonKey(name: 'record_user')
  final String? recordUser;
  @override
  @JsonKey(name: 'can_bill')
  final bool? canBill;
  @override
  @JsonKey(name: 'tax_rate')
  final String? taxRate;
  @override
  @JsonKey(name: 'purchase_cost')
  final String? purchaseCost;
  @override
  @JsonKey(name: 'currency')
  final String? currency;
  @override
  @JsonKey(name: 'supplier_product_no')
  final String? supplierProductNo;

  @override
  String toString() {
    return 'Quote(id: $id, moq: $moq, supplier: $supplier, packing: $packing, material: $material, supplierId: $supplierId, outerCapacity: $outerCapacity, outerVolume: $outerVolume, outerGrossWeight: $outerGrossWeight, chuhuoAt: $chuhuoAt, sampleLocation: $sampleLocation, recordUser: $recordUser, canBill: $canBill, taxRate: $taxRate, purchaseCost: $purchaseCost, currency: $currency, supplierProductNo: $supplierProductNo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.moq, moq) || other.moq == moq) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.packing, packing) || other.packing == packing) &&
            (identical(other.material, material) ||
                other.material == material) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.outerCapacity, outerCapacity) ||
                other.outerCapacity == outerCapacity) &&
            (identical(other.outerVolume, outerVolume) ||
                other.outerVolume == outerVolume) &&
            (identical(other.outerGrossWeight, outerGrossWeight) ||
                other.outerGrossWeight == outerGrossWeight) &&
            (identical(other.chuhuoAt, chuhuoAt) ||
                other.chuhuoAt == chuhuoAt) &&
            (identical(other.sampleLocation, sampleLocation) ||
                other.sampleLocation == sampleLocation) &&
            (identical(other.recordUser, recordUser) ||
                other.recordUser == recordUser) &&
            (identical(other.canBill, canBill) || other.canBill == canBill) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.purchaseCost, purchaseCost) ||
                other.purchaseCost == purchaseCost) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.supplierProductNo, supplierProductNo) ||
                other.supplierProductNo == supplierProductNo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      moq,
      supplier,
      packing,
      material,
      supplierId,
      outerCapacity,
      outerVolume,
      outerGrossWeight,
      chuhuoAt,
      sampleLocation,
      recordUser,
      canBill,
      taxRate,
      purchaseCost,
      currency,
      supplierProductNo);

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
      final int? moq,
      final Supplier? supplier,
      final String? packing,
      final String? material,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'outer_capacity') final String? outerCapacity,
      @JsonKey(name: 'outer_volume') final String? outerVolume,
      @JsonKey(name: 'outer_gross_weight') final String? outerGrossWeight,
      @JsonKey(name: 'chuhuo_at') final DateTime? chuhuoAt,
      @JsonKey(name: 'sample_location') final String? sampleLocation,
      @JsonKey(name: 'record_user') final String? recordUser,
      @JsonKey(name: 'can_bill') final bool? canBill,
      @JsonKey(name: 'tax_rate') final String? taxRate,
      @JsonKey(name: 'purchase_cost') final String? purchaseCost,
      @JsonKey(name: 'currency') final String? currency,
      @JsonKey(name: 'supplier_product_no')
      final String? supplierProductNo) = _$QuoteImpl;

  factory _Quote.fromJson(Map<String, dynamic> json) = _$QuoteImpl.fromJson;

  @override
  int? get id;
  @override
  int? get moq;
  @override
  Supplier? get supplier;
  @override
  String? get packing;
  @override
  String? get material;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'outer_capacity')
  String? get outerCapacity;
  @override
  @JsonKey(name: 'outer_volume')
  String? get outerVolume;
  @override
  @JsonKey(name: 'outer_gross_weight')
  String? get outerGrossWeight;
  @override
  @JsonKey(name: 'chuhuo_at')
  DateTime? get chuhuoAt;
  @override
  @JsonKey(name: 'sample_location')
  String? get sampleLocation;
  @override
  @JsonKey(name: 'record_user')
  String? get recordUser;
  @override
  @JsonKey(name: 'can_bill')
  bool? get canBill;
  @override
  @JsonKey(name: 'tax_rate')
  String? get taxRate;
  @override
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost;
  @override
  @JsonKey(name: 'currency')
  String? get currency;
  @override
  @JsonKey(name: 'supplier_product_no')
  String? get supplierProductNo;
  @override
  @JsonKey(ignore: true)
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
