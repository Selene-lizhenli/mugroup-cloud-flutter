// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_config_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FieldConfigParams {
  String get storageKey => throw _privateConstructorUsedError; // 存储的 Key
  List<FieldConfig> get defaultFields => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FieldConfigParamsCopyWith<FieldConfigParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldConfigParamsCopyWith<$Res> {
  factory $FieldConfigParamsCopyWith(
          FieldConfigParams value, $Res Function(FieldConfigParams) then) =
      _$FieldConfigParamsCopyWithImpl<$Res, FieldConfigParams>;
  @useResult
  $Res call({String storageKey, List<FieldConfig> defaultFields});
}

/// @nodoc
class _$FieldConfigParamsCopyWithImpl<$Res, $Val extends FieldConfigParams>
    implements $FieldConfigParamsCopyWith<$Res> {
  _$FieldConfigParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storageKey = null,
    Object? defaultFields = null,
  }) {
    return _then(_value.copyWith(
      storageKey: null == storageKey
          ? _value.storageKey
          : storageKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultFields: null == defaultFields
          ? _value.defaultFields
          : defaultFields // ignore: cast_nullable_to_non_nullable
              as List<FieldConfig>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldConfigParamsImplCopyWith<$Res>
    implements $FieldConfigParamsCopyWith<$Res> {
  factory _$$FieldConfigParamsImplCopyWith(_$FieldConfigParamsImpl value,
          $Res Function(_$FieldConfigParamsImpl) then) =
      __$$FieldConfigParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storageKey, List<FieldConfig> defaultFields});
}

/// @nodoc
class __$$FieldConfigParamsImplCopyWithImpl<$Res>
    extends _$FieldConfigParamsCopyWithImpl<$Res, _$FieldConfigParamsImpl>
    implements _$$FieldConfigParamsImplCopyWith<$Res> {
  __$$FieldConfigParamsImplCopyWithImpl(_$FieldConfigParamsImpl _value,
      $Res Function(_$FieldConfigParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storageKey = null,
    Object? defaultFields = null,
  }) {
    return _then(_$FieldConfigParamsImpl(
      storageKey: null == storageKey
          ? _value.storageKey
          : storageKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultFields: null == defaultFields
          ? _value._defaultFields
          : defaultFields // ignore: cast_nullable_to_non_nullable
              as List<FieldConfig>,
    ));
  }
}

/// @nodoc

class _$FieldConfigParamsImpl
    with DiagnosticableTreeMixin
    implements _FieldConfigParams {
  const _$FieldConfigParamsImpl(
      {required this.storageKey,
      required final List<FieldConfig> defaultFields})
      : _defaultFields = defaultFields;

  @override
  final String storageKey;
// 存储的 Key
  final List<FieldConfig> _defaultFields;
// 存储的 Key
  @override
  List<FieldConfig> get defaultFields {
    if (_defaultFields is EqualUnmodifiableListView) return _defaultFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultFields);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FieldConfigParams(storageKey: $storageKey, defaultFields: $defaultFields)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FieldConfigParams'))
      ..add(DiagnosticsProperty('storageKey', storageKey))
      ..add(DiagnosticsProperty('defaultFields', defaultFields));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldConfigParamsImpl &&
            (identical(other.storageKey, storageKey) ||
                other.storageKey == storageKey) &&
            const DeepCollectionEquality()
                .equals(other._defaultFields, _defaultFields));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storageKey,
      const DeepCollectionEquality().hash(_defaultFields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldConfigParamsImplCopyWith<_$FieldConfigParamsImpl> get copyWith =>
      __$$FieldConfigParamsImplCopyWithImpl<_$FieldConfigParamsImpl>(
          this, _$identity);
}

abstract class _FieldConfigParams implements FieldConfigParams {
  const factory _FieldConfigParams(
          {required final String storageKey,
          required final List<FieldConfig> defaultFields}) =
      _$FieldConfigParamsImpl;

  @override
  String get storageKey;
  @override // 存储的 Key
  List<FieldConfig> get defaultFields;
  @override
  @JsonKey(ignore: true)
  _$$FieldConfigParamsImplCopyWith<_$FieldConfigParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
