// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_item_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InspectionItemBatch _$InspectionItemBatchFromJson(Map<String, dynamic> json) {
  return _InspectionItemBatch.fromJson(json);
}

/// @nodoc
mixin _$InspectionItemBatch {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  int? get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_no')
  String? get batchNo => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  int? get ctns => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_per_ctn')
  int? get unitPerCtn => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
  Map<String, dynamic>? get raw => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  @JsonKey(name: 'std_barcode')
  String? get stdBarcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'scan_barcode')
  String? get scanBarcode => throw _privateConstructorUsedError;
  List<Media>? get media => throw _privateConstructorUsedError;
  @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
  List<InspectionRoundSnapshot>? get rounds =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duplicate_count')
  int? get duplicateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_no_sequence')
  int? get batchNoSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspector_name')
  String? get inspectorName => throw _privateConstructorUsedError;
  int? get round => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InspectionItemBatchCopyWith<InspectionItemBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionItemBatchCopyWith<$Res> {
  factory $InspectionItemBatchCopyWith(
          InspectionItemBatch value, $Res Function(InspectionItemBatch) then) =
      _$InspectionItemBatchCopyWithImpl<$Res, InspectionItemBatch>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'item_id') int? itemId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'batch_no') String? batchNo,
      int? status,
      int? ctns,
      @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
      int? qty,
      @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
      Map<String, dynamic>? raw,
      String? remark,
      @JsonKey(name: 'std_barcode') String? stdBarcode,
      @JsonKey(name: 'scan_barcode') String? scanBarcode,
      List<Media>? media,
      @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
      List<InspectionRoundSnapshot>? rounds,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'duplicate_count') int? duplicateCount,
      @JsonKey(name: 'batch_no_sequence') int? batchNoSequence,
      @JsonKey(name: 'inspector_name') String? inspectorName,
      int? round});
}

/// @nodoc
class _$InspectionItemBatchCopyWithImpl<$Res, $Val extends InspectionItemBatch>
    implements $InspectionItemBatchCopyWith<$Res> {
  _$InspectionItemBatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = freezed,
    Object? itemId = freezed,
    Object? userId = freezed,
    Object? batchNo = freezed,
    Object? status = freezed,
    Object? ctns = freezed,
    Object? unitPerCtn = freezed,
    Object? qty = freezed,
    Object? raw = freezed,
    Object? remark = freezed,
    Object? stdBarcode = freezed,
    Object? scanBarcode = freezed,
    Object? media = freezed,
    Object? rounds = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? duplicateCount = freezed,
    Object? batchNoSequence = freezed,
    Object? inspectorName = freezed,
    Object? round = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      ctns: freezed == ctns
          ? _value.ctns
          : ctns // ignore: cast_nullable_to_non_nullable
              as int?,
      unitPerCtn: freezed == unitPerCtn
          ? _value.unitPerCtn
          : unitPerCtn // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      raw: freezed == raw
          ? _value.raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      stdBarcode: freezed == stdBarcode
          ? _value.stdBarcode
          : stdBarcode // ignore: cast_nullable_to_non_nullable
              as String?,
      scanBarcode: freezed == scanBarcode
          ? _value.scanBarcode
          : scanBarcode // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      rounds: freezed == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<InspectionRoundSnapshot>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      duplicateCount: freezed == duplicateCount
          ? _value.duplicateCount
          : duplicateCount // ignore: cast_nullable_to_non_nullable
              as int?,
      batchNoSequence: freezed == batchNoSequence
          ? _value.batchNoSequence
          : batchNoSequence // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InspectionItemBatchImplCopyWith<$Res>
    implements $InspectionItemBatchCopyWith<$Res> {
  factory _$$InspectionItemBatchImplCopyWith(_$InspectionItemBatchImpl value,
          $Res Function(_$InspectionItemBatchImpl) then) =
      __$$InspectionItemBatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'item_id') int? itemId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'batch_no') String? batchNo,
      int? status,
      int? ctns,
      @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
      int? qty,
      @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
      Map<String, dynamic>? raw,
      String? remark,
      @JsonKey(name: 'std_barcode') String? stdBarcode,
      @JsonKey(name: 'scan_barcode') String? scanBarcode,
      List<Media>? media,
      @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
      List<InspectionRoundSnapshot>? rounds,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'duplicate_count') int? duplicateCount,
      @JsonKey(name: 'batch_no_sequence') int? batchNoSequence,
      @JsonKey(name: 'inspector_name') String? inspectorName,
      int? round});
}

