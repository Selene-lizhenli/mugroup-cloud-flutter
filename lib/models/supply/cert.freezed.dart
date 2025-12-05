// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cert _$CertFromJson(Map<String, dynamic> json) {
  return _Cert.fromJson(json);
}

/// @nodoc
mixin _$Cert {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CertCopyWith<Cert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertCopyWith<$Res> {
  factory $CertCopyWith(Cert value, $Res Function(Cert) then) =
      _$CertCopyWithImpl<$Res, Cert>;
  @useResult
  $Res call({int? id, String? name, String? remark});
}

/// @nodoc
class _$CertCopyWithImpl<$Res, $Val extends Cert>
    implements $CertCopyWith<$Res> {
  _$CertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? remark = freezed,
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
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertImplCopyWith<$Res> implements $CertCopyWith<$Res> {
  factory _$$CertImplCopyWith(
          _$CertImpl value, $Res Function(_$CertImpl) then) =
      __$$CertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? name, String? remark});
}

/// @nodoc
class __$$CertImplCopyWithImpl<$Res>
    extends _$CertCopyWithImpl<$Res, _$CertImpl>
    implements _$$CertImplCopyWith<$Res> {
  __$$CertImplCopyWithImpl(_$CertImpl _value, $Res Function(_$CertImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? remark = freezed,
  }) {
    return _then(_$CertImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertImpl implements _Cert {
  _$CertImpl(this.id, this.name, this.remark);

  factory _$CertImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? remark;

  @override
  String toString() {
    return 'Cert(id: $id, name: $name, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, remark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CertImplCopyWith<_$CertImpl> get copyWith =>
      __$$CertImplCopyWithImpl<_$CertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertImplToJson(
      this,
    );
  }
}

abstract class _Cert implements Cert {
  factory _Cert(final int? id, final String? name, final String? remark) =
      _$CertImpl;

  factory _Cert.fromJson(Map<String, dynamic> json) = _$CertImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get remark;
  @override
  @JsonKey(ignore: true)
  _$$CertImplCopyWith<_$CertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
