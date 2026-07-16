// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseLocation _$WarehouseLocationFromJson(Map<String, dynamic> json) {
  return _WarehouseLocation.fromJson(json);
}

/// @nodoc
mixin _$WarehouseLocation {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'zone_id')
  int? get zoneId => throw _privateConstructorUsedError;
  WarehouseZone? get zone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseLocationCopyWith<WarehouseLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseLocationCopyWith<$Res> {
  factory $WarehouseLocationCopyWith(
          WarehouseLocation value, $Res Function(WarehouseLocation) then) =
      _$WarehouseLocationCopyWithImpl<$Res, WarehouseLocation>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? code,
      @JsonKey(name: 'zone_id') int? zoneId,
      WarehouseZone? zone});

  $WarehouseZoneCopyWith<$Res>? get zone;
}

/// @nodoc
class _$WarehouseLocationCopyWithImpl<$Res, $Val extends WarehouseLocation>
    implements $WarehouseLocationCopyWith<$Res> {
  _$WarehouseLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? zoneId = freezed,
    Object? zone = freezed,
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
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int?,
      zone: freezed == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as WarehouseZone?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseZoneCopyWith<$Res>? get zone {
    if (_value.zone == null) {
      return null;
    }

    return $WarehouseZoneCopyWith<$Res>(_value.zone!, (value) {
      return _then(_value.copyWith(zone: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarehouseLocationImplCopyWith<$Res>
    implements $WarehouseLocationCopyWith<$Res> {
  factory _$$WarehouseLocationImplCopyWith(_$WarehouseLocationImpl value,
          $Res Function(_$WarehouseLocationImpl) then) =
      __$$WarehouseLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? code,
      @JsonKey(name: 'zone_id') int? zoneId,
      WarehouseZone? zone});

  @override
  $WarehouseZoneCopyWith<$Res>? get zone;
}

/// @nodoc
class __$$WarehouseLocationImplCopyWithImpl<$Res>
    extends _$WarehouseLocationCopyWithImpl<$Res, _$WarehouseLocationImpl>
    implements _$$WarehouseLocationImplCopyWith<$Res> {
  __$$WarehouseLocationImplCopyWithImpl(_$WarehouseLocationImpl _value,
      $Res Function(_$WarehouseLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? zoneId = freezed,
    Object? zone = freezed,
  }) {
    return _then(_$WarehouseLocationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      zoneId: freezed == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int?,
      zone: freezed == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as WarehouseZone?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseLocationImpl extends _WarehouseLocation {
  const _$WarehouseLocationImpl(
      {this.id,
      this.name,
      this.code,
      @JsonKey(name: 'zone_id') this.zoneId,
      this.zone})
      : super._();

  factory _$WarehouseLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseLocationImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? code;
  @override
  @JsonKey(name: 'zone_id')
  final int? zoneId;
  @override
  final WarehouseZone? zone;

  @override
  String toString() {
    return 'WarehouseLocation(id: $id, name: $name, code: $code, zoneId: $zoneId, zone: $zone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            (identical(other.zone, zone) || other.zone == zone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code, zoneId, zone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseLocationImplCopyWith<_$WarehouseLocationImpl> get copyWith =>
      __$$WarehouseLocationImplCopyWithImpl<_$WarehouseLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseLocationImplToJson(
      this,
    );
  }
}

abstract class _WarehouseLocation extends WarehouseLocation {
  const factory _WarehouseLocation(
      {final int? id,
      final String? name,
      final String? code,
      @JsonKey(name: 'zone_id') final int? zoneId,
      final WarehouseZone? zone}) = _$WarehouseLocationImpl;
  const _WarehouseLocation._() : super._();

  factory _WarehouseLocation.fromJson(Map<String, dynamic> json) =
      _$WarehouseLocationImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get code;
  @override
  @JsonKey(name: 'zone_id')
  int? get zoneId;
  @override
  WarehouseZone? get zone;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseLocationImplCopyWith<_$WarehouseLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
