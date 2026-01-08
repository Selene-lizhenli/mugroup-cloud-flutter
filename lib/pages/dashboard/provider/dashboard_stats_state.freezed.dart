// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardStatsState {
  List<String> get timeLabels =>
      throw _privateConstructorUsedError; // 时间轴标签（月份）
  List<int> get productData => throw _privateConstructorUsedError; // 产品数量
  List<int> get customerData => throw _privateConstructorUsedError; // 客户数量
  List<int> get serviceProviderData =>
      throw _privateConstructorUsedError; // 服务商数量
  List<int> get inspectionData => throw _privateConstructorUsedError; // 验货任务数量
  bool get isLoading => throw _privateConstructorUsedError; // 是否正在加载
  TimeDimension get timeDimension => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DashboardStatsStateCopyWith<DashboardStatsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsStateCopyWith<$Res> {
  factory $DashboardStatsStateCopyWith(
          DashboardStatsState value, $Res Function(DashboardStatsState) then) =
      _$DashboardStatsStateCopyWithImpl<$Res, DashboardStatsState>;
  @useResult
  $Res call(
      {List<String> timeLabels,
      List<int> productData,
      List<int> customerData,
      List<int> serviceProviderData,
      List<int> inspectionData,
      bool isLoading,
      TimeDimension timeDimension});
}

