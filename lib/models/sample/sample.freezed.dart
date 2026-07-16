// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Sample _$SampleFromJson(Map<String, dynamic> json) {
  return _Sample.fromJson(json);
}

/// @nodoc
mixin _$Sample {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
  String? get xTenantId => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get packing => throw _privateConstructorUsedError;
  String? get construction => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get series => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_cn')
  String? get nameCn => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String? get nameEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_no')
  String? get productNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  String? get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_no')
  String? get pageNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'trade_country')
  String? get tradeCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'developed_at')
  String? get developedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_cn')
  String? get descriptionCn => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_en')
  String? get descriptionEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_type')
  String? get itemType => throw _privateConstructorUsedError;
  List<Quote>? get supplyQuotes => throw _privateConstructorUsedError;
  String? get spec => throw _privateConstructorUsedError;
  SampleCategory? get category => throw _privateConstructorUsedError;
  List<Media>? get image => throw _privateConstructorUsedError;
  List<Media>? get audios => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SampleCopyWith<Sample> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SampleCopyWith<$Res> {
  factory $SampleCopyWith(Sample value, $Res Function(Sample) then) =
      _$SampleCopyWithImpl<$Res, Sample>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
      String? xTenantId,
      String? barcode,
      String? packing,
      String? construction,
      String? remark,
      String? series,
      String? unit,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(name: 'name_cn') String? nameCn,
      @JsonKey(name: 'name_en') String? nameEn,
      @JsonKey(name: 'product_no') String? productNo,
      @JsonKey(name: 'tax_rate') String? taxRate,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'trade_country') String? tradeCountry,
      @JsonKey(name: 'developed_at') String? developedAt,
      @JsonKey(name: 'description_cn') String? descriptionCn,
      @JsonKey(name: 'description_en') String? descriptionEn,
      @JsonKey(name: 'item_type') String? itemType,
      List<Quote>? supplyQuotes,
      String? spec,
      SampleCategory? category,
      List<Media>? image,
      List<Media>? audios});

  $SampleCategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$SampleCopyWithImpl<$Res, $Val extends Sample>
    implements $SampleCopyWith<$Res> {
  _$SampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? xTenantId = freezed,
    Object? barcode = freezed,
    Object? packing = freezed,
    Object? construction = freezed,
    Object? remark = freezed,
    Object? series = freezed,
    Object? unit = freezed,
    Object? categoryId = freezed,
    Object? nameCn = freezed,
    Object? nameEn = freezed,
    Object? productNo = freezed,
    Object? taxRate = freezed,
    Object? purchaseCost = freezed,
    Object? pageNo = freezed,
    Object? tradeCountry = freezed,
    Object? developedAt = freezed,
    Object? descriptionCn = freezed,
    Object? descriptionEn = freezed,
    Object? itemType = freezed,
    Object? supplyQuotes = freezed,
    Object? spec = freezed,
    Object? category = freezed,
    Object? image = freezed,
    Object? audios = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      xTenantId: freezed == xTenantId
          ? _value.xTenantId
          : xTenantId // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      packing: freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      construction: freezed == construction
          ? _value.construction
          : construction // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      series: freezed == series
          ? _value.series
          : series // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      nameCn: freezed == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      productNo: freezed == productNo
          ? _value.productNo
          : productNo // ignore: cast_nullable_to_non_nullable
              as String?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCost: freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeCountry: freezed == tradeCountry
          ? _value.tradeCountry
          : tradeCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      developedAt: freezed == developedAt
          ? _value.developedAt
          : developedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionCn: freezed == descriptionCn
          ? _value.descriptionCn
          : descriptionCn // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionEn: freezed == descriptionEn
          ? _value.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: freezed == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      supplyQuotes: freezed == supplyQuotes
          ? _value.supplyQuotes
          : supplyQuotes // ignore: cast_nullable_to_non_nullable
              as List<Quote>?,
      spec: freezed == spec
          ? _value.spec
          : spec // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SampleCategory?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      audios: freezed == audios
          ? _value.audios
          : audios // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $SampleCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SampleImplCopyWith<$Res> implements $SampleCopyWith<$Res> {
  factory _$$SampleImplCopyWith(
          _$SampleImpl value, $Res Function(_$SampleImpl) then) =
      __$$SampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
      String? xTenantId,
      String? barcode,
      String? packing,
      String? construction,
      String? remark,
      String? series,
      String? unit,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(name: 'name_cn') String? nameCn,
      @JsonKey(name: 'name_en') String? nameEn,
      @JsonKey(name: 'product_no') String? productNo,
      @JsonKey(name: 'tax_rate') String? taxRate,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'page_no') String? pageNo,
      @JsonKey(name: 'trade_country') String? tradeCountry,
      @JsonKey(name: 'developed_at') String? developedAt,
      @JsonKey(name: 'description_cn') String? descriptionCn,
      @JsonKey(name: 'description_en') String? descriptionEn,
      @JsonKey(name: 'item_type') String? itemType,
      List<Quote>? supplyQuotes,
      String? spec,
      SampleCategory? category,
      List<Media>? image,
      List<Media>? audios});

  @override
  $SampleCategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$$SampleImplCopyWithImpl<$Res>
    extends _$SampleCopyWithImpl<$Res, _$SampleImpl>
    implements _$$SampleImplCopyWith<$Res> {
  __$$SampleImplCopyWithImpl(
      _$SampleImpl _value, $Res Function(_$SampleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? xTenantId = freezed,
    Object? barcode = freezed,
    Object? packing = freezed,
    Object? construction = freezed,
    Object? remark = freezed,
    Object? series = freezed,
    Object? unit = freezed,
    Object? categoryId = freezed,
    Object? nameCn = freezed,
    Object? nameEn = freezed,
    Object? productNo = freezed,
    Object? taxRate = freezed,
    Object? purchaseCost = freezed,
    Object? pageNo = freezed,
    Object? tradeCountry = freezed,
    Object? developedAt = freezed,
    Object? descriptionCn = freezed,
    Object? descriptionEn = freezed,
    Object? itemType = freezed,
    Object? supplyQuotes = freezed,
    Object? spec = freezed,
    Object? category = freezed,
    Object? image = freezed,
    Object? audios = freezed,
  }) {
    return _then(_$SampleImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      xTenantId: freezed == xTenantId
          ? _value.xTenantId
          : xTenantId // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      packing: freezed == packing
          ? _value.packing
          : packing // ignore: cast_nullable_to_non_nullable
              as String?,
      construction: freezed == construction
          ? _value.construction
          : construction // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      series: freezed == series
          ? _value.series
          : series // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      nameCn: freezed == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      productNo: freezed == productNo
          ? _value.productNo
          : productNo // ignore: cast_nullable_to_non_nullable
              as String?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCost: freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeCountry: freezed == tradeCountry
          ? _value.tradeCountry
          : tradeCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      developedAt: freezed == developedAt
          ? _value.developedAt
          : developedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionCn: freezed == descriptionCn
          ? _value.descriptionCn
          : descriptionCn // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionEn: freezed == descriptionEn
          ? _value.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: freezed == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      supplyQuotes: freezed == supplyQuotes
          ? _value._supplyQuotes
          : supplyQuotes // ignore: cast_nullable_to_non_nullable
              as List<Quote>?,
      spec: freezed == spec
          ? _value.spec
          : spec // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SampleCategory?,
      image: freezed == image
          ? _value._image
          : image // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      audios: freezed == audios
          ? _value._audios
          : audios // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SampleImpl extends _Sample with DiagnosticableTreeMixin {
  const _$SampleImpl(
      {this.id,
      @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
      this.xTenantId,
      this.barcode,
      this.packing,
      this.construction,
      this.remark,
      this.series,
      this.unit,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'name_cn') this.nameCn,
      @JsonKey(name: 'name_en') this.nameEn,
      @JsonKey(name: 'product_no') this.productNo,
      @JsonKey(name: 'tax_rate') this.taxRate,
      @JsonKey(name: 'purchase_cost') this.purchaseCost,
      @JsonKey(name: 'page_no') this.pageNo,
      @JsonKey(name: 'trade_country') this.tradeCountry,
      @JsonKey(name: 'developed_at') this.developedAt,
      @JsonKey(name: 'description_cn') this.descriptionCn,
      @JsonKey(name: 'description_en') this.descriptionEn,
      @JsonKey(name: 'item_type') this.itemType,
      final List<Quote>? supplyQuotes,
      this.spec,
      this.category,
      final List<Media>? image,
      final List<Media>? audios})
      : _supplyQuotes = supplyQuotes,
        _image = image,
        _audios = audios,
        super._();

  factory _$SampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SampleImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
  final String? xTenantId;
  @override
  final String? barcode;
  @override
  final String? packing;
  @override
  final String? construction;
  @override
  final String? remark;
  @override
  final String? series;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @override
  @JsonKey(name: 'name_cn')
  final String? nameCn;
  @override
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @override
  @JsonKey(name: 'product_no')
  final String? productNo;
  @override
  @JsonKey(name: 'tax_rate')
  final String? taxRate;
  @override
  @JsonKey(name: 'purchase_cost')
  final String? purchaseCost;
  @override
  @JsonKey(name: 'page_no')
  final String? pageNo;
  @override
  @JsonKey(name: 'trade_country')
  final String? tradeCountry;
  @override
  @JsonKey(name: 'developed_at')
  final String? developedAt;
  @override
  @JsonKey(name: 'description_cn')
  final String? descriptionCn;
  @override
  @JsonKey(name: 'description_en')
  final String? descriptionEn;
  @override
  @JsonKey(name: 'item_type')
  final String? itemType;
  final List<Quote>? _supplyQuotes;
  @override
  List<Quote>? get supplyQuotes {
    final value = _supplyQuotes;
    if (value == null) return null;
    if (_supplyQuotes is EqualUnmodifiableListView) return _supplyQuotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? spec;
  @override
  final SampleCategory? category;
  final List<Media>? _image;
  @override
  List<Media>? get image {
    final value = _image;
    if (value == null) return null;
    if (_image is EqualUnmodifiableListView) return _image;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Media>? _audios;
  @override
  List<Media>? get audios {
    final value = _audios;
    if (value == null) return null;
    if (_audios is EqualUnmodifiableListView) return _audios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Sample(id: $id, xTenantId: $xTenantId, barcode: $barcode, packing: $packing, construction: $construction, remark: $remark, series: $series, unit: $unit, categoryId: $categoryId, nameCn: $nameCn, nameEn: $nameEn, productNo: $productNo, taxRate: $taxRate, purchaseCost: $purchaseCost, pageNo: $pageNo, tradeCountry: $tradeCountry, developedAt: $developedAt, descriptionCn: $descriptionCn, descriptionEn: $descriptionEn, itemType: $itemType, supplyQuotes: $supplyQuotes, spec: $spec, category: $category, image: $image, audios: $audios)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Sample'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('xTenantId', xTenantId))
      ..add(DiagnosticsProperty('barcode', barcode))
      ..add(DiagnosticsProperty('packing', packing))
      ..add(DiagnosticsProperty('construction', construction))
      ..add(DiagnosticsProperty('remark', remark))
      ..add(DiagnosticsProperty('series', series))
      ..add(DiagnosticsProperty('unit', unit))
      ..add(DiagnosticsProperty('categoryId', categoryId))
      ..add(DiagnosticsProperty('nameCn', nameCn))
      ..add(DiagnosticsProperty('nameEn', nameEn))
      ..add(DiagnosticsProperty('productNo', productNo))
      ..add(DiagnosticsProperty('taxRate', taxRate))
      ..add(DiagnosticsProperty('purchaseCost', purchaseCost))
      ..add(DiagnosticsProperty('pageNo', pageNo))
      ..add(DiagnosticsProperty('tradeCountry', tradeCountry))
      ..add(DiagnosticsProperty('developedAt', developedAt))
      ..add(DiagnosticsProperty('descriptionCn', descriptionCn))
      ..add(DiagnosticsProperty('descriptionEn', descriptionEn))
      ..add(DiagnosticsProperty('itemType', itemType))
      ..add(DiagnosticsProperty('supplyQuotes', supplyQuotes))
      ..add(DiagnosticsProperty('spec', spec))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('audios', audios));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SampleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.xTenantId, xTenantId) ||
                other.xTenantId == xTenantId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.packing, packing) || other.packing == packing) &&
            (identical(other.construction, construction) ||
                other.construction == construction) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.nameCn, nameCn) || other.nameCn == nameCn) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.productNo, productNo) ||
                other.productNo == productNo) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.purchaseCost, purchaseCost) ||
                other.purchaseCost == purchaseCost) &&
            (identical(other.pageNo, pageNo) || other.pageNo == pageNo) &&
            (identical(other.tradeCountry, tradeCountry) ||
                other.tradeCountry == tradeCountry) &&
            (identical(other.developedAt, developedAt) ||
                other.developedAt == developedAt) &&
            (identical(other.descriptionCn, descriptionCn) ||
                other.descriptionCn == descriptionCn) &&
            (identical(other.descriptionEn, descriptionEn) ||
                other.descriptionEn == descriptionEn) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            const DeepCollectionEquality()
                .equals(other._supplyQuotes, _supplyQuotes) &&
            (identical(other.spec, spec) || other.spec == spec) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._image, _image) &&
            const DeepCollectionEquality().equals(other._audios, _audios));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        xTenantId,
        barcode,
        packing,
        construction,
        remark,
        series,
        unit,
        categoryId,
        nameCn,
        nameEn,
        productNo,
        taxRate,
        purchaseCost,
        pageNo,
        tradeCountry,
        developedAt,
        descriptionCn,
        descriptionEn,
        itemType,
        const DeepCollectionEquality().hash(_supplyQuotes),
        spec,
        category,
        const DeepCollectionEquality().hash(_image),
        const DeepCollectionEquality().hash(_audios)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SampleImplCopyWith<_$SampleImpl> get copyWith =>
      __$$SampleImplCopyWithImpl<_$SampleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SampleImplToJson(
      this,
    );
  }
}

