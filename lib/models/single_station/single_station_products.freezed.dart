// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_station_products.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SingleStationSample _$SingleStationSampleFromJson(Map<String, dynamic> json) {
  return _StationSample.fromJson(json);
}

/// @nodoc
mixin _$SingleStationSample {
  int? get id => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  bool? get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  int? get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_id')
  int? get sampleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_id')
  int? get quoteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'showroomSample')
  Sample? get showroomSample => throw _privateConstructorUsedError;
  Quote? get supplyQuote => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SingleStationSampleCopyWith<SingleStationSample> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleStationSampleCopyWith<$Res> {
  factory $SingleStationSampleCopyWith(
          SingleStationSample value, $Res Function(SingleStationSample) then) =
      _$SingleStationSampleCopyWithImpl<$Res, SingleStationSample>;
  @useResult
  $Res call(
      {int? id,
      int? qty,
      int? price,
      bool? active,
      @JsonKey(name: 'station_id') int? stationId,
      @JsonKey(name: 'sample_id') int? sampleId,
      @JsonKey(name: 'quote_id') int? quoteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'showroomSample') Sample? showroomSample,
      Quote? supplyQuote});

  $SampleCopyWith<$Res>? get showroomSample;
  $QuoteCopyWith<$Res>? get supplyQuote;
}

