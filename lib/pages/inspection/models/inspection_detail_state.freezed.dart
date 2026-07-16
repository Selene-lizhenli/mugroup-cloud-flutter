// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InspectionDetailState {
  int? get inspectionId => throw _privateConstructorUsedError;
  Inspection? get inspection => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get useNormalTemplate => throw _privateConstructorUsedError;
  AddSkuSubmitData? get addSkuDraft => throw _privateConstructorUsedError;
  Map<String, List<Map<String, dynamic>>?>? get dynamicZonesNodes =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get templateKeys =>
      throw _privateConstructorUsedError;
  bool get templateLoading => throw _privateConstructorUsedError;
  String? get templateLoadError => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  bool get reportPerSku => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InspectionDetailStateCopyWith<InspectionDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionDetailStateCopyWith<$Res> {
  factory $InspectionDetailStateCopyWith(InspectionDetailState value,
          $Res Function(InspectionDetailState) then) =
      _$InspectionDetailStateCopyWithImpl<$Res, InspectionDetailState>;
  @useResult
  $Res call(
      {int? inspectionId,
      Inspection? inspection,
      String? errorMessage,
      bool useNormalTemplate,
      AddSkuSubmitData? addSkuDraft,
      Map<String, List<Map<String, dynamic>>?>? dynamicZonesNodes,
      List<Map<String, dynamic>> templateKeys,
      bool templateLoading,
      String? templateLoadError,
      bool loading,
      bool reportPerSku});

  $InspectionCopyWith<$Res>? get inspection;
}

