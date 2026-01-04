// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketPurchaseStats _$MarketPurchaseStatsFromJson(Map<String, dynamic> json) {
  return _MarketPurchaseStats.fromJson(json);
}

/// @nodoc
mixin _$MarketPurchaseStats {
  @JsonKey(name: 'time_labels')
  List<String>? get timeLabels =>
      throw _privateConstructorUsedError; // 时间轴标签（月份）
  @JsonKey(name: 'product_data')
  List<int>? get productData => throw _privateConstructorUsedError; // 产品数量
  @JsonKey(name: 'customer_data')
  List<int>? get customerData => throw _privateConstructorUsedError; // 客户数量
  @JsonKey(name: 'service_provider_data')
  List<int>? get serviceProviderData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketPurchaseStatsCopyWith<MarketPurchaseStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketPurchaseStatsCopyWith<$Res> {
  factory $MarketPurchaseStatsCopyWith(
          MarketPurchaseStats value, $Res Function(MarketPurchaseStats) then) =
      _$MarketPurchaseStatsCopyWithImpl<$Res, MarketPurchaseStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'time_labels') List<String>? timeLabels,
      @JsonKey(name: 'product_data') List<int>? productData,
      @JsonKey(name: 'customer_data') List<int>? customerData,
      @JsonKey(name: 'service_provider_data') List<int>? serviceProviderData});
}

/// @nodoc
class _$MarketPurchaseStatsCopyWithImpl<$Res, $Val extends MarketPurchaseStats>
    implements $MarketPurchaseStatsCopyWith<$Res> {
  _$MarketPurchaseStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeLabels = freezed,
    Object? productData = freezed,
    Object? customerData = freezed,
    Object? serviceProviderData = freezed,
  }) {
    return _then(_value.copyWith(
      timeLabels: freezed == timeLabels
          ? _value.timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      productData: freezed == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      customerData: freezed == customerData
          ? _value.customerData
          : customerData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      serviceProviderData: freezed == serviceProviderData
          ? _value.serviceProviderData
          : serviceProviderData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketPurchaseStatsImplCopyWith<$Res>
    implements $MarketPurchaseStatsCopyWith<$Res> {
  factory _$$MarketPurchaseStatsImplCopyWith(_$MarketPurchaseStatsImpl value,
          $Res Function(_$MarketPurchaseStatsImpl) then) =
      __$$MarketPurchaseStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'time_labels') List<String>? timeLabels,
      @JsonKey(name: 'product_data') List<int>? productData,
      @JsonKey(name: 'customer_data') List<int>? customerData,
      @JsonKey(name: 'service_provider_data') List<int>? serviceProviderData});
}

/// @nodoc
class __$$MarketPurchaseStatsImplCopyWithImpl<$Res>
    extends _$MarketPurchaseStatsCopyWithImpl<$Res, _$MarketPurchaseStatsImpl>
    implements _$$MarketPurchaseStatsImplCopyWith<$Res> {
  __$$MarketPurchaseStatsImplCopyWithImpl(_$MarketPurchaseStatsImpl _value,
      $Res Function(_$MarketPurchaseStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeLabels = freezed,
    Object? productData = freezed,
    Object? customerData = freezed,
    Object? serviceProviderData = freezed,
  }) {
    return _then(_$MarketPurchaseStatsImpl(
      timeLabels: freezed == timeLabels
          ? _value._timeLabels
          : timeLabels // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      productData: freezed == productData
          ? _value._productData
          : productData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      customerData: freezed == customerData
          ? _value._customerData
          : customerData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      serviceProviderData: freezed == serviceProviderData
          ? _value._serviceProviderData
          : serviceProviderData // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketPurchaseStatsImpl implements _MarketPurchaseStats {
  const _$MarketPurchaseStatsImpl(
      {@JsonKey(name: 'time_labels') final List<String>? timeLabels,
      @JsonKey(name: 'product_data') final List<int>? productData,
      @JsonKey(name: 'customer_data') final List<int>? customerData,
      @JsonKey(name: 'service_provider_data')
      final List<int>? serviceProviderData})
      : _timeLabels = timeLabels,
        _productData = productData,
        _customerData = customerData,
        _serviceProviderData = serviceProviderData;

  factory _$MarketPurchaseStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketPurchaseStatsImplFromJson(json);

  final List<String>? _timeLabels;
  @override
  @JsonKey(name: 'time_labels')
  List<String>? get timeLabels {
    final value = _timeLabels;
    if (value == null) return null;
    if (_timeLabels is EqualUnmodifiableListView) return _timeLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 时间轴标签（月份）
  final List<int>? _productData;
// 时间轴标签（月份）
  @override
  @JsonKey(name: 'product_data')
  List<int>? get productData {
    final value = _productData;
    if (value == null) return null;
    if (_productData is EqualUnmodifiableListView) return _productData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 产品数量
  final List<int>? _customerData;
// 产品数量
  @override
  @JsonKey(name: 'customer_data')
  List<int>? get customerData {
    final value = _customerData;
    if (value == null) return null;
    if (_customerData is EqualUnmodifiableListView) return _customerData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 客户数量
  final List<int>? _serviceProviderData;
// 客户数量
  @override
  @JsonKey(name: 'service_provider_data')
  List<int>? get serviceProviderData {
    final value = _serviceProviderData;
    if (value == null) return null;
    if (_serviceProviderData is EqualUnmodifiableListView)
      return _serviceProviderData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MarketPurchaseStats(timeLabels: $timeLabels, productData: $productData, customerData: $customerData, serviceProviderData: $serviceProviderData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketPurchaseStatsImpl &&
            const DeepCollectionEquality()
                .equals(other._timeLabels, _timeLabels) &&
            const DeepCollectionEquality()
                .equals(other._productData, _productData) &&
            const DeepCollectionEquality()
                .equals(other._customerData, _customerData) &&
            const DeepCollectionEquality()
                .equals(other._serviceProviderData, _serviceProviderData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timeLabels),
      const DeepCollectionEquality().hash(_productData),
      const DeepCollectionEquality().hash(_customerData),
      const DeepCollectionEquality().hash(_serviceProviderData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketPurchaseStatsImplCopyWith<_$MarketPurchaseStatsImpl> get copyWith =>
      __$$MarketPurchaseStatsImplCopyWithImpl<_$MarketPurchaseStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketPurchaseStatsImplToJson(
      this,
    );
  }
}

abstract class _MarketPurchaseStats implements MarketPurchaseStats {
  const factory _MarketPurchaseStats(
      {@JsonKey(name: 'time_labels') final List<String>? timeLabels,
      @JsonKey(name: 'product_data') final List<int>? productData,
      @JsonKey(name: 'customer_data') final List<int>? customerData,
      @JsonKey(name: 'service_provider_data')
      final List<int>? serviceProviderData}) = _$MarketPurchaseStatsImpl;

  factory _MarketPurchaseStats.fromJson(Map<String, dynamic> json) =
      _$MarketPurchaseStatsImpl.fromJson;

  @override
  @JsonKey(name: 'time_labels')
  List<String>? get timeLabels;
  @override // 时间轴标签（月份）
  @JsonKey(name: 'product_data')
  List<int>? get productData;
  @override // 产品数量
  @JsonKey(name: 'customer_data')
  List<int>? get customerData;
  @override // 客户数量
  @JsonKey(name: 'service_provider_data')
  List<int>? get serviceProviderData;
  @override
  @JsonKey(ignore: true)
  _$$MarketPurchaseStatsImplCopyWith<_$MarketPurchaseStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
