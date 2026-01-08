// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyStats _$MonthlyStatsFromJson(Map<String, dynamic> json) {
  return _MonthlyStats.fromJson(json);
}

/// @nodoc
mixin _$MonthlyStats {
  @JsonKey(name: 'crm_company')
  int? get crmCompany => throw _privateConstructorUsedError; // 客户数量
  @JsonKey(name: 'market_product')
  int? get marketProduct => throw _privateConstructorUsedError; // 产品数量
  @JsonKey(name: 'supply_supplier')
  int? get supplySupplier => throw _privateConstructorUsedError; // 供应商数量
  @JsonKey(name: 'inspection_task')
  int? get inspectionTask => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonthlyStatsCopyWith<MonthlyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyStatsCopyWith<$Res> {
  factory $MonthlyStatsCopyWith(
          MonthlyStats value, $Res Function(MonthlyStats) then) =
      _$MonthlyStatsCopyWithImpl<$Res, MonthlyStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'crm_company') int? crmCompany,
      @JsonKey(name: 'market_product') int? marketProduct,
      @JsonKey(name: 'supply_supplier') int? supplySupplier,
      @JsonKey(name: 'inspection_task') int? inspectionTask});
}

/// @nodoc
class _$MonthlyStatsCopyWithImpl<$Res, $Val extends MonthlyStats>
    implements $MonthlyStatsCopyWith<$Res> {
  _$MonthlyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? crmCompany = freezed,
    Object? marketProduct = freezed,
    Object? supplySupplier = freezed,
    Object? inspectionTask = freezed,
  }) {
    return _then(_value.copyWith(
      crmCompany: freezed == crmCompany
          ? _value.crmCompany
          : crmCompany // ignore: cast_nullable_to_non_nullable
              as int?,
      marketProduct: freezed == marketProduct
          ? _value.marketProduct
          : marketProduct // ignore: cast_nullable_to_non_nullable
              as int?,
      supplySupplier: freezed == supplySupplier
          ? _value.supplySupplier
          : supplySupplier // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectionTask: freezed == inspectionTask
          ? _value.inspectionTask
          : inspectionTask // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyStatsImplCopyWith<$Res>
    implements $MonthlyStatsCopyWith<$Res> {
  factory _$$MonthlyStatsImplCopyWith(
          _$MonthlyStatsImpl value, $Res Function(_$MonthlyStatsImpl) then) =
      __$$MonthlyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'crm_company') int? crmCompany,
      @JsonKey(name: 'market_product') int? marketProduct,
      @JsonKey(name: 'supply_supplier') int? supplySupplier,
      @JsonKey(name: 'inspection_task') int? inspectionTask});
}

/// @nodoc
class __$$MonthlyStatsImplCopyWithImpl<$Res>
    extends _$MonthlyStatsCopyWithImpl<$Res, _$MonthlyStatsImpl>
    implements _$$MonthlyStatsImplCopyWith<$Res> {
  __$$MonthlyStatsImplCopyWithImpl(
      _$MonthlyStatsImpl _value, $Res Function(_$MonthlyStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? crmCompany = freezed,
    Object? marketProduct = freezed,
    Object? supplySupplier = freezed,
    Object? inspectionTask = freezed,
  }) {
    return _then(_$MonthlyStatsImpl(
      crmCompany: freezed == crmCompany
          ? _value.crmCompany
          : crmCompany // ignore: cast_nullable_to_non_nullable
              as int?,
      marketProduct: freezed == marketProduct
          ? _value.marketProduct
          : marketProduct // ignore: cast_nullable_to_non_nullable
              as int?,
      supplySupplier: freezed == supplySupplier
          ? _value.supplySupplier
          : supplySupplier // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectionTask: freezed == inspectionTask
          ? _value.inspectionTask
          : inspectionTask // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyStatsImpl implements _MonthlyStats {
  const _$MonthlyStatsImpl(
      {@JsonKey(name: 'crm_company') this.crmCompany,
      @JsonKey(name: 'market_product') this.marketProduct,
      @JsonKey(name: 'supply_supplier') this.supplySupplier,
      @JsonKey(name: 'inspection_task') this.inspectionTask});

  factory _$MonthlyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyStatsImplFromJson(json);

  @override
  @JsonKey(name: 'crm_company')
  final int? crmCompany;
// 客户数量
  @override
  @JsonKey(name: 'market_product')
  final int? marketProduct;
// 产品数量
  @override
  @JsonKey(name: 'supply_supplier')
  final int? supplySupplier;
// 供应商数量
  @override
  @JsonKey(name: 'inspection_task')
  final int? inspectionTask;

  @override
  String toString() {
    return 'MonthlyStats(crmCompany: $crmCompany, marketProduct: $marketProduct, supplySupplier: $supplySupplier, inspectionTask: $inspectionTask)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyStatsImpl &&
            (identical(other.crmCompany, crmCompany) ||
                other.crmCompany == crmCompany) &&
            (identical(other.marketProduct, marketProduct) ||
                other.marketProduct == marketProduct) &&
            (identical(other.supplySupplier, supplySupplier) ||
                other.supplySupplier == supplySupplier) &&
            (identical(other.inspectionTask, inspectionTask) ||
                other.inspectionTask == inspectionTask));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, crmCompany, marketProduct, supplySupplier, inspectionTask);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyStatsImplCopyWith<_$MonthlyStatsImpl> get copyWith =>
      __$$MonthlyStatsImplCopyWithImpl<_$MonthlyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyStatsImplToJson(
      this,
    );
  }
}

abstract class _MonthlyStats implements MonthlyStats {
  const factory _MonthlyStats(
          {@JsonKey(name: 'crm_company') final int? crmCompany,
          @JsonKey(name: 'market_product') final int? marketProduct,
          @JsonKey(name: 'supply_supplier') final int? supplySupplier,
          @JsonKey(name: 'inspection_task') final int? inspectionTask}) =
      _$MonthlyStatsImpl;

  factory _MonthlyStats.fromJson(Map<String, dynamic> json) =
      _$MonthlyStatsImpl.fromJson;

  @override
  @JsonKey(name: 'crm_company')
  int? get crmCompany;
  @override // 客户数量
  @JsonKey(name: 'market_product')
  int? get marketProduct;
  @override // 产品数量
  @JsonKey(name: 'supply_supplier')
  int? get supplySupplier;
  @override // 供应商数量
  @JsonKey(name: 'inspection_task')
  int? get inspectionTask;
  @override
  @JsonKey(ignore: true)
  _$$MonthlyStatsImplCopyWith<_$MonthlyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
