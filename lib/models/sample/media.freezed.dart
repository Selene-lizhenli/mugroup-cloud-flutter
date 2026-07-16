// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemporaryMedia _$TemporaryMediaFromJson(Map<String, dynamic> json) {
  return _TemporaryMedia.fromJson(json);
}

/// @nodoc
mixin _$TemporaryMedia {
  @JsonKey(fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
  Object get id => throw _privateConstructorUsedError;
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TemporaryMediaCopyWith<TemporaryMedia> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemporaryMediaCopyWith<$Res> {
  factory $TemporaryMediaCopyWith(
          TemporaryMedia value, $Res Function(TemporaryMedia) then) =
      _$TemporaryMediaCopyWithImpl<$Res, TemporaryMedia>;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
      Object id,
      String? uuid,
      @JsonKey(name: 'thumb_url') String? thumbUrl,
      String url});
}

/// @nodoc
class _$TemporaryMediaCopyWithImpl<$Res, $Val extends TemporaryMedia>
    implements $TemporaryMediaCopyWith<$Res> {
  _$TemporaryMediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? thumbUrl = freezed,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemporaryMediaImplCopyWith<$Res>
    implements $TemporaryMediaCopyWith<$Res> {
  factory _$$TemporaryMediaImplCopyWith(_$TemporaryMediaImpl value,
          $Res Function(_$TemporaryMediaImpl) then) =
      __$$TemporaryMediaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
      Object id,
      String? uuid,
      @JsonKey(name: 'thumb_url') String? thumbUrl,
      String url});
}

/// @nodoc
class __$$TemporaryMediaImplCopyWithImpl<$Res>
    extends _$TemporaryMediaCopyWithImpl<$Res, _$TemporaryMediaImpl>
    implements _$$TemporaryMediaImplCopyWith<$Res> {
  __$$TemporaryMediaImplCopyWithImpl(
      _$TemporaryMediaImpl _value, $Res Function(_$TemporaryMediaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? thumbUrl = freezed,
    Object? url = null,
  }) {
    return _then(_$TemporaryMediaImpl(
      id: null == id ? _value.id : id,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemporaryMediaImpl extends _TemporaryMedia {
  const _$TemporaryMediaImpl(
      {@JsonKey(
          fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
      required this.id,
      this.uuid,
      @JsonKey(name: 'thumb_url') this.thumbUrl,
      required this.url})
      : super._();

  factory _$TemporaryMediaImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemporaryMediaImplFromJson(json);

  @override
  @JsonKey(fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
  final Object id;
  @override
  final String? uuid;
  @override
  @JsonKey(name: 'thumb_url')
  final String? thumbUrl;
  @override
  final String url;

  @override
  String toString() {
    return 'TemporaryMedia(id: $id, uuid: $uuid, thumbUrl: $thumbUrl, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemporaryMediaImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(id), uuid, thumbUrl, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TemporaryMediaImplCopyWith<_$TemporaryMediaImpl> get copyWith =>
      __$$TemporaryMediaImplCopyWithImpl<_$TemporaryMediaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemporaryMediaImplToJson(
      this,
    );
  }
}

abstract class _TemporaryMedia extends TemporaryMedia {
  const factory _TemporaryMedia(
      {@JsonKey(
          fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
      required final Object id,
      final String? uuid,
      @JsonKey(name: 'thumb_url') final String? thumbUrl,
      required final String url}) = _$TemporaryMediaImpl;
  const _TemporaryMedia._() : super._();

  factory _TemporaryMedia.fromJson(Map<String, dynamic> json) =
      _$TemporaryMediaImpl.fromJson;

  @override
  @JsonKey(fromJson: temporaryMediaIdFromJson, toJson: temporaryMediaIdToJson)
  Object get id;
  @override
  String? get uuid;
  @override
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$TemporaryMediaImplCopyWith<_$TemporaryMediaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
