// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_round_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InspectionRoundSnapshot _$InspectionRoundSnapshotFromJson(
    Map<String, dynamic> json) {
  return _InspectionRoundSnapshot.fromJson(json);
}

/// @nodoc
mixin _$InspectionRoundSnapshot {
  int? get round => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_snapshot')
  List<Media>? get mediaSnapshot => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspector_name')
  String? get inspectorName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InspectionRoundSnapshotCopyWith<InspectionRoundSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionRoundSnapshotCopyWith<$Res> {
  factory $InspectionRoundSnapshotCopyWith(InspectionRoundSnapshot value,
          $Res Function(InspectionRoundSnapshot) then) =
      _$InspectionRoundSnapshotCopyWithImpl<$Res, InspectionRoundSnapshot>;
  @useResult
  $Res call(
      {int? round,
      int? status,
      String? remark,
      @JsonKey(name: 'media_snapshot') List<Media>? mediaSnapshot,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'inspector_name') String? inspectorName});
}

/// @nodoc
class _$InspectionRoundSnapshotCopyWithImpl<$Res,
        $Val extends InspectionRoundSnapshot>
    implements $InspectionRoundSnapshotCopyWith<$Res> {
  _$InspectionRoundSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? round = freezed,
    Object? status = freezed,
    Object? remark = freezed,
    Object? mediaSnapshot = freezed,
    Object? createdAt = freezed,
    Object? inspectorName = freezed,
  }) {
    return _then(_value.copyWith(
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaSnapshot: freezed == mediaSnapshot
          ? _value.mediaSnapshot
          : mediaSnapshot // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InspectionRoundSnapshotImplCopyWith<$Res>
    implements $InspectionRoundSnapshotCopyWith<$Res> {
  factory _$$InspectionRoundSnapshotImplCopyWith(
          _$InspectionRoundSnapshotImpl value,
          $Res Function(_$InspectionRoundSnapshotImpl) then) =
      __$$InspectionRoundSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? round,
      int? status,
      String? remark,
      @JsonKey(name: 'media_snapshot') List<Media>? mediaSnapshot,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'inspector_name') String? inspectorName});
}

/// @nodoc
class __$$InspectionRoundSnapshotImplCopyWithImpl<$Res>
    extends _$InspectionRoundSnapshotCopyWithImpl<$Res,
        _$InspectionRoundSnapshotImpl>
    implements _$$InspectionRoundSnapshotImplCopyWith<$Res> {
  __$$InspectionRoundSnapshotImplCopyWithImpl(
      _$InspectionRoundSnapshotImpl _value,
      $Res Function(_$InspectionRoundSnapshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? round = freezed,
    Object? status = freezed,
    Object? remark = freezed,
    Object? mediaSnapshot = freezed,
    Object? createdAt = freezed,
    Object? inspectorName = freezed,
  }) {
    return _then(_$InspectionRoundSnapshotImpl(
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaSnapshot: freezed == mediaSnapshot
          ? _value._mediaSnapshot
          : mediaSnapshot // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionRoundSnapshotImpl implements _InspectionRoundSnapshot {
  _$InspectionRoundSnapshotImpl(
      {this.round,
      this.status,
      this.remark,
      @JsonKey(name: 'media_snapshot') final List<Media>? mediaSnapshot,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'inspector_name') this.inspectorName})
      : _mediaSnapshot = mediaSnapshot;

  factory _$InspectionRoundSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionRoundSnapshotImplFromJson(json);

  @override
  final int? round;
  @override
  final int? status;
  @override
  final String? remark;
  final List<Media>? _mediaSnapshot;
  @override
  @JsonKey(name: 'media_snapshot')
  List<Media>? get mediaSnapshot {
    final value = _mediaSnapshot;
    if (value == null) return null;
    if (_mediaSnapshot is EqualUnmodifiableListView) return _mediaSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'inspector_name')
  final String? inspectorName;

  @override
  String toString() {
    return 'InspectionRoundSnapshot(round: $round, status: $status, remark: $remark, mediaSnapshot: $mediaSnapshot, createdAt: $createdAt, inspectorName: $inspectorName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionRoundSnapshotImpl &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            const DeepCollectionEquality()
                .equals(other._mediaSnapshot, _mediaSnapshot) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.inspectorName, inspectorName) ||
                other.inspectorName == inspectorName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      round,
      status,
      remark,
      const DeepCollectionEquality().hash(_mediaSnapshot),
      createdAt,
      inspectorName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionRoundSnapshotImplCopyWith<_$InspectionRoundSnapshotImpl>
      get copyWith => __$$InspectionRoundSnapshotImplCopyWithImpl<
          _$InspectionRoundSnapshotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionRoundSnapshotImplToJson(
      this,
    );
  }
}

abstract class _InspectionRoundSnapshot implements InspectionRoundSnapshot {
  factory _InspectionRoundSnapshot(
          {final int? round,
          final int? status,
          final String? remark,
          @JsonKey(name: 'media_snapshot') final List<Media>? mediaSnapshot,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'inspector_name') final String? inspectorName}) =
      _$InspectionRoundSnapshotImpl;

  factory _InspectionRoundSnapshot.fromJson(Map<String, dynamic> json) =
      _$InspectionRoundSnapshotImpl.fromJson;

  @override
  int? get round;
  @override
  int? get status;
  @override
  String? get remark;
  @override
  @JsonKey(name: 'media_snapshot')
  List<Media>? get mediaSnapshot;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'inspector_name')
  String? get inspectorName;
  @override
  @JsonKey(ignore: true)
  _$$InspectionRoundSnapshotImplCopyWith<_$InspectionRoundSnapshotImpl>
      get copyWith => throw _privateConstructorUsedError;
}
