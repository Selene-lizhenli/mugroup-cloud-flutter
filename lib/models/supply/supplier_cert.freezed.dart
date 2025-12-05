// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_cert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SupplierCert _$SupplierCertFromJson(Map<String, dynamic> json) {
  return _SupplierCert.fromJson(json);
}

/// @nodoc
mixin _$SupplierCert {
  int? get id => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  Cert? get cert => throw _privateConstructorUsedError;
  Supplier? get supplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'expired_at')
  DateTime? get expiredAt => throw _privateConstructorUsedError;
  List<Media>? get media => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupplierCertCopyWith<SupplierCert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierCertCopyWith<$Res> {
  factory $SupplierCertCopyWith(
          SupplierCert value, $Res Function(SupplierCert) then) =
      _$SupplierCertCopyWithImpl<$Res, SupplierCert>;
  @useResult
  $Res call(
      {int? id,
      User? user,
      Cert? cert,
      Supplier? supplier,
      @JsonKey(name: 'expired_at') DateTime? expiredAt,
      List<Media>? media,
      String? remark,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  $UserCopyWith<$Res>? get user;
  $CertCopyWith<$Res>? get cert;
  $SupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class _$SupplierCertCopyWithImpl<$Res, $Val extends SupplierCert>
    implements $SupplierCertCopyWith<$Res> {
  _$SupplierCertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? cert = freezed,
    Object? supplier = freezed,
    Object? expiredAt = freezed,
    Object? media = freezed,
    Object? remark = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      cert: freezed == cert
          ? _value.cert
          : cert // ignore: cast_nullable_to_non_nullable
              as Cert?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
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
  $CertCopyWith<$Res>? get cert {
    if (_value.cert == null) {
      return null;
    }

    return $CertCopyWith<$Res>(_value.cert!, (value) {
      return _then(_value.copyWith(cert: value) as $Val);
    });
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
abstract class _$$SupplierCertImplCopyWith<$Res>
    implements $SupplierCertCopyWith<$Res> {
  factory _$$SupplierCertImplCopyWith(
          _$SupplierCertImpl value, $Res Function(_$SupplierCertImpl) then) =
      __$$SupplierCertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      User? user,
      Cert? cert,
      Supplier? supplier,
      @JsonKey(name: 'expired_at') DateTime? expiredAt,
      List<Media>? media,
      String? remark,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $CertCopyWith<$Res>? get cert;
  @override
  $SupplierCopyWith<$Res>? get supplier;
}

/// @nodoc
class __$$SupplierCertImplCopyWithImpl<$Res>
    extends _$SupplierCertCopyWithImpl<$Res, _$SupplierCertImpl>
    implements _$$SupplierCertImplCopyWith<$Res> {
  __$$SupplierCertImplCopyWithImpl(
      _$SupplierCertImpl _value, $Res Function(_$SupplierCertImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? user = freezed,
    Object? cert = freezed,
    Object? supplier = freezed,
    Object? expiredAt = freezed,
    Object? media = freezed,
    Object? remark = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SupplierCertImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      freezed == cert
          ? _value.cert
          : cert // ignore: cast_nullable_to_non_nullable
              as Cert?,
      freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Supplier?,
      freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierCertImpl implements _SupplierCert {
  _$SupplierCertImpl(
      this.id,
      this.user,
      this.cert,
      this.supplier,
      @JsonKey(name: 'expired_at') this.expiredAt,
      final List<Media>? media,
      this.remark,
      @JsonKey(name: 'created_at') this.createdAt)
      : _media = media;

  factory _$SupplierCertImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierCertImplFromJson(json);

  @override
  final int? id;
  @override
  final User? user;
  @override
  final Cert? cert;
  @override
  final Supplier? supplier;
  @override
  @JsonKey(name: 'expired_at')
  final DateTime? expiredAt;
  final List<Media>? _media;
  @override
  List<Media>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? remark;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SupplierCert(id: $id, user: $user, cert: $cert, supplier: $supplier, expiredAt: $expiredAt, media: $media, remark: $remark, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierCertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.cert, cert) || other.cert == cert) &&
            (identical(other.supplier, supplier) ||
                other.supplier == supplier) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user,
      cert,
      supplier,
      expiredAt,
      const DeepCollectionEquality().hash(_media),
      remark,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierCertImplCopyWith<_$SupplierCertImpl> get copyWith =>
      __$$SupplierCertImplCopyWithImpl<_$SupplierCertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplierCertImplToJson(
      this,
    );
  }
}

abstract class _SupplierCert implements SupplierCert {
  factory _SupplierCert(
          final int? id,
          final User? user,
          final Cert? cert,
          final Supplier? supplier,
          @JsonKey(name: 'expired_at') final DateTime? expiredAt,
          final List<Media>? media,
          final String? remark,
          @JsonKey(name: 'created_at') final DateTime? createdAt) =
      _$SupplierCertImpl;

  factory _SupplierCert.fromJson(Map<String, dynamic> json) =
      _$SupplierCertImpl.fromJson;

  @override
  int? get id;
  @override
  User? get user;
  @override
  Cert? get cert;
  @override
  Supplier? get supplier;
  @override
  @JsonKey(name: 'expired_at')
  DateTime? get expiredAt;
  @override
  List<Media>? get media;
  @override
  String? get remark;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SupplierCertImplCopyWith<_$SupplierCertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
