// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FieldConfig _$FieldConfigFromJson(Map<String, dynamic> json) {
  return _FieldConfig.fromJson(json);
}

/// @nodoc
mixin _$FieldConfig {
  String get label => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FieldConfigCopyWith<FieldConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldConfigCopyWith<$Res> {
  factory $FieldConfigCopyWith(
          FieldConfig value, $Res Function(FieldConfig) then) =
      _$FieldConfigCopyWithImpl<$Res, FieldConfig>;
  @useResult
  $Res call({String label, String name, bool isVisible});
}

/// @nodoc
class _$FieldConfigCopyWithImpl<$Res, $Val extends FieldConfig>
    implements $FieldConfigCopyWith<$Res> {
  _$FieldConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? name = null,
    Object? isVisible = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldConfigImplCopyWith<$Res>
    implements $FieldConfigCopyWith<$Res> {
  factory _$$FieldConfigImplCopyWith(
          _$FieldConfigImpl value, $Res Function(_$FieldConfigImpl) then) =
      __$$FieldConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String name, bool isVisible});
}

/// @nodoc
class __$$FieldConfigImplCopyWithImpl<$Res>
    extends _$FieldConfigCopyWithImpl<$Res, _$FieldConfigImpl>
    implements _$$FieldConfigImplCopyWith<$Res> {
  __$$FieldConfigImplCopyWithImpl(
      _$FieldConfigImpl _value, $Res Function(_$FieldConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? name = null,
    Object? isVisible = null,
  }) {
    return _then(_$FieldConfigImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldConfigImpl implements _FieldConfig {
  const _$FieldConfigImpl(
      {required this.label, required this.name, this.isVisible = true});

  factory _$FieldConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldConfigImplFromJson(json);

  @override
  final String label;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isVisible;

  @override
  String toString() {
    return 'FieldConfig(label: $label, name: $name, isVisible: $isVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldConfigImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, name, isVisible);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldConfigImplCopyWith<_$FieldConfigImpl> get copyWith =>
      __$$FieldConfigImplCopyWithImpl<_$FieldConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldConfigImplToJson(
      this,
    );
  }
}

abstract class _FieldConfig implements FieldConfig {
  const factory _FieldConfig(
      {required final String label,
      required final String name,
      final bool isVisible}) = _$FieldConfigImpl;

  factory _FieldConfig.fromJson(Map<String, dynamic> json) =
      _$FieldConfigImpl.fromJson;

  @override
  String get label;
  @override
  String get name;
  @override
  bool get isVisible;
  @override
  @JsonKey(ignore: true)
  _$$FieldConfigImplCopyWith<_$FieldConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