abstract class _Sample extends Sample {
  const factory _Sample(
      {final int? id,
      @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
      final String? xTenantId,
      final String? barcode,
      final String? packing,
      final String? construction,
      final String? remark,
      final String? series,
      final String? unit,
      @JsonKey(name: 'category_id') final int? categoryId,
      @JsonKey(name: 'name_cn') final String? nameCn,
      @JsonKey(name: 'name_en') final String? nameEn,
      @JsonKey(name: 'product_no') final String? productNo,
      @JsonKey(name: 'tax_rate') final String? taxRate,
      @JsonKey(name: 'purchase_cost') final String? purchaseCost,
      @JsonKey(name: 'page_no') final String? pageNo,
      @JsonKey(name: 'trade_country') final String? tradeCountry,
      @JsonKey(name: 'developed_at') final String? developedAt,
      @JsonKey(name: 'description_cn') final String? descriptionCn,
      @JsonKey(name: 'description_en') final String? descriptionEn,
      @JsonKey(name: 'item_type') final String? itemType,
      final List<Quote>? supplyQuotes,
      final String? spec,
      final SampleCategory? category,
      final List<Media>? image,
      final List<Media>? audios}) = _$SampleImpl;
  const _Sample._() : super._();

  factory _Sample.fromJson(Map<String, dynamic> json) = _$SampleImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
  String? get xTenantId;
  @override
  String? get barcode;
  @override
  String? get packing;
  @override
  String? get construction;
  @override
  String? get remark;
  @override
  String? get series;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'category_id')
  int? get categoryId;
  @override
  @JsonKey(name: 'name_cn')
  String? get nameCn;
  @override
  @JsonKey(name: 'name_en')
  String? get nameEn;
  @override
  @JsonKey(name: 'product_no')
  String? get productNo;
  @override
  @JsonKey(name: 'tax_rate')
  String? get taxRate;
  @override
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost;
  @override
  @JsonKey(name: 'page_no')
  String? get pageNo;
  @override
  @JsonKey(name: 'trade_country')
  String? get tradeCountry;
  @override
  @JsonKey(name: 'developed_at')
  String? get developedAt;
  @override
  @JsonKey(name: 'description_cn')
  String? get descriptionCn;
  @override
  @JsonKey(name: 'description_en')
  String? get descriptionEn;
  @override
  @JsonKey(name: 'item_type')
  String? get itemType;
  @override
  List<Quote>? get supplyQuotes;
  @override
  String? get spec;
  @override
  SampleCategory? get category;
  @override
  List<Media>? get image;
  @override
  List<Media>? get audios;
  @override
  @JsonKey(ignore: true)
  _$$SampleImplCopyWith<_$SampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SampleCategory _$SampleCategoryFromJson(Map<String, dynamic> json) {
  return _SampleCategory.fromJson(json);
}