/// @nodoc
class _$SingleStationSampleCopyWithImpl<$Res, $Val extends SingleStationSample>
    implements $SingleStationSampleCopyWith<$Res> {
  _$SingleStationSampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? qty = freezed,
    Object? price = freezed,
    Object? active = freezed,
    Object? stationId = freezed,
    Object? sampleId = freezed,
    Object? quoteId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? showroomSample = freezed,
    Object? supplyQuote = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      stationId: freezed == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleId: freezed == sampleId
          ? _value.sampleId
          : sampleId // ignore: cast_nullable_to_non_nullable
              as int?,
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      showroomSample: freezed == showroomSample
          ? _value.showroomSample
          : showroomSample // ignore: cast_nullable_to_non_nullable
              as Sample?,
      supplyQuote: freezed == supplyQuote
          ? _value.supplyQuote
          : supplyQuote // ignore: cast_nullable_to_non_nullable
              as Quote?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCopyWith<$Res>? get showroomSample {
    if (_value.showroomSample == null) {
      return null;
    }

    return $SampleCopyWith<$Res>(_value.showroomSample!, (value) {
      return _then(_value.copyWith(showroomSample: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QuoteCopyWith<$Res>? get supplyQuote {
    if (_value.supplyQuote == null) {
      return null;
    }

    return $QuoteCopyWith<$Res>(_value.supplyQuote!, (value) {
      return _then(_value.copyWith(supplyQuote: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StationSampleImplCopyWith<$Res>
    implements $SingleStationSampleCopyWith<$Res> {
  factory _$$StationSampleImplCopyWith(
          _$StationSampleImpl value, $Res Function(_$StationSampleImpl) then) =
      __$$StationSampleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? qty,
      int? price,
      bool? active,
      @JsonKey(name: 'station_id') int? stationId,
      @JsonKey(name: 'sample_id') int? sampleId,
      @JsonKey(name: 'quote_id') int? quoteId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'showroomSample') Sample? showroomSample,
      Quote? supplyQuote});

  @override
  $SampleCopyWith<$Res>? get showroomSample;
  @override
  $QuoteCopyWith<$Res>? get supplyQuote;
}

/// @nodoc
class __$$StationSampleImplCopyWithImpl<$Res>
    extends _$SingleStationSampleCopyWithImpl<$Res, _$StationSampleImpl>
    implements _$$StationSampleImplCopyWith<$Res> {
  __$$StationSampleImplCopyWithImpl(
      _$StationSampleImpl _value, $Res Function(_$StationSampleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? qty = freezed,
    Object? price = freezed,
    Object? active = freezed,
    Object? stationId = freezed,
    Object? sampleId = freezed,
    Object? quoteId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? showroomSample = freezed,
    Object? supplyQuote = freezed,
  }) {
    return _then(_$StationSampleImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      stationId: freezed == stationId
          ? _value.stationId
          : stationId // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleId: freezed == sampleId
          ? _value.sampleId
          : sampleId // ignore: cast_nullable_to_non_nullable
              as int?,
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      showroomSample: freezed == showroomSample
          ? _value.showroomSample
          : showroomSample // ignore: cast_nullable_to_non_nullable
              as Sample?,
      supplyQuote: freezed == supplyQuote
          ? _value.supplyQuote
          : supplyQuote // ignore: cast_nullable_to_non_nullable
              as Quote?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StationSampleImpl implements _StationSample {
  _$StationSampleImpl(
      {this.id,
      this.qty,
      this.price,
      this.active,
      @JsonKey(name: 'station_id') this.stationId,
      @JsonKey(name: 'sample_id') this.sampleId,
      @JsonKey(name: 'quote_id') this.quoteId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'showroomSample') this.showroomSample,
      this.supplyQuote});

  factory _$StationSampleImpl.fromJson(Map<String, dynamic> json) =>
      _$$StationSampleImplFromJson(json);

  @override
  final int? id;
  @override
  final int? qty;
  @override
  final int? price;
  @override
  final bool? active;
  @override
  @JsonKey(name: 'station_id')
  final int? stationId;
  @override
  @JsonKey(name: 'sample_id')
  final int? sampleId;
  @override
  @JsonKey(name: 'quote_id')
  final int? quoteId;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'showroomSample')
  final Sample? showroomSample;
  @override
  final Quote? supplyQuote;

  @override
  String toString() {
    return 'SingleStationSample(id: $id, qty: $qty, price: $price, active: $active, stationId: $stationId, sampleId: $sampleId, quoteId: $quoteId, createdAt: $createdAt, updatedAt: $updatedAt, showroomSample: $showroomSample, supplyQuote: $supplyQuote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationSampleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.sampleId, sampleId) ||
                other.sampleId == sampleId) &&
            (identical(other.quoteId, quoteId) || other.quoteId == quoteId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.showroomSample, showroomSample) ||
                other.showroomSample == showroomSample) &&
            (identical(other.supplyQuote, supplyQuote) ||
                other.supplyQuote == supplyQuote));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      qty,
      price,
      active,
      stationId,
      sampleId,
      quoteId,
      createdAt,
      updatedAt,
      showroomSample,
      supplyQuote);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StationSampleImplCopyWith<_$StationSampleImpl> get copyWith =>
      __$$StationSampleImplCopyWithImpl<_$StationSampleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StationSampleImplToJson(
      this,
    );
  }
}

abstract class _StationSample implements SingleStationSample {
  factory _StationSample(
      {final int? id,
      final int? qty,
      final int? price,
      final bool? active,
      @JsonKey(name: 'station_id') final int? stationId,
      @JsonKey(name: 'sample_id') final int? sampleId,
      @JsonKey(name: 'quote_id') final int? quoteId,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'showroomSample') final Sample? showroomSample,
      final Quote? supplyQuote}) = _$StationSampleImpl;

  factory _StationSample.fromJson(Map<String, dynamic> json) =
      _$StationSampleImpl.fromJson;

  @override
  int? get id;
  @override
  int? get qty;
  @override
  int? get price;
  @override
  bool? get active;
  @override
  @JsonKey(name: 'station_id')
  int? get stationId;
  @override
  @JsonKey(name: 'sample_id')
  int? get sampleId;
  @override
  @JsonKey(name: 'quote_id')
  int? get quoteId;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'showroomSample')
  Sample? get showroomSample;
  @override
  Quote? get supplyQuote;
  @override
  @JsonKey(ignore: true)
  _$$StationSampleImplCopyWith<_$StationSampleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
