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

TenantWxwork _$TenantWxworkFromJson(Map<String, dynamic> json) {
  return _TenantWxwork.fromJson(json);
}

/// @nodoc
mixin _$TenantWxwork {
  @JsonKey(name: 'agent_id')
  String? get agentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'corp_id')
  String? get corpId => throw _privateConstructorUsedError;
  String? get schema => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TenantWxworkCopyWith<TenantWxwork> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantWxworkCopyWith<$Res> {
  factory $TenantWxworkCopyWith(
          TenantWxwork value, $Res Function(TenantWxwork) then) =
      _$TenantWxworkCopyWithImpl<$Res, TenantWxwork>;
  @useResult
  $Res call(
      {@JsonKey(name: 'agent_id') String? agentId,
      @JsonKey(name: 'corp_id') String? corpId,
      String? schema});
}

/// @nodoc
class _$TenantWxworkCopyWithImpl<$Res, $Val extends TenantWxwork>
    implements $TenantWxworkCopyWith<$Res> {
  _$TenantWxworkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agentId = freezed,
    Object? corpId = freezed,
    Object? schema = freezed,
  }) {
    return _then(_value.copyWith(
      agentId: freezed == agentId
          ? _value.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String?,
      corpId: freezed == corpId
          ? _value.corpId
          : corpId // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TenantWxworkImplCopyWith<$Res>
    implements $TenantWxworkCopyWith<$Res> {
  factory _$$TenantWxworkImplCopyWith(
          _$TenantWxworkImpl value, $Res Function(_$TenantWxworkImpl) then) =
      __$$TenantWxworkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'agent_id') String? agentId,
      @JsonKey(name: 'corp_id') String? corpId,
      String? schema});
}

/// @nodoc
class __$$TenantWxworkImplCopyWithImpl<$Res>
    extends _$TenantWxworkCopyWithImpl<$Res, _$TenantWxworkImpl>
    implements _$$TenantWxworkImplCopyWith<$Res> {
  __$$TenantWxworkImplCopyWithImpl(
      _$TenantWxworkImpl _value, $Res Function(_$TenantWxworkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? agentId = freezed,
    Object? corpId = freezed,
    Object? schema = freezed,
  }) {
    return _then(_$TenantWxworkImpl(
      agentId: freezed == agentId
          ? _value.agentId
          : agentId // ignore: cast_nullable_to_non_nullable
              as String?,
      corpId: freezed == corpId
          ? _value.corpId
          : corpId // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantWxworkImpl implements _TenantWxwork {
  _$TenantWxworkImpl(
      {@JsonKey(name: 'agent_id') this.agentId,
      @JsonKey(name: 'corp_id') this.corpId,
      this.schema});

  factory _$TenantWxworkImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantWxworkImplFromJson(json);

  @override
  @JsonKey(name: 'agent_id')
  final String? agentId;
  @override
  @JsonKey(name: 'corp_id')
  final String? corpId;
  @override
  final String? schema;

  @override
  String toString() {
    return 'TenantWxwork(agentId: $agentId, corpId: $corpId, schema: $schema)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantWxworkImpl &&
            (identical(other.agentId, agentId) || other.agentId == agentId) &&
            (identical(other.corpId, corpId) || other.corpId == corpId) &&
            (identical(other.schema, schema) || other.schema == schema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, agentId, corpId, schema);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantWxworkImplCopyWith<_$TenantWxworkImpl> get copyWith =>
      __$$TenantWxworkImplCopyWithImpl<_$TenantWxworkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantWxworkImplToJson(
      this,
    );
  }
}

abstract class _TenantWxwork implements TenantWxwork {
  factory _TenantWxwork(
      {@JsonKey(name: 'agent_id') final String? agentId,
      @JsonKey(name: 'corp_id') final String? corpId,
      final String? schema}) = _$TenantWxworkImpl;

  factory _TenantWxwork.fromJson(Map<String, dynamic> json) =
      _$TenantWxworkImpl.fromJson;

  @override
  @JsonKey(name: 'agent_id')
  String? get agentId;
  @override
  @JsonKey(name: 'corp_id')
  String? get corpId;
  @override
  String? get schema;
  @override
  @JsonKey(ignore: true)
  _$$TenantWxworkImplCopyWith<_$TenantWxworkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
  TenantWxwork? get wxwork => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_features')
  List<String?>? get appFeatures => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'base_url') String? baseUrl,
      TenantWxwork? wxwork,
      @JsonKey(name: 'app_features') List<String?>? appFeatures});

  $TenantWxworkCopyWith<$Res>? get wxwork;
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
    Object? wxwork = freezed,
    Object? appFeatures = freezed,
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
      wxwork: freezed == wxwork
          ? _value.wxwork
          : wxwork // ignore: cast_nullable_to_non_nullable
              as TenantWxwork?,
      appFeatures: freezed == appFeatures
          ? _value.appFeatures
          : appFeatures // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TenantWxworkCopyWith<$Res>? get wxwork {
    if (_value.wxwork == null) {
      return null;
    }

    return $TenantWxworkCopyWith<$Res>(_value.wxwork!, (value) {
      return _then(_value.copyWith(wxwork: value) as $Val);
    });
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
      @JsonKey(name: 'base_url') String? baseUrl,
      TenantWxwork? wxwork,
      @JsonKey(name: 'app_features') List<String?>? appFeatures});

  @override
  $TenantWxworkCopyWith<$Res>? get wxwork;
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
    Object? wxwork = freezed,
    Object? appFeatures = freezed,
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
      wxwork: freezed == wxwork
          ? _value.wxwork
          : wxwork // ignore: cast_nullable_to_non_nullable
              as TenantWxwork?,
      appFeatures: freezed == appFeatures
          ? _value._appFeatures
          : appFeatures // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
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
      @JsonKey(name: 'base_url') this.baseUrl,
      this.wxwork,
      @JsonKey(name: 'app_features') final List<String?>? appFeatures})
      : _loginWays = loginWays,
        _appFeatures = appFeatures;

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
  final TenantWxwork? wxwork;
  final List<String?>? _appFeatures;
  @override
  @JsonKey(name: 'app_features')
  List<String?>? get appFeatures {
    final value = _appFeatures;
    if (value == null) return null;
    if (_appFeatures is EqualUnmodifiableListView) return _appFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Tenant(id: $id, title: $title, loginWays: $loginWays, baseUrl: $baseUrl, wxwork: $wxwork, appFeatures: $appFeatures)';
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
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.wxwork, wxwork) || other.wxwork == wxwork) &&
            const DeepCollectionEquality()
                .equals(other._appFeatures, _appFeatures));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_loginWays),
      baseUrl,
      wxwork,
      const DeepCollectionEquality().hash(_appFeatures));

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
          @JsonKey(name: 'base_url') final String? baseUrl,
          final TenantWxwork? wxwork,
          @JsonKey(name: 'app_features') final List<String?>? appFeatures}) =
      _$TenantImpl;

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
  TenantWxwork? get wxwork;
  @override
  @JsonKey(name: 'app_features')
  List<String?>? get appFeatures;
  @override
  @JsonKey(ignore: true)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