/// @nodoc
mixin _$SampleCategory {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SampleCategoryCopyWith<SampleCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SampleCategoryCopyWith<$Res> {
  factory $SampleCategoryCopyWith(
          SampleCategory value, $Res Function(SampleCategory) then) =
      _$SampleCategoryCopyWithImpl<$Res, SampleCategory>;
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class _$SampleCategoryCopyWithImpl<$Res, $Val extends SampleCategory>
    implements $SampleCategoryCopyWith<$Res> {
  _$SampleCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SampleCategoryImplCopyWith<$Res>
    implements $SampleCategoryCopyWith<$Res> {
  factory _$$SampleCategoryImplCopyWith(_$SampleCategoryImpl value,
          $Res Function(_$SampleCategoryImpl) then) =
      __$$SampleCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class __$$SampleCategoryImplCopyWithImpl<$Res>
    extends _$SampleCategoryCopyWithImpl<$Res, _$SampleCategoryImpl>
    implements _$$SampleCategoryImplCopyWith<$Res> {
  __$$SampleCategoryImplCopyWithImpl(
      _$SampleCategoryImpl _value, $Res Function(_$SampleCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_$SampleCategoryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SampleCategoryImpl
    with DiagnosticableTreeMixin
    implements _SampleCategory {
  const _$SampleCategoryImpl({this.id, this.name});

  factory _$SampleCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SampleCategoryImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SampleCategory(id: $id, name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SampleCategory'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SampleCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SampleCategoryImplCopyWith<_$SampleCategoryImpl> get copyWith =>
      __$$SampleCategoryImplCopyWithImpl<_$SampleCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SampleCategoryImplToJson(
      this,
    );
  }
}

abstract class _SampleCategory implements SampleCategory {
  const factory _SampleCategory({final int? id, final String? name}) =
      _$SampleCategoryImpl;

  factory _SampleCategory.fromJson(Map<String, dynamic> json) =
      _$SampleCategoryImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$SampleCategoryImplCopyWith<_$SampleCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
