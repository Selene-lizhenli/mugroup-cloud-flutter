// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_station_inquiries.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SingleStationInquiries _$SingleStationInquiriesFromJson(
    Map<String, dynamic> json) {
  return _SingleStationInquiries.fromJson(json);
}

/// @nodoc
mixin _$SingleStationInquiries {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  int? get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get ip => throw _privateConstructorUsedError;
  String? get ua => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  SingleStationItem? get station => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SingleStationInquiriesCopyWith<SingleStationInquiries> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleStationInquiriesCopyWith<$Res> {
  factory $SingleStationInquiriesCopyWith(SingleStationInquiries value,
          $Res Function(SingleStationInquiries) then) =
      _$SingleStationInquiriesCopyWithImpl<$Res, SingleStationInquiries>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'station_id') int? stationId,
      @JsonKey(name: 'user_id') int? userId,
      String? name,
      String? email,
      String? phone,
      String? ip,
      String? ua,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      User? user,
      SingleStationItem? station});

  $UserCopyWith<$Res>? get user;
  $SingleStationItemCopyWith<$Res>? get station;
}

/// @nodoc
class _$SingleStationInquiriesCopyWithImpl<$Res,
        $Val extends SingleStationInquiries>
    implements $SingleStationInquiriesCopyWith<$Res> {
  _$SingleStationInquiriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? stationId = freezed,
    Object? userId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? ip = freezed,
    Object? ua = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? station = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      stationId: freezed == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      ua: freezed == ua
          ? _value.ua
          : ua // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as SingleStationItem?,
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
  $SingleStationItemCopyWith<$Res>? get station {
    if (_value.station == null) {
      return null;
    }

    return $SingleStationItemCopyWith<$Res>(_value.station!, (value) {
      return _then(_value.copyWith(station: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SingleStationInquiriesImplCopyWith<$Res>
    implements $SingleStationInquiriesCopyWith<$Res> {
  factory _$$SingleStationInquiriesImplCopyWith(
          _$SingleStationInquiriesImpl value,
          $Res Function(_$SingleStationInquiriesImpl) then) =
      __$$SingleStationInquiriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'station_id') int? stationId,
      @JsonKey(name: 'user_id') int? userId,
      String? name,
      String? email,
      String? phone,
      String? ip,
      String? ua,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      User? user,
      SingleStationItem? station});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $SingleStationItemCopyWith<$Res>? get station;
}

/// @nodoc
class __$$SingleStationInquiriesImplCopyWithImpl<$Res>
    extends _$SingleStationInquiriesCopyWithImpl<$Res,
        _$SingleStationInquiriesImpl>
    implements _$$SingleStationInquiriesImplCopyWith<$Res> {
  __$$SingleStationInquiriesImplCopyWithImpl(
      _$SingleStationInquiriesImpl _value,
      $Res Function(_$SingleStationInquiriesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? stationId = freezed,
    Object? userId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? ip = freezed,
    Object? ua = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? user = freezed,
    Object? station = freezed,
  }) {
    return _then(_$SingleStationInquiriesImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      stationId: freezed == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      ua: freezed == ua
          ? _value.ua
          : ua // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as SingleStationItem?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SingleStationInquiriesImpl implements _SingleStationInquiries {
  _$SingleStationInquiriesImpl(
      {this.id,
      @JsonKey(name: 'station_id') this.stationId,
      @JsonKey(name: 'user_id') this.userId,
      this.name,
      this.email,
      this.phone,
      this.ip,
      this.ua,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.user,
      this.station});

  factory _$SingleStationInquiriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SingleStationInquiriesImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'station_id')
  final int? stationId;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? ip;
  @override
  final String? ua;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final User? user;
  @override
  final SingleStationItem? station;

  @override
  String toString() {
    return 'SingleStationInquiries(id: $id, stationId: $stationId, userId: $userId, name: $name, email: $email, phone: $phone, ip: $ip, ua: $ua, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, station: $station)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SingleStationInquiriesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.ua, ua) || other.ua == ua) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.station, station) || other.station == station));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, stationId, userId, name,
      email, phone, ip, ua, createdAt, updatedAt, user, station);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleStationInquiriesImplCopyWith<_$SingleStationInquiriesImpl>
      get copyWith => __$$SingleStationInquiriesImplCopyWithImpl<
          _$SingleStationInquiriesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SingleStationInquiriesImplToJson(
      this,
    );
  }
}

abstract class _SingleStationInquiries implements SingleStationInquiries {
  factory _SingleStationInquiries(
      {final int? id,
      @JsonKey(name: 'station_id') final int? stationId,
      @JsonKey(name: 'user_id') final int? userId,
      final String? name,
      final String? email,
      final String? phone,
      final String? ip,
      final String? ua,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      final User? user,
      final SingleStationItem? station}) = _$SingleStationInquiriesImpl;

  factory _SingleStationInquiries.fromJson(Map<String, dynamic> json) =
      _$SingleStationInquiriesImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'station_id')
  int? get stationId;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  String? get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get ip;
  @override
  String? get ua;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  User? get user;
  @override
  SingleStationItem? get station;
  @override
  @JsonKey(ignore: true)
  _$$SingleStationInquiriesImplCopyWith<_$SingleStationInquiriesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
