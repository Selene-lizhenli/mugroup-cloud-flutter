// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Inspection _$InspectionFromJson(Map<String, dynamic> json) {
  return _Inspection.fromJson(json);
}

/// @nodoc
mixin _$Inspection {
  int? get id => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  List<User>? get collaborators => throw _privateConstructorUsedError;
  List<InspectionItem>? get items => throw _privateConstructorUsedError;
  List<Media>? get media => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'inspection_dynamic_template_id',
      fromJson: _inspectionDynamicTemplateIdFromJson,
      toJson: _inspectionDynamicTemplateIdToJson)
  int? get inspectionDynamicTemplateId => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'inspection_dynamic_template_json',
      fromJson: _inspectionDynamicTemplateJsonFromJson,
      toJson: _inspectionDynamicTemplateJsonToJson)
  Map<String, dynamic>? get inspectionDynamicTemplateJson =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_dynamic_template')
  InspectionDynamicTemplate? get inspectionDynamicTemplate =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InspectionCopyWith<Inspection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionCopyWith<$Res> {
  factory $InspectionCopyWith(
          Inspection value, $Res Function(Inspection) then) =
      _$InspectionCopyWithImpl<$Res, Inspection>;
  @useResult
  $Res call(
      {int? id,
      int? type,
      String? name,
      String? remark,
      String? notes,
      int? status,
      User? user,
      List<User>? collaborators,
      List<InspectionItem>? items,
      List<Media>? media,
      @JsonKey(
          name: 'inspection_dynamic_template_id',
          fromJson: _inspectionDynamicTemplateIdFromJson,
          toJson: _inspectionDynamicTemplateIdToJson)
      int? inspectionDynamicTemplateId,
      @JsonKey(
          name: 'inspection_dynamic_template_json',
          fromJson: _inspectionDynamicTemplateJsonFromJson,
          toJson: _inspectionDynamicTemplateJsonToJson)
      Map<String, dynamic>? inspectionDynamicTemplateJson,
      @JsonKey(name: 'inspection_dynamic_template')
      InspectionDynamicTemplate? inspectionDynamicTemplate,
      @JsonKey(name: 'created_at') String? createdAt});

  $UserCopyWith<$Res>? get user;
  $InspectionDynamicTemplateCopyWith<$Res>? get inspectionDynamicTemplate;
}

