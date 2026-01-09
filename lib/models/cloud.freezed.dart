// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cloud _$CloudFromJson(Map<String, dynamic> json) {
  return _Cloud.fromJson(json);
}

/// @nodoc
mixin _$Cloud {
  int? get currentTenantId => throw _privateConstructorUsedError;
  List<Tenant> get tenants => throw _privateConstructorUsedError;
  String? get prePath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CloudCopyWith<Cloud> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CloudCopyWith<$Res> {
  factory $CloudCopyWith(Cloud value, $Res Function(Cloud) then) =
      _$CloudCopyWithImpl<$Res, Cloud>;
  @useResult
  $Res call({int? currentTenantId, List<Tenant> tenants, String? prePath});
}

/// @nodoc
class _$CloudCopyWithImpl<$Res, $Val extends Cloud>
    implements $CloudCopyWith<$Res> {
  _$CloudCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTenantId = freezed,
    Object? tenants = null,
    Object? prePath = freezed,
  }) {
    return _then(_value.copyWith(
      currentTenantId: freezed == currentTenantId
          ? _value.currentTenantId
          : currentTenantId // ignore: cast_nullable_to_non_nullable
              as int?,
      tenants: null == tenants
          ? _value.tenants
          : tenants // ignore: cast_nullable_to_non_nullable
              as List<Tenant>,
      prePath: freezed == prePath
          ? _value.prePath
          : prePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CloudImplCopyWith<$Res> implements $CloudCopyWith<$Res> {
  factory _$$CloudImplCopyWith(
          _$CloudImpl value, $Res Function(_$CloudImpl) then) =
      __$$CloudImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? currentTenantId, List<Tenant> tenants, String? prePath});
}

/// @nodoc
class __$$CloudImplCopyWithImpl<$Res>
    extends _$CloudCopyWithImpl<$Res, _$CloudImpl>
    implements _$$CloudImplCopyWith<$Res> {
  __$$CloudImplCopyWithImpl(
      _$CloudImpl _value, $Res Function(_$CloudImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTenantId = freezed,
    Object? tenants = null,
    Object? prePath = freezed,
  }) {
    return _then(_$CloudImpl(
      currentTenantId: freezed == currentTenantId
          ? _value.currentTenantId
          : currentTenantId // ignore: cast_nullable_to_non_nullable
              as int?,
      tenants: null == tenants
          ? _value._tenants
          : tenants // ignore: cast_nullable_to_non_nullable
              as List<Tenant>,
      prePath: freezed == prePath
          ? _value.prePath
          : prePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CloudImpl extends _Cloud {
  _$CloudImpl(
      {this.currentTenantId, required final List<Tenant> tenants, this.prePath})
      : _tenants = tenants,
        super._();

  factory _$CloudImpl.fromJson(Map<String, dynamic> json) =>
      _$$CloudImplFromJson(json);

  @override
  final int? currentTenantId;
  final List<Tenant> _tenants;
  @override
  List<Tenant> get tenants {
    if (_tenants is EqualUnmodifiableListView) return _tenants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tenants);
  }

  @override
  final String? prePath;

  @override
  String toString() {
    return 'Cloud(currentTenantId: $currentTenantId, tenants: $tenants, prePath: $prePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CloudImpl &&
            (identical(other.currentTenantId, currentTenantId) ||
                other.currentTenantId == currentTenantId) &&
            const DeepCollectionEquality().equals(other._tenants, _tenants) &&
            (identical(other.prePath, prePath) || other.prePath == prePath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentTenantId,
      const DeepCollectionEquality().hash(_tenants), prePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CloudImplCopyWith<_$CloudImpl> get copyWith =>
      __$$CloudImplCopyWithImpl<_$CloudImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CloudImplToJson(
      this,
    );
  }
}

abstract class _Cloud extends Cloud {
  factory _Cloud(
      {final int? currentTenantId,
      required final List<Tenant> tenants,
      final String? prePath}) = _$CloudImpl;
  _Cloud._() : super._();

  factory _Cloud.fromJson(Map<String, dynamic> json) = _$CloudImpl.fromJson;

  @override
  int? get currentTenantId;
  @override
  List<Tenant> get tenants;
  @override
  String? get prePath;
  @override
  @JsonKey(ignore: true)
  _$$CloudImplCopyWith<_$CloudImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