/// @nodoc
class _$InspectionDetailStateCopyWithImpl<$Res,
        $Val extends InspectionDetailState>
    implements $InspectionDetailStateCopyWith<$Res> {
  _$InspectionDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inspectionId = freezed,
    Object? inspection = freezed,
    Object? errorMessage = freezed,
    Object? useNormalTemplate = null,
    Object? addSkuDraft = freezed,
    Object? dynamicZonesNodes = freezed,
    Object? templateKeys = null,
    Object? templateLoading = null,
    Object? templateLoadError = freezed,
    Object? loading = null,
    Object? reportPerSku = null,
  }) {
    return _then(_value.copyWith(
      inspectionId: freezed == inspectionId
          ? _value.inspectionId
          : inspectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      inspection: freezed == inspection
          ? _value.inspection
          : inspection // ignore: cast_nullable_to_non_nullable
              as Inspection?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      useNormalTemplate: null == useNormalTemplate
          ? _value.useNormalTemplate
          : useNormalTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      addSkuDraft: freezed == addSkuDraft
          ? _value.addSkuDraft
          : addSkuDraft // ignore: cast_nullable_to_non_nullable
              as AddSkuSubmitData?,
      dynamicZonesNodes: freezed == dynamicZonesNodes
          ? _value.dynamicZonesNodes
          : dynamicZonesNodes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>?>?,
      templateKeys: null == templateKeys
          ? _value.templateKeys
          : templateKeys // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      templateLoading: null == templateLoading
          ? _value.templateLoading
          : templateLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      templateLoadError: freezed == templateLoadError
          ? _value.templateLoadError
          : templateLoadError // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reportPerSku: null == reportPerSku
          ? _value.reportPerSku
          : reportPerSku // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InspectionCopyWith<$Res>? get inspection {
    if (_value.inspection == null) {
      return null;
    }

    return $InspectionCopyWith<$Res>(_value.inspection!, (value) {
      return _then(_value.copyWith(inspection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InspectionDetailStateImplCopyWith<$Res>
    implements $InspectionDetailStateCopyWith<$Res> {
  factory _$$InspectionDetailStateImplCopyWith(
          _$InspectionDetailStateImpl value,
          $Res Function(_$InspectionDetailStateImpl) then) =
      __$$InspectionDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? inspectionId,
      Inspection? inspection,
      String? errorMessage,
      bool useNormalTemplate,
      AddSkuSubmitData? addSkuDraft,
      Map<String, List<Map<String, dynamic>>?>? dynamicZonesNodes,
      List<Map<String, dynamic>> templateKeys,
      bool templateLoading,
      String? templateLoadError,
      bool loading,
      bool reportPerSku});

  @override
  $InspectionCopyWith<$Res>? get inspection;
}

/// @nodoc
class __$$InspectionDetailStateImplCopyWithImpl<$Res>
    extends _$InspectionDetailStateCopyWithImpl<$Res,
        _$InspectionDetailStateImpl>
    implements _$$InspectionDetailStateImplCopyWith<$Res> {
  __$$InspectionDetailStateImplCopyWithImpl(_$InspectionDetailStateImpl _value,
      $Res Function(_$InspectionDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inspectionId = freezed,
    Object? inspection = freezed,
    Object? errorMessage = freezed,
    Object? useNormalTemplate = null,
    Object? addSkuDraft = freezed,
    Object? dynamicZonesNodes = freezed,
    Object? templateKeys = null,
    Object? templateLoading = null,
    Object? templateLoadError = freezed,
    Object? loading = null,
    Object? reportPerSku = null,
  }) {
    return _then(_$InspectionDetailStateImpl(
      inspectionId: freezed == inspectionId
          ? _value.inspectionId
          : inspectionId // ignore: cast_nullable_to_non_nullable
              as int?,
      inspection: freezed == inspection
          ? _value.inspection
          : inspection // ignore: cast_nullable_to_non_nullable
              as Inspection?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      useNormalTemplate: null == useNormalTemplate
          ? _value.useNormalTemplate
          : useNormalTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      addSkuDraft: freezed == addSkuDraft
          ? _value.addSkuDraft
          : addSkuDraft // ignore: cast_nullable_to_non_nullable
              as AddSkuSubmitData?,
      dynamicZonesNodes: freezed == dynamicZonesNodes
          ? _value._dynamicZonesNodes
          : dynamicZonesNodes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<Map<String, dynamic>>?>?,
      templateKeys: null == templateKeys
          ? _value._templateKeys
          : templateKeys // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      templateLoading: null == templateLoading
          ? _value.templateLoading
          : templateLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      templateLoadError: freezed == templateLoadError
          ? _value.templateLoadError
          : templateLoadError // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      reportPerSku: null == reportPerSku
          ? _value.reportPerSku
          : reportPerSku // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InspectionDetailStateImpl implements _InspectionDetailState {
  const _$InspectionDetailStateImpl(
      {this.inspectionId,
      this.inspection,
      this.errorMessage,
      this.useNormalTemplate = true,
      this.addSkuDraft,
      final Map<String, List<Map<String, dynamic>>?>? dynamicZonesNodes =
          const <String, List<Map<String, dynamic>>>{},
      final List<Map<String, dynamic>> templateKeys = const [],
      this.templateLoading = false,
      this.templateLoadError,
      this.loading = false,
      this.reportPerSku = false})
      : _dynamicZonesNodes = dynamicZonesNodes,
        _templateKeys = templateKeys;

  @override
  final int? inspectionId;
  @override
  final Inspection? inspection;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool useNormalTemplate;
  @override
  final AddSkuSubmitData? addSkuDraft;
  final Map<String, List<Map<String, dynamic>>?>? _dynamicZonesNodes;
  @override
  @JsonKey()
  Map<String, List<Map<String, dynamic>>?>? get dynamicZonesNodes {
    final value = _dynamicZonesNodes;
    if (value == null) return null;
    if (_dynamicZonesNodes is EqualUnmodifiableMapView)
      return _dynamicZonesNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Map<String, dynamic>> _templateKeys;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get templateKeys {
    if (_templateKeys is EqualUnmodifiableListView) return _templateKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templateKeys);
  }

  @override
  @JsonKey()
  final bool templateLoading;
  @override
  final String? templateLoadError;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool reportPerSku;

  @override
  String toString() {
    return 'InspectionDetailState(inspectionId: $inspectionId, inspection: $inspection, errorMessage: $errorMessage, useNormalTemplate: $useNormalTemplate, addSkuDraft: $addSkuDraft, dynamicZonesNodes: $dynamicZonesNodes, templateKeys: $templateKeys, templateLoading: $templateLoading, templateLoadError: $templateLoadError, loading: $loading, reportPerSku: $reportPerSku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionDetailStateImpl &&
            (identical(other.inspectionId, inspectionId) ||
                other.inspectionId == inspectionId) &&
            (identical(other.inspection, inspection) ||
                other.inspection == inspection) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.useNormalTemplate, useNormalTemplate) ||
                other.useNormalTemplate == useNormalTemplate) &&
            (identical(other.addSkuDraft, addSkuDraft) ||
                other.addSkuDraft == addSkuDraft) &&
            const DeepCollectionEquality()
                .equals(other._dynamicZonesNodes, _dynamicZonesNodes) &&
            const DeepCollectionEquality()
                .equals(other._templateKeys, _templateKeys) &&
            (identical(other.templateLoading, templateLoading) ||
                other.templateLoading == templateLoading) &&
            (identical(other.templateLoadError, templateLoadError) ||
                other.templateLoadError == templateLoadError) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.reportPerSku, reportPerSku) ||
                other.reportPerSku == reportPerSku));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      inspectionId,
      inspection,
      errorMessage,
      useNormalTemplate,
      addSkuDraft,
      const DeepCollectionEquality().hash(_dynamicZonesNodes),
      const DeepCollectionEquality().hash(_templateKeys),
      templateLoading,
      templateLoadError,
      loading,
      reportPerSku);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionDetailStateImplCopyWith<_$InspectionDetailStateImpl>
      get copyWith => __$$InspectionDetailStateImplCopyWithImpl<
          _$InspectionDetailStateImpl>(this, _$identity);
}

abstract class _InspectionDetailState implements InspectionDetailState {
  const factory _InspectionDetailState(
      {final int? inspectionId,
      final Inspection? inspection,
      final String? errorMessage,
      final bool useNormalTemplate,
      final AddSkuSubmitData? addSkuDraft,
      final Map<String, List<Map<String, dynamic>>?>? dynamicZonesNodes,
      final List<Map<String, dynamic>> templateKeys,
      final bool templateLoading,
      final String? templateLoadError,
      final bool loading,
      final bool reportPerSku}) = _$InspectionDetailStateImpl;

  @override
  int? get inspectionId;
  @override
  Inspection? get inspection;
  @override
  String? get errorMessage;
  @override
  bool get useNormalTemplate;
  @override
  AddSkuSubmitData? get addSkuDraft;
  @override
  Map<String, List<Map<String, dynamic>>?>? get dynamicZonesNodes;
  @override
  List<Map<String, dynamic>> get templateKeys;
  @override
  bool get templateLoading;
  @override
  String? get templateLoadError;
  @override
  bool get loading;
  @override
  bool get reportPerSku;
  @override
  @JsonKey(ignore: true)
  _$$InspectionDetailStateImplCopyWith<_$InspectionDetailStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