/// @nodoc
class _$InspectionCopyWithImpl<$Res, $Val extends Inspection>
    implements $InspectionCopyWith<$Res> {
  _$InspectionCopyWithImpl(this._value, this._then);

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
    Object? remark = freezed,
    Object? notes = freezed,
    Object? status = freezed,
    Object? user = freezed,
    Object? collaborators = freezed,
    Object? items = freezed,
    Object? media = freezed,
    Object? inspectionDynamicTemplateId = freezed,
    Object? inspectionDynamicTemplateJson = freezed,
    Object? inspectionDynamicTemplate = freezed,
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
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      collaborators: freezed == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InspectionItem>?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      inspectionDynamicTemplateId: freezed == inspectionDynamicTemplateId
          ? _value.inspectionDynamicTemplateId
          : inspectionDynamicTemplateId // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectionDynamicTemplateJson: freezed == inspectionDynamicTemplateJson
          ? _value.inspectionDynamicTemplateJson
          : inspectionDynamicTemplateJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      inspectionDynamicTemplate: freezed == inspectionDynamicTemplate
          ? _value.inspectionDynamicTemplate
          : inspectionDynamicTemplate // ignore: cast_nullable_to_non_nullable
              as InspectionDynamicTemplate?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $InspectionDynamicTemplateCopyWith<$Res>? get inspectionDynamicTemplate {
    if (_value.inspectionDynamicTemplate == null) {
      return null;
    }

    return $InspectionDynamicTemplateCopyWith<$Res>(
        _value.inspectionDynamicTemplate!, (value) {
      return _then(_value.copyWith(inspectionDynamicTemplate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InspectionImplCopyWith<$Res>
    implements $InspectionCopyWith<$Res> {
  factory _$$InspectionImplCopyWith(
          _$InspectionImpl value, $Res Function(_$InspectionImpl) then) =
      __$$InspectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? type,
      String? name,
      String? remark,
      String? notes,
      int? status,
      User? user,
      List<User>? collaborators,
      List<InspectionItem>? items,
      List<Media>? media,
      @JsonKey(
          name: 'inspection_dynamic_template_id',
          fromJson: _inspectionDynamicTemplateIdFromJson,
          toJson: _inspectionDynamicTemplateIdToJson)
      int? inspectionDynamicTemplateId,
      @JsonKey(
          name: 'inspection_dynamic_template_json',
          fromJson: _inspectionDynamicTemplateJsonFromJson,
          toJson: _inspectionDynamicTemplateJsonToJson)
      Map<String, dynamic>? inspectionDynamicTemplateJson,
      @JsonKey(name: 'inspection_dynamic_template')
      InspectionDynamicTemplate? inspectionDynamicTemplate,
      @JsonKey(name: 'created_at') String? createdAt});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $InspectionDynamicTemplateCopyWith<$Res>? get inspectionDynamicTemplate;
}

/// @nodoc
class __$$InspectionImplCopyWithImpl<$Res>
    extends _$InspectionCopyWithImpl<$Res, _$InspectionImpl>
    implements _$$InspectionImplCopyWith<$Res> {
  __$$InspectionImplCopyWithImpl(
      _$InspectionImpl _value, $Res Function(_$InspectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? name = freezed,
    Object? remark = freezed,
    Object? notes = freezed,
    Object? status = freezed,
    Object? user = freezed,
    Object? collaborators = freezed,
    Object? items = freezed,
    Object? media = freezed,
    Object? inspectionDynamicTemplateId = freezed,
    Object? inspectionDynamicTemplateJson = freezed,
    Object? inspectionDynamicTemplate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$InspectionImpl(
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
      freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      freezed == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InspectionItem>?,
      freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>?,
      freezed == inspectionDynamicTemplateId
          ? _value.inspectionDynamicTemplateId
          : inspectionDynamicTemplateId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == inspectionDynamicTemplateJson
          ? _value._inspectionDynamicTemplateJson
          : inspectionDynamicTemplateJson // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      freezed == inspectionDynamicTemplate
          ? _value.inspectionDynamicTemplate
          : inspectionDynamicTemplate // ignore: cast_nullable_to_non_nullable
              as InspectionDynamicTemplate?,
      freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionImpl implements _Inspection {
  _$InspectionImpl(
      this.id,
      this.type,
      this.name,
      this.remark,
      this.notes,
      this.status,
      this.user,
      final List<User>? collaborators,
      final List<InspectionItem>? items,
      final List<Media>? media,
      @JsonKey(
          name: 'inspection_dynamic_template_id',
          fromJson: _inspectionDynamicTemplateIdFromJson,
          toJson: _inspectionDynamicTemplateIdToJson)
      this.inspectionDynamicTemplateId,
      @JsonKey(
          name: 'inspection_dynamic_template_json',
          fromJson: _inspectionDynamicTemplateJsonFromJson,
          toJson: _inspectionDynamicTemplateJsonToJson)
      final Map<String, dynamic>? inspectionDynamicTemplateJson,
      @JsonKey(name: 'inspection_dynamic_template')
      this.inspectionDynamicTemplate,
      @JsonKey(name: 'created_at') this.createdAt)
      : _collaborators = collaborators,
        _items = items,
        _media = media,
        _inspectionDynamicTemplateJson = inspectionDynamicTemplateJson;

  factory _$InspectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionImplFromJson(json);

  @override
  final int? id;
  @override
  final int? type;
  @override
  final String? name;
  @override
  final String? remark;
  @override
  final String? notes;
  @override
  final int? status;
  @override
  final User? user;
  final List<User>? _collaborators;
  @override
  List<User>? get collaborators {
    final value = _collaborators;
    if (value == null) return null;
    if (_collaborators is EqualUnmodifiableListView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<InspectionItem>? _items;
  @override
  List<InspectionItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  @JsonKey(
      name: 'inspection_dynamic_template_id',
      fromJson: _inspectionDynamicTemplateIdFromJson,
      toJson: _inspectionDynamicTemplateIdToJson)
  final int? inspectionDynamicTemplateId;
  final Map<String, dynamic>? _inspectionDynamicTemplateJson;
  @override
  @JsonKey(
      name: 'inspection_dynamic_template_json',
      fromJson: _inspectionDynamicTemplateJsonFromJson,
      toJson: _inspectionDynamicTemplateJsonToJson)
  Map<String, dynamic>? get inspectionDynamicTemplateJson {
    final value = _inspectionDynamicTemplateJson;
    if (value == null) return null;
    if (_inspectionDynamicTemplateJson is EqualUnmodifiableMapView)
      return _inspectionDynamicTemplateJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'inspection_dynamic_template')
  final InspectionDynamicTemplate? inspectionDynamicTemplate;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'Inspection(id: $id, type: $type, name: $name, remark: $remark, notes: $notes, status: $status, user: $user, collaborators: $collaborators, items: $items, media: $media, inspectionDynamicTemplateId: $inspectionDynamicTemplateId, inspectionDynamicTemplateJson: $inspectionDynamicTemplateJson, inspectionDynamicTemplate: $inspectionDynamicTemplate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.inspectionDynamicTemplateId,
                    inspectionDynamicTemplateId) ||
                other.inspectionDynamicTemplateId ==
                    inspectionDynamicTemplateId) &&
            const DeepCollectionEquality().equals(
                other._inspectionDynamicTemplateJson,
                _inspectionDynamicTemplateJson) &&
            (identical(other.inspectionDynamicTemplate,
                    inspectionDynamicTemplate) ||
                other.inspectionDynamicTemplate == inspectionDynamicTemplate) &&
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
      remark,
      notes,
      status,
      user,
      const DeepCollectionEquality().hash(_collaborators),
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_media),
      inspectionDynamicTemplateId,
      const DeepCollectionEquality().hash(_inspectionDynamicTemplateJson),
      inspectionDynamicTemplate,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionImplCopyWith<_$InspectionImpl> get copyWith =>
      __$$InspectionImplCopyWithImpl<_$InspectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionImplToJson(
      this,
    );
  }
}

abstract class _Inspection implements Inspection {
  factory _Inspection(
      final int? id,
      final int? type,
      final String? name,
      final String? remark,
      final String? notes,
      final int? status,
      final User? user,
      final List<User>? collaborators,
      final List<InspectionItem>? items,
      final List<Media>? media,
      @JsonKey(
          name: 'inspection_dynamic_template_id',
          fromJson: _inspectionDynamicTemplateIdFromJson,
          toJson: _inspectionDynamicTemplateIdToJson)
      final int? inspectionDynamicTemplateId,
      @JsonKey(
          name: 'inspection_dynamic_template_json',
          fromJson: _inspectionDynamicTemplateJsonFromJson,
          toJson: _inspectionDynamicTemplateJsonToJson)
      final Map<String, dynamic>? inspectionDynamicTemplateJson,
      @JsonKey(name: 'inspection_dynamic_template')
      final InspectionDynamicTemplate? inspectionDynamicTemplate,
      @JsonKey(name: 'created_at') final String? createdAt) = _$InspectionImpl;

  factory _Inspection.fromJson(Map<String, dynamic> json) =
      _$InspectionImpl.fromJson;

  @override
  int? get id;
  @override
  int? get type;
  @override
  String? get name;
  @override
  String? get remark;
  @override
  String? get notes;
  @override
  int? get status;
  @override
  User? get user;
  @override
  List<User>? get collaborators;
  @override
  List<InspectionItem>? get items;
  @override
  List<Media>? get media;
  @override
  @JsonKey(
      name: 'inspection_dynamic_template_id',
      fromJson: _inspectionDynamicTemplateIdFromJson,
      toJson: _inspectionDynamicTemplateIdToJson)
  int? get inspectionDynamicTemplateId;
  @override
  @JsonKey(
      name: 'inspection_dynamic_template_json',
      fromJson: _inspectionDynamicTemplateJsonFromJson,
      toJson: _inspectionDynamicTemplateJsonToJson)
  Map<String, dynamic>? get inspectionDynamicTemplateJson;
  @override
  @JsonKey(name: 'inspection_dynamic_template')
  InspectionDynamicTemplate? get inspectionDynamicTemplate;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$InspectionImplCopyWith<_$InspectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
