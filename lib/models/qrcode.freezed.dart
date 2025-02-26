// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qrcode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Qrcode _$QrcodeFromJson(Map<String, dynamic> json) {
  return _Qrcode.fromJson(json);
}

/// @nodoc
mixin _$Qrcode {
  int? get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expired_at')
  String? get expiredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_at')
  String? get usedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  User? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QrcodeCopyWith<Qrcode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrcodeCopyWith<$Res> {
  factory $QrcodeCopyWith(Qrcode value, $Res Function(Qrcode) then) =
      _$QrcodeCopyWithImpl<$Res, Qrcode>;
  @useResult
  $Res call(
      {int? id,
      String? type,
      String? code,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'expired_at') String? expiredAt,
      @JsonKey(name: 'used_at') String? usedAt,
      @JsonKey(name: 'user') User? user});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$QrcodeCopyWithImpl<$Res, $Val extends Qrcode>
    implements $QrcodeCopyWith<$Res> {
  _$QrcodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? code = freezed,
    Object? userId = freezed,
    Object? expiredAt = freezed,
    Object? usedAt = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
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
}

/// @nodoc
abstract class _$$QrcodeImplCopyWith<$Res> implements $QrcodeCopyWith<$Res> {
  factory _$$QrcodeImplCopyWith(
          _$QrcodeImpl value, $Res Function(_$QrcodeImpl) then) =
      __$$QrcodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? type,
      String? code,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'expired_at') String? expiredAt,
      @JsonKey(name: 'used_at') String? usedAt,
      @JsonKey(name: 'user') User? user});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$QrcodeImplCopyWithImpl<$Res>
    extends _$QrcodeCopyWithImpl<$Res, _$QrcodeImpl>
    implements _$$QrcodeImplCopyWith<$Res> {
  __$$QrcodeImplCopyWithImpl(
      _$QrcodeImpl _value, $Res Function(_$QrcodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? code = freezed,
    Object? userId = freezed,
    Object? expiredAt = freezed,
    Object? usedAt = freezed,
    Object? user = freezed,
  }) {
    return _then(_$QrcodeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QrcodeImpl implements _Qrcode {
  const _$QrcodeImpl(
      {this.id,
      this.type,
      this.code,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'expired_at') this.expiredAt,
      @JsonKey(name: 'used_at') this.usedAt,
      @JsonKey(name: 'user') this.user});

  factory _$QrcodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrcodeImplFromJson(json);

  @override
  final int? id;
  @override
  final String? type;
  @override
  final String? code;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'expired_at')
  final String? expiredAt;
  @override
  @JsonKey(name: 'used_at')
  final String? usedAt;
  @override
  @JsonKey(name: 'user')
  final User? user;

  @override
  String toString() {
    return 'Qrcode(id: $id, type: $type, code: $code, userId: $userId, expiredAt: $expiredAt, usedAt: $usedAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrcodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, code, userId, expiredAt, usedAt, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrcodeImplCopyWith<_$QrcodeImpl> get copyWith =>
      __$$QrcodeImplCopyWithImpl<_$QrcodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QrcodeImplToJson(
      this,
    );
  }
}

abstract class _Qrcode implements Qrcode {
  const factory _Qrcode(
      {final int? id,
      final String? type,
      final String? code,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'expired_at') final String? expiredAt,
      @JsonKey(name: 'used_at') final String? usedAt,
      @JsonKey(name: 'user') final User? user}) = _$QrcodeImpl;

  factory _Qrcode.fromJson(Map<String, dynamic> json) = _$QrcodeImpl.fromJson;

  @override
  int? get id;
  @override
  String? get type;
  @override
  String? get code;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'expired_at')
  String? get expiredAt;
  @override
  @JsonKey(name: 'used_at')
  String? get usedAt;
  @override
  @JsonKey(name: 'user')
  User? get user;
  @override
  @JsonKey(ignore: true)
  _$$QrcodeImplCopyWith<_$QrcodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
