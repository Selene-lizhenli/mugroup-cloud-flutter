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
  }) = _HomeState;
  TemporaryMedia? get currentMedia {
    return media.firstWhereOrNull((item) => item.id == currentMediaId);
  }
}
