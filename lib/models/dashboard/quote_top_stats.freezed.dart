// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_top_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteTopStats _$QuoteTopStatsFromJson(Map<String, dynamic> json) {
  return _QuoteTopStats.fromJson(json);
}

/// @nodoc
mixin _$QuoteTopStats {
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_no')
  String? get sampleNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  int? get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_name')
  String? get sampleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError; // 样品ID，用于跳转详情页
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuoteTopStatsCopyWith<QuoteTopStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteTopStatsCopyWith<$Res> {
  factory $QuoteTopStatsCopyWith(
          QuoteTopStats value, $Res Function(QuoteTopStats) then) =
      _$QuoteTopStatsCopyWithImpl<$Res, QuoteTopStats>;
  @useResult
  $Res call(
      {String? name,
      @JsonKey(name: 'sample_no') String? sampleNo,
      @JsonKey(name: 'count') int? count,
      @JsonKey(name: 'sample_name') String? sampleName,
      @JsonKey(name: 'id') int? id,
      @JsonKey(name: 'thumb_url') String? thumbUrl});
}

/// @nodoc
class _$QuoteTopStatsCopyWithImpl<$Res, $Val extends QuoteTopStats>
    implements $QuoteTopStatsCopyWith<$Res> {
  _$QuoteTopStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? sampleNo = freezed,
    Object? count = freezed,
    Object? sampleName = freezed,
    Object? id = freezed,
    Object? thumbUrl = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleNo: freezed == sampleNo
          ? _value.sampleNo
          : sampleNo // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleName: freezed == sampleName
          ? _value.sampleName
          : sampleName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteTopStatsImplCopyWith<$Res>
    implements $QuoteTopStatsCopyWith<$Res> {
  factory _$$QuoteTopStatsImplCopyWith(
          _$QuoteTopStatsImpl value, $Res Function(_$QuoteTopStatsImpl) then) =
      __$$QuoteTopStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      @JsonKey(name: 'sample_no') String? sampleNo,
      @JsonKey(name: 'count') int? count,
      @JsonKey(name: 'sample_name') String? sampleName,
      @JsonKey(name: 'id') int? id,
      @JsonKey(name: 'thumb_url') String? thumbUrl});
}

/// @nodoc
class __$$QuoteTopStatsImplCopyWithImpl<$Res>
    extends _$QuoteTopStatsCopyWithImpl<$Res, _$QuoteTopStatsImpl>
    implements _$$QuoteTopStatsImplCopyWith<$Res> {
  __$$QuoteTopStatsImplCopyWithImpl(
      _$QuoteTopStatsImpl _value, $Res Function(_$QuoteTopStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? sampleNo = freezed,
    Object? count = freezed,
    Object? sampleName = freezed,
    Object? id = freezed,
    Object? thumbUrl = freezed,
  }) {
    return _then(_$QuoteTopStatsImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleNo: freezed == sampleNo
          ? _value.sampleNo
          : sampleNo // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleName: freezed == sampleName
          ? _value.sampleName
          : sampleName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      thumbUrl: freezed == thumbUrl
          ? _value.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteTopStatsImpl implements _QuoteTopStats {
  const _$QuoteTopStatsImpl(
      {this.name,
      @JsonKey(name: 'sample_no') this.sampleNo,
      @JsonKey(name: 'count') this.count,
      @JsonKey(name: 'sample_name') this.sampleName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'thumb_url') this.thumbUrl});

  factory _$QuoteTopStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteTopStatsImplFromJson(json);

  @override
  final String? name;
  @override
  @JsonKey(name: 'sample_no')
  final String? sampleNo;
  @override
  @JsonKey(name: 'count')
  final int? count;
  @override
  @JsonKey(name: 'sample_name')
  final String? sampleName;
  @override
  @JsonKey(name: 'id')
  final int? id;
// 样品ID，用于跳转详情页
  @override
  @JsonKey(name: 'thumb_url')
  final String? thumbUrl;

  @override
  String toString() {
    return 'QuoteTopStats(name: $name, sampleNo: $sampleNo, count: $count, sampleName: $sampleName, id: $id, thumbUrl: $thumbUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteTopStatsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sampleNo, sampleNo) ||
                other.sampleNo == sampleNo) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.sampleName, sampleName) ||
                other.sampleName == sampleName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, sampleNo, count, sampleName, id, thumbUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteTopStatsImplCopyWith<_$QuoteTopStatsImpl> get copyWith =>
      __$$QuoteTopStatsImplCopyWithImpl<_$QuoteTopStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteTopStatsImplToJson(
      this,
    );
  }
}

abstract class _QuoteTopStats implements QuoteTopStats {
  const factory _QuoteTopStats(
          {final String? name,
          @JsonKey(name: 'sample_no') final String? sampleNo,
          @JsonKey(name: 'count') final int? count,
          @JsonKey(name: 'sample_name') final String? sampleName,
          @JsonKey(name: 'id') final int? id,
          @JsonKey(name: 'thumb_url') final String? thumbUrl}) =
      _$QuoteTopStatsImpl;

  factory _QuoteTopStats.fromJson(Map<String, dynamic> json) =
      _$QuoteTopStatsImpl.fromJson;

  @override
  String? get name;
  @override
  @JsonKey(name: 'sample_no')
  String? get sampleNo;
  @override
  @JsonKey(name: 'count')
  int? get count;
  @override
  @JsonKey(name: 'sample_name')
  String? get sampleName;
  @override
  @JsonKey(name: 'id')
  int? get id;
  @override // 样品ID，用于跳转详情页
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl;
  @override
  @JsonKey(ignore: true)
  _$$QuoteTopStatsImplCopyWith<_$QuoteTopStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
