// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_dynamic_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InspectionDynamicTemplate _$InspectionDynamicTemplateFromJson(
    Map<String, dynamic> json) {
  return _InspectionDynamicTemplate.fromJson(json);
}

/// @nodoc
mixin _$InspectionDynamicTemplate {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_scope')
  String? get inspectionScope => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InspectionDynamicTemplateCopyWith<InspectionDynamicTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionDynamicTemplateCopyWith<$Res> {
  factory $InspectionDynamicTemplateCopyWith(InspectionDynamicTemplate value,
          $Res Function(InspectionDynamicTemplate) then) =
      _$InspectionDynamicTemplateCopyWithImpl<$Res, InspectionDynamicTemplate>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: 'inspection_scope') String? inspectionScope});
}

/// @nodoc
class _$InspectionDynamicTemplateCopyWithImpl<$Res,
        $Val extends InspectionDynamicTemplate>
    implements $InspectionDynamicTemplateCopyWith<$Res> {
  _$InspectionDynamicTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? inspectionScope = freezed,
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
      inspectionScope: freezed == inspectionScope
          ? _value.inspectionScope
          : inspectionScope // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InspectionDynamicTemplateImplCopyWith<$Res>
    implements $InspectionDynamicTemplateCopyWith<$Res> {
  factory _$$InspectionDynamicTemplateImplCopyWith(
          _$InspectionDynamicTemplateImpl value,
          $Res Function(_$InspectionDynamicTemplateImpl) then) =
      __$$InspectionDynamicTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: 'inspection_scope') String? inspectionScope});
}

/// @nodoc
class __$$InspectionDynamicTemplateImplCopyWithImpl<$Res>
    extends _$InspectionDynamicTemplateCopyWithImpl<$Res,
        _$InspectionDynamicTemplateImpl>
    implements _$$InspectionDynamicTemplateImplCopyWith<$Res> {
  __$$InspectionDynamicTemplateImplCopyWithImpl(
      _$InspectionDynamicTemplateImpl _value,
      $Res Function(_$InspectionDynamicTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? inspectionScope = freezed,
  }) {
    return _then(_$InspectionDynamicTemplateImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionScope: freezed == inspectionScope
          ? _value.inspectionScope
          : inspectionScope // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionDynamicTemplateImpl implements _InspectionDynamicTemplate {
  _$InspectionDynamicTemplateImpl(
      {this.id,
      this.name,
      @JsonKey(name: 'inspection_scope') this.inspectionScope});

  factory _$InspectionDynamicTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionDynamicTemplateImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'inspection_scope')
  final String? inspectionScope;

  @override
  String toString() {
    return 'InspectionDynamicTemplate(id: $id, name: $name, inspectionScope: $inspectionScope)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionDynamicTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inspectionScope, inspectionScope) ||
                other.inspectionScope == inspectionScope));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, inspectionScope);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionDynamicTemplateImplCopyWith<_$InspectionDynamicTemplateImpl>
      get copyWith => __$$InspectionDynamicTemplateImplCopyWithImpl<
          _$InspectionDynamicTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionDynamicTemplateImplToJson(
      this,
    );
  }
}

abstract class _InspectionDynamicTemplate implements InspectionDynamicTemplate {
  factory _InspectionDynamicTemplate(
          {final int? id,
          final String? name,
          @JsonKey(name: 'inspection_scope') final String? inspectionScope}) =
      _$InspectionDynamicTemplateImpl;

  factory _InspectionDynamicTemplate.fromJson(Map<String, dynamic> json) =
      _$InspectionDynamicTemplateImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'inspection_scope')
  String? get inspectionScope;
  @override
  @JsonKey(ignore: true)
  _$$InspectionDynamicTemplateImplCopyWith<_$InspectionDynamicTemplateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
