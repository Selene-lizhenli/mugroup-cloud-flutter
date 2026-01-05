import 'package:cloud/core/rx_bus.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/samples/models/home_state.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  @override
  HomeState build() {
    final homeState = HomeState(
      bus: RxBus(),
      currentPage: 0,
      pageController: PageController(initialPage: 0),
      searchTextController: TextEditingController(),
      search: null,
      media: [],
      currentMediaId: null,
      samples: [],
      suppliers: [],
      facetCounts: [],
      samplePages: 0,
      sampleNoMore: false,
      supplierPages: 0,
      supplierNoMore: false,
      warehouses: [],
      isLoadingWarehouses: false,
    );

    return homeState;
  }

  void setproductTotalPages(int page) {
    state = state.copyWith(samplePages: page);
  }

  void setsupplierTotalPages(int page) {
    state = state.copyWith(supplierPages: page);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  void addMedia(TemporaryMedia media) {
    var list = state.media;
    if (!state.media.contains(media)) {
      list = [media, ...list];
    }

    state = state.copyWith(
      media: list,
      currentMediaId: media.id,
    );
  }

  void setSamples(List<Sample> list) {
    state = state.copyWith(samples: list);
  }

  void addSamples(List<Sample> list) {
    state = state.copyWith(samples: [...state.samples, ...list]);
  }

  void setFacetCounts(List<FacetCount> list) {
    state = state.copyWith(facetCounts: list);
  }

  void setSuppliers(List<Supplier> list) {
    state = state.copyWith(suppliers: list);
  }

  void addSuppliers(List<Supplier> list) {
    state = state.copyWith(suppliers: [...state.suppliers, ...list]);
  }

  // void setCategories(List<Category> list) {
  //   state = state.copyWith(categories: list);
  // }

  // void addCategories(List<Category> list) {
  //   state = state.copyWith(categories: [...state.categories, ...list]);
  // }

  HomeState deleteMedia(TemporaryMedia media) {
    final nextMedia = List.of(state.media);
    var nextCurrentMediaId = state.currentMediaId;

    nextMedia.remove(media);

    if (media.id == nextCurrentMediaId) {
      nextCurrentMediaId = nextMedia.firstOrNull?.id;
    }

    state = state.copyWith(
      media: nextMedia,
      currentMediaId: nextCurrentMediaId,
    );

    return state;
  }

  Future<void> fetchWarehouses() async {
    state = state.copyWith(isLoadingWarehouses: true);

    final resp = await getWarehouses();
    final warehouses = resp.data;
    
    // 在所有样品间列表前面添加"所有样品间"选项
    const allWarehouse = Warehouse( 
      id: 0,
      name: '所有样品间',
      address: '',
    );
    
    state = state.copyWith(
      warehouses: [allWarehouse, ...warehouses],
      isLoadingWarehouses: false,
    );
  }

  void setCurrentSelectedWarehouse(Warehouse? warehouse) {
    state = state.copyWith(currentSelectedWarehouse: warehouse);
  }

  void toggleViewMode() {
    state = state.copyWith(isDetailedMode: !state.isDetailedMode);
  }

  void setViewMode(bool isDetailed) {
    state = state.copyWith(isDetailedMode: isDetailed);
  }
}
