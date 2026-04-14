// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InspectionItem _$InspectionItemFromJson(Map<String, dynamic> json) {
  return _InspectionItem.fromJson(json);
}

/// @nodoc
mixin _$InspectionItem {
  int? get id => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  int? get ctns => throw _privateConstructorUsedError;
  int? get qty => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  List<Media>? get media => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_id')
  int? get sampleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_no')
  String? get itemNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_per_ctn')
  int? get unitPerCtn => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InspectionItemCopyWith<InspectionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionItemCopyWith<$Res> {
  factory $InspectionItemCopyWith(
          InspectionItem value, $Res Function(InspectionItem) then) =
      _$InspectionItemCopyWithImpl<$Res, InspectionItem>;
  @useResult
  $Res call(
      {int? id,
      int? type,
      String? name,
      int? status,
      int? ctns,
      int? qty,
      String? remark,
      String? barcode,
      List<Media>? media,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'sample_id') int? sampleId,
      @JsonKey(name: 'item_no') String? itemNo,
      @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$InspectionItemCopyWithImpl<$Res, $Val extends InspectionItem>
    implements $InspectionItemCopyWith<$Res> {
  _$InspectionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? ctns = freezed,
    Object? qty = freezed,
    Object? remark = freezed,
    Object? barcode = freezed,
    Object? media = freezed,
    Object? taskId = freezed,
    Object? userId = freezed,
    Object? sampleId = freezed,
    Object? itemNo = freezed,
    Object? unitPerCtn = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      ctns: freezed == ctns
          ? _value.ctns
          : ctns // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleId: freezed == sampleId
          ? _value.sampleId
          : sampleId // ignore: cast_nullable_to_non_nullable
              as int?,
      itemNo: freezed == itemNo
          ? _value.itemNo
          : itemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPerCtn: freezed == unitPerCtn
          ? _value.unitPerCtn
          : unitPerCtn // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InspectionItemImplCopyWith<$Res>
    implements $InspectionItemCopyWith<$Res> {
  factory _$$InspectionItemImplCopyWith(_$InspectionItemImpl value,
          $Res Function(_$InspectionItemImpl) then) =
      __$$InspectionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? type,
      String? name,
      int? status,
      int? ctns,
      int? qty,
      String? remark,
      String? barcode,
      List<Media>? media,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'sample_id') int? sampleId,
      @JsonKey(name: 'item_no') String? itemNo,
      @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$InspectionItemImplCopyWithImpl<$Res>
    extends _$InspectionItemCopyWithImpl<$Res, _$InspectionItemImpl>
    implements _$$InspectionItemImplCopyWith<$Res> {
  __$$InspectionItemImplCopyWithImpl(
      _$InspectionItemImpl _value, $Res Function(_$InspectionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? name = freezed,
    Object? status = freezed,
    Object? ctns = freezed,
    Object? qty = freezed,
    Object? remark = freezed,
    Object? barcode = freezed,
    Object? media = freezed,
    Object? taskId = freezed,
    Object? userId = freezed,
    Object? sampleId = freezed,
    Object? itemNo = freezed,
    Object? unitPerCtn = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$InspectionItemImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == ctns
          ? _value.ctns
          : ctns // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == sampleId
          ? _value.sampleId
          : sampleId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == itemNo
          ? _value.itemNo
          : itemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == unitPerCtn
          ? _value.unitPerCtn
          : unitPerCtn // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionItemImpl implements _InspectionItem {
  _$InspectionItemImpl(
      this.id,
      this.type,
      this.name,
      this.status,
      this.ctns,
      this.qty,
      this.remark,
      this.barcode,
      final List<Media>? media,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'sample_id') this.sampleId,
      @JsonKey(name: 'item_no') this.itemNo,
      @JsonKey(name: 'unit_per_ctn') this.unitPerCtn,
      @JsonKey(name: 'created_at') this.createdAt)
      : _media = media;

  factory _$InspectionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionItemImplFromJson(json);

  @override
  final int? id;
  @override
  final int? type;
  @override
  final String? name;
  @override
  final int? status;
  @override
  final int? ctns;
  @override
  final int? qty;
  @override
  final String? remark;
  @override
  final String? barcode;
  final List<Media>? _media;
  @override
  List<Media>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'sample_id')
  final int? sampleId;
  @override
  @JsonKey(name: 'item_no')
  final String? itemNo;
  @override
  @JsonKey(name: 'unit_per_ctn')
  final int? unitPerCtn;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'InspectionItem(id: $id, type: $type, name: $name, status: $status, ctns: $ctns, qty: $qty, remark: $remark, barcode: $barcode, media: $media, taskId: $taskId, userId: $userId, sampleId: $sampleId, itemNo: $itemNo, unitPerCtn: $unitPerCtn, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.ctns, ctns) || other.ctns == ctns) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sampleId, sampleId) ||
                other.sampleId == sampleId) &&
            (identical(other.itemNo, itemNo) || other.itemNo == itemNo) &&
            (identical(other.unitPerCtn, unitPerCtn) ||
                other.unitPerCtn == unitPerCtn) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      status,
      ctns,
      qty,
      remark,
      barcode,
      const DeepCollectionEquality().hash(_media),
      taskId,
      userId,
      sampleId,
      itemNo,
      unitPerCtn,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      __$$InspectionItemImplCopyWithImpl<_$InspectionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionItemImplToJson(
      this,
    );
  }
}

abstract class _InspectionItem implements InspectionItem {
  factory _InspectionItem(
          final int? id,
          final int? type,
          final String? name,
          final int? status,
          final int? ctns,
          final int? qty,
          final String? remark,
          final String? barcode,
          final List<Media>? media,
          @JsonKey(name: 'task_id') final int? taskId,
          @JsonKey(name: 'user_id') final int? userId,
          @JsonKey(name: 'sample_id') final int? sampleId,
          @JsonKey(name: 'item_no') final String? itemNo,
          @JsonKey(name: 'unit_per_ctn') final int? unitPerCtn,
          @JsonKey(name: 'created_at') final String? createdAt) =
      _$InspectionItemImpl;

  factory _InspectionItem.fromJson(Map<String, dynamic> json) =
      _$InspectionItemImpl.fromJson;

  @override
  int? get id;
  @override
  int? get type;
  @override
  String? get name;
  @override
  int? get status;
  @override
  int? get ctns;
  @override
  int? get qty;
  @override
  String? get remark;
  @override
  String? get barcode;
  @override
  List<Media>? get media;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'sample_id')
  int? get sampleId;
  @override
  @JsonKey(name: 'item_no')
  String? get itemNo;
  @override
  @JsonKey(name: 'unit_per_ctn')
  int? get unitPerCtn;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
