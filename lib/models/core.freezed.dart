// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tenant _$TenantFromJson(Map<String, dynamic> json) {
  return _Tenant.fromJson(json);
}

/// @nodoc
mixin _$Tenant {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'login_ways')
  List<String>? get loginWays => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_url')
  String? get baseUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TenantCopyWith<Tenant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantCopyWith<$Res> {
  factory $TenantCopyWith(Tenant value, $Res Function(Tenant) then) =
      _$TenantCopyWithImpl<$Res, Tenant>;
  @useResult
  $Res call(
      {int? id,
      String? title,
      @JsonKey(name: 'login_ways') List<String>? loginWays,
      @JsonKey(name: 'base_url') String? baseUrl});
}

/// @nodoc
class _$TenantCopyWithImpl<$Res, $Val extends Tenant>
    implements $TenantCopyWith<$Res> {
  _$TenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? loginWays = freezed,
    Object? baseUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      loginWays: freezed == loginWays
          ? _value.loginWays
          : loginWays // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TenantImplCopyWith<$Res> implements $TenantCopyWith<$Res> {
  factory _$$TenantImplCopyWith(
          _$TenantImpl value, $Res Function(_$TenantImpl) then) =
      __$$TenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? title,
      @JsonKey(name: 'login_ways') List<String>? loginWays,
      @JsonKey(name: 'base_url') String? baseUrl});
}

/// @nodoc
class __$$TenantImplCopyWithImpl<$Res>
    extends _$TenantCopyWithImpl<$Res, _$TenantImpl>
    implements _$$TenantImplCopyWith<$Res> {
  __$$TenantImplCopyWithImpl(
      _$TenantImpl _value, $Res Function(_$TenantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? loginWays = freezed,
    Object? baseUrl = freezed,
  }) {
    return _then(_$TenantImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      loginWays: freezed == loginWays
          ? _value._loginWays
          : loginWays // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantImpl implements _Tenant {
  _$TenantImpl(
      {this.id,
      this.title,
      @JsonKey(name: 'login_ways') final List<String>? loginWays,
      @JsonKey(name: 'base_url') this.baseUrl})
      : _loginWays = loginWays;

  factory _$TenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  final List<String>? _loginWays;
  @override
  @JsonKey(name: 'login_ways')
  List<String>? get loginWays {
    final value = _loginWays;
    if (value == null) return null;
    if (_loginWays is EqualUnmodifiableListView) return _loginWays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'base_url')
  final String? baseUrl;

  @override
  String toString() {
    return 'Tenant(id: $id, title: $title, loginWays: $loginWays, baseUrl: $baseUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._loginWays, _loginWays) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title,
      const DeepCollectionEquality().hash(_loginWays), baseUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      __$$TenantImplCopyWithImpl<_$TenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantImplToJson(
      this,
    );
  }
}

abstract class _Tenant implements Tenant {
  factory _Tenant(
      {final int? id,
      final String? title,
      @JsonKey(name: 'login_ways') final List<String>? loginWays,
      @JsonKey(name: 'base_url') final String? baseUrl}) = _$TenantImpl;

  factory _Tenant.fromJson(Map<String, dynamic> json) = _$TenantImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  @JsonKey(name: 'login_ways')
  List<String>? get loginWays;
  @override
  @JsonKey(name: 'base_url')
  String? get baseUrl;
  @override
  @JsonKey(ignore: true)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
