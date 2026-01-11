// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ModuleStatsState {
  String get moduleId => throw _privateConstructorUsedError; // 模块ID
  List<String> get timeLabels =>
      throw _privateConstructorUsedError; // 时间轴标签（月份）
  List<int> get data => throw _privateConstructorUsedError; // 模块数据
  bool get isLoading => throw _privateConstructorUsedError; // 是否正在加载
  TimeDimension get timeDimension => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModuleStatsStateCopyWith<ModuleStatsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleStatsStateCopyWith<$Res> {
  factory $ModuleStatsStateCopyWith(
          ModuleStatsState value, $Res Function(ModuleStatsState) then) =
      _$ModuleStatsStateCopyWithImpl<$Res, ModuleStatsState>;
  @useResult
  $Res call(
      {String moduleId,
      List<String> timeLabels,
      List<int> data,
      bool isLoading,
      TimeDimension timeDimension});
}

/// @nodoc
class _$ModuleStatsStateCopyWithImpl<$Res, $Val extends ModuleStatsState>
    implements $ModuleStatsStateCopyWith<$Res> {
  _$ModuleStatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moduleId = null,
    Object? timeLabels = null,
    Object? data = null,
    Object? isLoading = null,
    Object? timeDimension = null,
  }) {
    return _then(_value.copyWith(
      moduleId: null == moduleId
          ? _value.moduleId
          : moduleId // ignore: cast_nullable_to_non_nullable
              as String,
      timeLabels: null == timeLabels
          ? _value.timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      timeDimension: null == timeDimension
          ? _value.timeDimension
          : timeDimension // ignore: cast_nullable_to_non_nullable
              as TimeDimension,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleStatsStateImplCopyWith<$Res>
    implements $ModuleStatsStateCopyWith<$Res> {
  factory _$$ModuleStatsStateImplCopyWith(_$ModuleStatsStateImpl value,
          $Res Function(_$ModuleStatsStateImpl) then) =
      __$$ModuleStatsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String moduleId,
      List<String> timeLabels,
      List<int> data,
      bool isLoading,
      TimeDimension timeDimension});
}

/// @nodoc
class __$$ModuleStatsStateImplCopyWithImpl<$Res>
    extends _$ModuleStatsStateCopyWithImpl<$Res, _$ModuleStatsStateImpl>
    implements _$$ModuleStatsStateImplCopyWith<$Res> {
  __$$ModuleStatsStateImplCopyWithImpl(_$ModuleStatsStateImpl _value,
      $Res Function(_$ModuleStatsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moduleId = null,
    Object? timeLabels = null,
    Object? data = null,
    Object? isLoading = null,
    Object? timeDimension = null,
  }) {
    return _then(_$ModuleStatsStateImpl(
      moduleId: null == moduleId
          ? _value.moduleId
          : moduleId // ignore: cast_nullable_to_non_nullable
              as String,
      timeLabels: null == timeLabels
          ? _value._timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      timeDimension: null == timeDimension
          ? _value.timeDimension
          : timeDimension // ignore: cast_nullable_to_non_nullable
              as TimeDimension,
    ));
  }
}

/// @nodoc

class _$ModuleStatsStateImpl extends _ModuleStatsState {
  const _$ModuleStatsStateImpl(
      {required this.moduleId,
      final List<String> timeLabels = const [],
      final List<int> data = const [],
      this.isLoading = false,
      this.timeDimension = TimeDimension.last6Months})
      : _timeLabels = timeLabels,
        _data = data,
        super._();

  @override
  final String moduleId;
// 模块ID
  final List<String> _timeLabels;
// 模块ID
  @override
  @JsonKey()
  List<String> get timeLabels {
    if (_timeLabels is EqualUnmodifiableListView) return _timeLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeLabels);
  }

// 时间轴标签（月份）
  final List<int> _data;
// 时间轴标签（月份）
  @override
  @JsonKey()
  List<int> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

// 模块数据
  @override
  @JsonKey()
  final bool isLoading;
// 是否正在加载
  @override
  @JsonKey()
  final TimeDimension timeDimension;

  @override
  String toString() {
    return 'ModuleStatsState(moduleId: $moduleId, timeLabels: $timeLabels, data: $data, isLoading: $isLoading, timeDimension: $timeDimension)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleStatsStateImpl &&
            (identical(other.moduleId, moduleId) ||
                other.moduleId == moduleId) &&
            const DeepCollectionEquality()
                .equals(other._timeLabels, _timeLabels) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.timeDimension, timeDimension) ||
                other.timeDimension == timeDimension));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      moduleId,
      const DeepCollectionEquality().hash(_timeLabels),
      const DeepCollectionEquality().hash(_data),
      isLoading,
      timeDimension);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleStatsStateImplCopyWith<_$ModuleStatsStateImpl> get copyWith =>
      __$$ModuleStatsStateImplCopyWithImpl<_$ModuleStatsStateImpl>(
          this, _$identity);
}

abstract class _ModuleStatsState extends ModuleStatsState {
  const factory _ModuleStatsState(
      {required final String moduleId,
      final List<String> timeLabels,
      final List<int> data,
      final bool isLoading,
      final TimeDimension timeDimension}) = _$ModuleStatsStateImpl;
  const _ModuleStatsState._() : super._();

  @override
  String get moduleId;
  @override // 模块ID
  List<String> get timeLabels;
  @override // 时间轴标签（月份）
  List<int> get data;
  @override // 模块数据
  bool get isLoading;
  @override // 是否正在加载
  TimeDimension get timeDimension;
  @override
  @JsonKey(ignore: true)
  _$$ModuleStatsStateImplCopyWith<_$ModuleStatsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
