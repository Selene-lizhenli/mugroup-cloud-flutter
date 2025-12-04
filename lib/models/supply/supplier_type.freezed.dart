// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SupplierType _$SupplierTypeFromJson(Map<String, dynamic> json) {
  return _SupplierType.fromJson(json);
}

/// @nodoc
mixin _$SupplierType {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupplierTypeCopyWith<SupplierType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierTypeCopyWith<$Res> {
  factory $SupplierTypeCopyWith(
          SupplierType value, $Res Function(SupplierType) then) =
      _$SupplierTypeCopyWithImpl<$Res, SupplierType>;
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class _$SupplierTypeCopyWithImpl<$Res, $Val extends SupplierType>
    implements $SupplierTypeCopyWith<$Res> {
  _$SupplierTypeCopyWithImpl(this._value, this._then);

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
abstract class _$$SupplierTypeImplCopyWith<$Res>
    implements $SupplierTypeCopyWith<$Res> {
  factory _$$SupplierTypeImplCopyWith(
          _$SupplierTypeImpl value, $Res Function(_$SupplierTypeImpl) then) =
      __$$SupplierTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name});
}

/// @nodoc
class __$$SupplierTypeImplCopyWithImpl<$Res>
    extends _$SupplierTypeCopyWithImpl<$Res, _$SupplierTypeImpl>
    implements _$$SupplierTypeImplCopyWith<$Res> {
  __$$SupplierTypeImplCopyWithImpl(
      _$SupplierTypeImpl _value, $Res Function(_$SupplierTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_$SupplierTypeImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierTypeImpl implements _SupplierType {
  _$SupplierTypeImpl(this.id, this.name);

  factory _$SupplierTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierTypeImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;

  @override
  String toString() {
    return 'SupplierType(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierTypeImplCopyWith<_$SupplierTypeImpl> get copyWith =>
      __$$SupplierTypeImplCopyWithImpl<_$SupplierTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplierTypeImplToJson(
      this,
    );
  }
}

abstract class _SupplierType implements SupplierType {
  factory _SupplierType(final int? id, final String? name) = _$SupplierTypeImpl;

  factory _SupplierType.fromJson(Map<String, dynamic> json) =
      _$SupplierTypeImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$SupplierTypeImplCopyWith<_$SupplierTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
