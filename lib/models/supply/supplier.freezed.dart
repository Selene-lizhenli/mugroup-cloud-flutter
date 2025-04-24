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
  @JsonKey(name: 'supplier_no')
  String? get supplierNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_name')
  String? get shortName => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'short_name') String? shortName,
      String? name});
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
    Object? supplierNo = freezed,
    Object? shortName = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierNo: freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      shortName: freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'supplier_no') String? supplierNo,
      @JsonKey(name: 'short_name') String? shortName,
      String? name});
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
    Object? supplierNo = freezed,
    Object? shortName = freezed,
    Object? name = freezed,
  }) {
    return _then(_$SupplierImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == supplierNo
          ? _value.supplierNo
          : supplierNo // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierImpl implements _Supplier {
  _$SupplierImpl(this.id, @JsonKey(name: 'supplier_no') this.supplierNo,
      @JsonKey(name: 'short_name') this.shortName, this.name);

  factory _$SupplierImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'supplier_no')
  final String? supplierNo;
  @override
  @JsonKey(name: 'short_name')
  final String? shortName;
  @override
  final String? name;

  @override
  String toString() {
    return 'Supplier(id: $id, supplierNo: $supplierNo, shortName: $shortName, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supplierNo, supplierNo) ||
                other.supplierNo == supplierNo) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, supplierNo, shortName, name);

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
      @JsonKey(name: 'supplier_no') final String? supplierNo,
      @JsonKey(name: 'short_name') final String? shortName,
      final String? name) = _$SupplierImpl;

  factory _Supplier.fromJson(Map<String, dynamic> json) =
      _$SupplierImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'supplier_no')
  String? get supplierNo;
  @override
  @JsonKey(name: 'short_name')
  String? get shortName;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$SupplierImplCopyWith<_$SupplierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