/// @nodoc
class __$$InspectionItemBatchImplCopyWithImpl<$Res>
    extends _$InspectionItemBatchCopyWithImpl<$Res, _$InspectionItemBatchImpl>
    implements _$$InspectionItemBatchImplCopyWith<$Res> {
  __$$InspectionItemBatchImplCopyWithImpl(_$InspectionItemBatchImpl _value,
      $Res Function(_$InspectionItemBatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = freezed,
    Object? itemId = freezed,
    Object? userId = freezed,
    Object? batchNo = freezed,
    Object? status = freezed,
    Object? ctns = freezed,
    Object? unitPerCtn = freezed,
    Object? qty = freezed,
    Object? raw = freezed,
    Object? remark = freezed,
    Object? stdBarcode = freezed,
    Object? scanBarcode = freezed,
    Object? media = freezed,
    Object? rounds = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? duplicateCount = freezed,
    Object? batchNoSequence = freezed,
    Object? inspectorName = freezed,
    Object? round = freezed,
  }) {
    return _then(_$InspectionItemBatchImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      ctns: freezed == ctns
          ? _value.ctns
          : ctns // ignore: cast_nullable_to_non_nullable
              as int?,
      unitPerCtn: freezed == unitPerCtn
          ? _value.unitPerCtn
          : unitPerCtn // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      raw: freezed == raw
          ? _value._raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      stdBarcode: freezed == stdBarcode
          ? _value.stdBarcode
          : stdBarcode // ignore: cast_nullable_to_non_nullable
              as String?,
      scanBarcode: freezed == scanBarcode
          ? _value.scanBarcode
          : scanBarcode // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      rounds: freezed == rounds
          ? _value._rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<InspectionRoundSnapshot>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      duplicateCount: freezed == duplicateCount
          ? _value.duplicateCount
          : duplicateCount // ignore: cast_nullable_to_non_nullable
              as int?,
      batchNoSequence: freezed == batchNoSequence
          ? _value.batchNoSequence
          : batchNoSequence // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
      round: freezed == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionItemBatchImpl implements _InspectionItemBatch {
  _$InspectionItemBatchImpl(
      {this.id,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'item_id') this.itemId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'batch_no') this.batchNo,
      this.status,
      this.ctns,
      @JsonKey(name: 'unit_per_ctn') this.unitPerCtn,
      this.qty,
      @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
      final Map<String, dynamic>? raw,
      this.remark,
      @JsonKey(name: 'std_barcode') this.stdBarcode,
      @JsonKey(name: 'scan_barcode') this.scanBarcode,
      final List<Media>? media,
      @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
      final List<InspectionRoundSnapshot>? rounds,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'duplicate_count') this.duplicateCount,
      @JsonKey(name: 'batch_no_sequence') this.batchNoSequence,
      @JsonKey(name: 'inspector_name') this.inspectorName,
      this.round})
      : _raw = raw,
        _media = media,
        _rounds = rounds;

  factory _$InspectionItemBatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionItemBatchImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  @JsonKey(name: 'item_id')
  final int? itemId;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'batch_no')
  final String? batchNo;
  @override
  final int? status;
  @override
  final int? ctns;
  @override
  @JsonKey(name: 'unit_per_ctn')
  final int? unitPerCtn;
  @override
  final int? qty;
  final Map<String, dynamic>? _raw;
  @override
  @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
  Map<String, dynamic>? get raw {
    final value = _raw;
    if (value == null) return null;
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? remark;
  @override
  @JsonKey(name: 'std_barcode')
  final String? stdBarcode;
  @override
  @JsonKey(name: 'scan_barcode')
  final String? scanBarcode;
  final List<Media>? _media;
  @override
  List<Media>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<InspectionRoundSnapshot>? _rounds;
  @override
  @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
  List<InspectionRoundSnapshot>? get rounds {
    final value = _rounds;
    if (value == null) return null;
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'duplicate_count')
  final int? duplicateCount;
  @override
  @JsonKey(name: 'batch_no_sequence')
  final int? batchNoSequence;
  @override
  @JsonKey(name: 'inspector_name')
  final String? inspectorName;
  @override
  final int? round;

  @override
  String toString() {
    return 'InspectionItemBatch(id: $id, taskId: $taskId, itemId: $itemId, userId: $userId, batchNo: $batchNo, status: $status, ctns: $ctns, unitPerCtn: $unitPerCtn, qty: $qty, raw: $raw, remark: $remark, stdBarcode: $stdBarcode, scanBarcode: $scanBarcode, media: $media, rounds: $rounds, createdAt: $createdAt, updatedAt: $updatedAt, duplicateCount: $duplicateCount, batchNoSequence: $batchNoSequence, inspectorName: $inspectorName, round: $round)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionItemBatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.batchNo, batchNo) || other.batchNo == batchNo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.ctns, ctns) || other.ctns == ctns) &&
            (identical(other.unitPerCtn, unitPerCtn) ||
                other.unitPerCtn == unitPerCtn) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            const DeepCollectionEquality().equals(other._raw, _raw) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.stdBarcode, stdBarcode) ||
                other.stdBarcode == stdBarcode) &&
            (identical(other.scanBarcode, scanBarcode) ||
                other.scanBarcode == scanBarcode) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.duplicateCount, duplicateCount) ||
                other.duplicateCount == duplicateCount) &&
            (identical(other.batchNoSequence, batchNoSequence) ||
                other.batchNoSequence == batchNoSequence) &&
            (identical(other.inspectorName, inspectorName) ||
                other.inspectorName == inspectorName) &&
            (identical(other.round, round) || other.round == round));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        taskId,
        itemId,
        userId,
        batchNo,
        status,
        ctns,
        unitPerCtn,
        qty,
        const DeepCollectionEquality().hash(_raw),
        remark,
        stdBarcode,
        scanBarcode,
        const DeepCollectionEquality().hash(_media),
        const DeepCollectionEquality().hash(_rounds),
        createdAt,
        updatedAt,
        duplicateCount,
        batchNoSequence,
        inspectorName,
        round
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionItemBatchImplCopyWith<_$InspectionItemBatchImpl> get copyWith =>
      __$$InspectionItemBatchImplCopyWithImpl<_$InspectionItemBatchImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionItemBatchImplToJson(
      this,
    );
  }
}

