// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExportTemplate _$ExportTemplateFromJson(Map<String, dynamic> json) {
  return _ExportTemplate.fromJson(json);
}

/// @nodoc
mixin _$ExportTemplate {
  int? get id => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExportTemplateCopyWith<ExportTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportTemplateCopyWith<$Res> {
  factory $ExportTemplateCopyWith(
          ExportTemplate value, $Res Function(ExportTemplate) then) =
      _$ExportTemplateCopyWithImpl<$Res, ExportTemplate>;
  @useResult
  $Res call({int? id, String? key, String? label});
}

/// @nodoc
class _$ExportTemplateCopyWithImpl<$Res, $Val extends ExportTemplate>
    implements $ExportTemplateCopyWith<$Res> {
  _$ExportTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? key = freezed,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExportTemplateImplCopyWith<$Res>
    implements $ExportTemplateCopyWith<$Res> {
  factory _$$ExportTemplateImplCopyWith(_$ExportTemplateImpl value,
          $Res Function(_$ExportTemplateImpl) then) =
      __$$ExportTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? key, String? label});
}

/// @nodoc
class __$$ExportTemplateImplCopyWithImpl<$Res>
    extends _$ExportTemplateCopyWithImpl<$Res, _$ExportTemplateImpl>
    implements _$$ExportTemplateImplCopyWith<$Res> {
  __$$ExportTemplateImplCopyWithImpl(
      _$ExportTemplateImpl _value, $Res Function(_$ExportTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? key = freezed,
    Object? label = freezed,
  }) {
    return _then(_$ExportTemplateImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportTemplateImpl implements _ExportTemplate {
  _$ExportTemplateImpl({this.id, this.key, this.label});

  factory _$ExportTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportTemplateImplFromJson(json);

  @override
  final int? id;
  @override
  final String? key;
  @override
  final String? label;

  @override
  String toString() {
    return 'ExportTemplate(id: $id, key: $key, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportTemplateImplCopyWith<_$ExportTemplateImpl> get copyWith =>
      __$$ExportTemplateImplCopyWithImpl<_$ExportTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportTemplateImplToJson(
      this,
    );
  }
}

abstract class _ExportTemplate implements ExportTemplate {
  factory _ExportTemplate(
      {final int? id,
      final String? key,
      final String? label}) = _$ExportTemplateImpl;

  factory _ExportTemplate.fromJson(Map<String, dynamic> json) =
      _$ExportTemplateImpl.fromJson;

  @override
  int? get id;
  @override
  String? get key;
  @override
  String? get label;
  @override
  @JsonKey(ignore: true)
  _$$ExportTemplateImplCopyWith<_$ExportTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
