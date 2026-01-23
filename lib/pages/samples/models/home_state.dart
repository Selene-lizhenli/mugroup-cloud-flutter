import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/models/wms.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud/core/rx_bus.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();
  const factory HomeState({
    required RxBus bus,
    required int currentPage,
    required PageController pageController,
    required TextEditingController searchTextController,
    String? search,
    required List<TemporaryMedia> media,
    int? currentMediaId, // 当前选中的媒体id
    bool? productListLoading,

    // ----------  样品 ----------
    @Default([]) List<Sample> samples,
    @Default([]) List<FacetCount> facetCounts,
    @Default(1) int samplePages,
    @Default(false) bool sampleNoMore,

    // ----------  服务商 ----------
    @Default([]) List<Supplier> suppliers,
    @Default(1) int supplierPages,
    @Default(false) bool supplierNoMore,

    // ----------  样品间 ----------
    @Default([]) List<Warehouse> warehouses,
    @Default(false) bool isLoadingWarehouses,
    Warehouse? currentSelectedWarehouse,
    
    // ----------  视图模式 ----------
    @Default(false) bool isDetailedMode, // false: 精简模式, true: 详细模式
    @Default({}) Map<String, dynamic> query,
    @Default(1) int productCurrentPage,
    @Default(false) bool productNoMore,
  }) = _HomeState;
  TemporaryMedia? get currentMedia {
    return media.firstWhereOrNull((item) => item.id == currentMediaId);
  }
}