abstract class _InspectionItemBatch implements InspectionItemBatch {
  factory _InspectionItemBatch(
      {final int? id,
      @JsonKey(name: 'task_id') final int? taskId,
      @JsonKey(name: 'item_id') final int? itemId,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'batch_no') final String? batchNo,
      final int? status,
      final int? ctns,
      @JsonKey(name: 'unit_per_ctn') final int? unitPerCtn,
      final int? qty,
      @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
      final Map<String, dynamic>? raw,
      final String? remark,
      @JsonKey(name: 'std_barcode') final String? stdBarcode,
      @JsonKey(name: 'scan_barcode') final String? scanBarcode,
      final List<Media>? media,
      @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
      final List<InspectionRoundSnapshot>? rounds,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'duplicate_count') final int? duplicateCount,
      @JsonKey(name: 'batch_no_sequence') final int? batchNoSequence,
      @JsonKey(name: 'inspector_name') final String? inspectorName,
      final int? round}) = _$InspectionItemBatchImpl;

  factory _InspectionItemBatch.fromJson(Map<String, dynamic> json) =
      _$InspectionItemBatchImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'item_id')
  int? get itemId;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'batch_no')
  String? get batchNo;
  @override
  int? get status;
  @override
  int? get ctns;
  @override
  @JsonKey(name: 'unit_per_ctn')
  int? get unitPerCtn;
  @override
  int? get qty;
  @override
  @JsonKey(fromJson: _rawMapFromJson, toJson: _rawMapToJson)
  Map<String, dynamic>? get raw;
  @override
  String? get remark;
  @override
  @JsonKey(name: 'std_barcode')
  String? get stdBarcode;
  @override
  @JsonKey(name: 'scan_barcode')
  String? get scanBarcode;
  @override
  List<Media>? get media;
  @override
  @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
  List<InspectionRoundSnapshot>? get rounds;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'duplicate_count')
  int? get duplicateCount;
  @override
  @JsonKey(name: 'batch_no_sequence')
  int? get batchNoSequence;
  @override
  @JsonKey(name: 'inspector_name')
  String? get inspectorName;
  @override
  int? get round;
  @override
  @JsonKey(ignore: true)
  _$$InspectionItemBatchImplCopyWith<_$InspectionItemBatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
