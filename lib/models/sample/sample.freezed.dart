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
  String? get barcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_cn')
  String? get nameCn => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_no')
  String? get productNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_no')
  String? get pageNo => throw _privateConstructorUsedError;
  String? get spec => throw _privateConstructorUsedError;
  List<Media>? get image => throw _privateConstructorUsedError;

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
      String? barcode,
      @JsonKey(name: 'name_cn') String? nameCn,
      @JsonKey(name: 'product_no') String? productNo,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'page_no') String? pageNo,
      String? spec,
      List<Media>? image});
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
    Object? barcode = freezed,
    Object? nameCn = freezed,
    Object? productNo = freezed,
    Object? purchaseCost = freezed,
    Object? pageNo = freezed,
    Object? spec = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      nameCn: freezed == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String?,
      productNo: freezed == productNo
          ? _value.productNo
          : productNo // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCost: freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      spec: freezed == spec
          ? _value.spec
          : spec // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
    ) as $Val);
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
      String? barcode,
      @JsonKey(name: 'name_cn') String? nameCn,
      @JsonKey(name: 'product_no') String? productNo,
      @JsonKey(name: 'purchase_cost') String? purchaseCost,
      @JsonKey(name: 'page_no') String? pageNo,
      String? spec,
      List<Media>? image});
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
    Object? barcode = freezed,
    Object? nameCn = freezed,
    Object? productNo = freezed,
    Object? purchaseCost = freezed,
    Object? pageNo = freezed,
    Object? spec = freezed,
    Object? image = freezed,
  }) {
    return _then(_$SampleImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      nameCn: freezed == nameCn
          ? _value.nameCn
          : nameCn // ignore: cast_nullable_to_non_nullable
              as String?,
      productNo: freezed == productNo
          ? _value.productNo
          : productNo // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCost: freezed == purchaseCost
          ? _value.purchaseCost
          : purchaseCost // ignore: cast_nullable_to_non_nullable
              as String?,
      pageNo: freezed == pageNo
          ? _value.pageNo
          : pageNo // ignore: cast_nullable_to_non_nullable
              as String?,
      spec: freezed == spec
          ? _value.spec
          : spec // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value._image
          : image // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SampleImpl extends _Sample with DiagnosticableTreeMixin {
  const _$SampleImpl(
      {this.id,
      this.barcode,
      @JsonKey(name: 'name_cn') this.nameCn,
      @JsonKey(name: 'product_no') this.productNo,
      @JsonKey(name: 'purchase_cost') this.purchaseCost,
      @JsonKey(name: 'page_no') this.pageNo,
      this.spec,
      final List<Media>? image})
      : _image = image,
        super._();

  factory _$SampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SampleImplFromJson(json);

  @override
  final int? id;
  @override
  final String? barcode;
  @override
  @JsonKey(name: 'name_cn')
  final String? nameCn;
  @override
  @JsonKey(name: 'product_no')
  final String? productNo;
  @override
  @JsonKey(name: 'purchase_cost')
  final String? purchaseCost;
  @override
  @JsonKey(name: 'page_no')
  final String? pageNo;
  @override
  final String? spec;
  final List<Media>? _image;
  @override
  List<Media>? get image {
    final value = _image;
    if (value == null) return null;
    if (_image is EqualUnmodifiableListView) return _image;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Sample(id: $id, barcode: $barcode, nameCn: $nameCn, productNo: $productNo, purchaseCost: $purchaseCost, pageNo: $pageNo, spec: $spec, image: $image)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Sample'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('barcode', barcode))
      ..add(DiagnosticsProperty('nameCn', nameCn))
      ..add(DiagnosticsProperty('productNo', productNo))
      ..add(DiagnosticsProperty('purchaseCost', purchaseCost))
      ..add(DiagnosticsProperty('pageNo', pageNo))
      ..add(DiagnosticsProperty('spec', spec))
      ..add(DiagnosticsProperty('image', image));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SampleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.nameCn, nameCn) || other.nameCn == nameCn) &&
            (identical(other.productNo, productNo) ||
                other.productNo == productNo) &&
            (identical(other.purchaseCost, purchaseCost) ||
                other.purchaseCost == purchaseCost) &&
            (identical(other.pageNo, pageNo) || other.pageNo == pageNo) &&
            (identical(other.spec, spec) || other.spec == spec) &&
            const DeepCollectionEquality().equals(other._image, _image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, barcode, nameCn, productNo,
      purchaseCost, pageNo, spec, const DeepCollectionEquality().hash(_image));

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
      final String? barcode,
      @JsonKey(name: 'name_cn') final String? nameCn,
      @JsonKey(name: 'product_no') final String? productNo,
      @JsonKey(name: 'purchase_cost') final String? purchaseCost,
      @JsonKey(name: 'page_no') final String? pageNo,
      final String? spec,
      final List<Media>? image}) = _$SampleImpl;
  const _Sample._() : super._();

  factory _Sample.fromJson(Map<String, dynamic> json) = _$SampleImpl.fromJson;

  @override
  int? get id;
  @override
  String? get barcode;
  @override
  @JsonKey(name: 'name_cn')
  String? get nameCn;
  @override
  @JsonKey(name: 'product_no')
  String? get productNo;
  @override
  @JsonKey(name: 'purchase_cost')
  String? get purchaseCost;
  @override
  @JsonKey(name: 'page_no')
  String? get pageNo;
  @override
  String? get spec;
  @override
  List<Media>? get image;
  @override
  @JsonKey(ignore: true)
  _$$SampleImplCopyWith<_$SampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