/// @nodoc
class _$DashboardStatsStateCopyWithImpl<$Res, $Val extends DashboardStatsState>
    implements $DashboardStatsStateCopyWith<$Res> {
  _$DashboardStatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeLabels = null,
    Object? productData = null,
    Object? customerData = null,
    Object? serviceProviderData = null,
    Object? inspectionData = null,
    Object? isLoading = null,
    Object? timeDimension = null,
  }) {
    return _then(_value.copyWith(
      timeLabels: null == timeLabels
          ? _value.timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      productData: null == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      customerData: null == customerData
          ? _value.customerData
          : customerData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      serviceProviderData: null == serviceProviderData
          ? _value.serviceProviderData
          : serviceProviderData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      inspectionData: null == inspectionData
          ? _value.inspectionData
          : inspectionData // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DashboardStatsStateImplCopyWith<$Res>
    implements $DashboardStatsStateCopyWith<$Res> {
  factory _$$DashboardStatsStateImplCopyWith(_$DashboardStatsStateImpl value,
          $Res Function(_$DashboardStatsStateImpl) then) =
      __$$DashboardStatsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> timeLabels,
      List<int> productData,
      List<int> customerData,
      List<int> serviceProviderData,
      List<int> inspectionData,
      bool isLoading,
      TimeDimension timeDimension});
}

/// @nodoc
class __$$DashboardStatsStateImplCopyWithImpl<$Res>
    extends _$DashboardStatsStateCopyWithImpl<$Res, _$DashboardStatsStateImpl>
    implements _$$DashboardStatsStateImplCopyWith<$Res> {
  __$$DashboardStatsStateImplCopyWithImpl(_$DashboardStatsStateImpl _value,
      $Res Function(_$DashboardStatsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeLabels = null,
    Object? productData = null,
    Object? customerData = null,
    Object? serviceProviderData = null,
    Object? inspectionData = null,
    Object? isLoading = null,
    Object? timeDimension = null,
  }) {
    return _then(_$DashboardStatsStateImpl(
      timeLabels: null == timeLabels
          ? _value._timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      productData: null == productData
          ? _value._productData
          : productData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      customerData: null == customerData
          ? _value._customerData
          : customerData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      serviceProviderData: null == serviceProviderData
          ? _value._serviceProviderData
          : serviceProviderData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      inspectionData: null == inspectionData
          ? _value._inspectionData
          : inspectionData // ignore: cast_nullable_to_non_nullable
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

class _$DashboardStatsStateImpl extends _DashboardStatsState {
  const _$DashboardStatsStateImpl(
      {final List<String> timeLabels = const [],
      final List<int> productData = const [],
      final List<int> customerData = const [],
      final List<int> serviceProviderData = const [],
      final List<int> inspectionData = const [],
      this.isLoading = false,
      this.timeDimension = TimeDimension.last6Months})
      : _timeLabels = timeLabels,
        _productData = productData,
        _customerData = customerData,
        _serviceProviderData = serviceProviderData,
        _inspectionData = inspectionData,
        super._();

  final List<String> _timeLabels;
  @override
  @JsonKey()
  List<String> get timeLabels {
    if (_timeLabels is EqualUnmodifiableListView) return _timeLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeLabels);
  }

// 时间轴标签（月份）
  final List<int> _productData;
// 时间轴标签（月份）
  @override
  @JsonKey()
  List<int> get productData {
    if (_productData is EqualUnmodifiableListView) return _productData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productData);
  }

// 产品数量
  final List<int> _customerData;
// 产品数量
  @override
  @JsonKey()
  List<int> get customerData {
    if (_customerData is EqualUnmodifiableListView) return _customerData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customerData);
  }

// 客户数量
  final List<int> _serviceProviderData;
// 客户数量
  @override
  @JsonKey()
  List<int> get serviceProviderData {
    if (_serviceProviderData is EqualUnmodifiableListView)
      return _serviceProviderData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceProviderData);
  }

// 服务商数量
  final List<int> _inspectionData;
// 服务商数量
  @override
  @JsonKey()
  List<int> get inspectionData {
    if (_inspectionData is EqualUnmodifiableListView) return _inspectionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inspectionData);
  }

// 验货任务数量
  @override
  @JsonKey()
  final bool isLoading;
// 是否正在加载
  @override
  @JsonKey()
  final TimeDimension timeDimension;

  @override
  String toString() {
    return 'DashboardStatsState(timeLabels: $timeLabels, productData: $productData, customerData: $customerData, serviceProviderData: $serviceProviderData, inspectionData: $inspectionData, isLoading: $isLoading, timeDimension: $timeDimension)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._timeLabels, _timeLabels) &&
            const DeepCollectionEquality()
                .equals(other._productData, _productData) &&
            const DeepCollectionEquality()
                .equals(other._customerData, _customerData) &&
            const DeepCollectionEquality()
                .equals(other._serviceProviderData, _serviceProviderData) &&
            const DeepCollectionEquality()
                .equals(other._inspectionData, _inspectionData) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.timeDimension, timeDimension) ||
                other.timeDimension == timeDimension));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timeLabels),
      const DeepCollectionEquality().hash(_productData),
      const DeepCollectionEquality().hash(_customerData),
      const DeepCollectionEquality().hash(_serviceProviderData),
      const DeepCollectionEquality().hash(_inspectionData),
      isLoading,
      timeDimension);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsStateImplCopyWith<_$DashboardStatsStateImpl> get copyWith =>
      __$$DashboardStatsStateImplCopyWithImpl<_$DashboardStatsStateImpl>(
          this, _$identity);
}

abstract class _DashboardStatsState extends DashboardStatsState {
  const factory _DashboardStatsState(
      {final List<String> timeLabels,
      final List<int> productData,
      final List<int> customerData,
      final List<int> serviceProviderData,
      final List<int> inspectionData,
      final bool isLoading,
      final TimeDimension timeDimension}) = _$DashboardStatsStateImpl;
  const _DashboardStatsState._() : super._();

  @override
  List<String> get timeLabels;
  @override // 时间轴标签（月份）
  List<int> get productData;
  @override // 产品数量
  List<int> get customerData;
  @override // 客户数量
  List<int> get serviceProviderData;
  @override // 服务商数量
  List<int> get inspectionData;
  @override // 验货任务数量
  bool get isLoading;
  @override // 是否正在加载
  TimeDimension get timeDimension;
  @override
  @JsonKey(ignore: true)
  _$$DashboardStatsStateImplCopyWith<_$DashboardStatsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
