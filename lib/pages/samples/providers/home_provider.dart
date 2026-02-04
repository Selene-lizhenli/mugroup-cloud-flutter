import 'package:cloud/app/app.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/core/rx_bus.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/warehouse_image.dart';
import 'package:cloud/pages/samples/models/home_state.dart';
import 'package:cloud/services/wms.dart';
import 'package:cloud/services/sample.dart';
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
      query: {},
      productCurrentPage: 1,
      productNoMore: false,
      productListLoading: false,
    );

    return homeState;
  }

  void setproductTotalPages(int page) {
    state = state.copyWith(samplePages: page);
  }

  void setsupplierTotalPages(int page) {
    state = state.copyWith(supplierPages: page);
  }

  /// 切换到指定的 PageView 页面（全局控制 PageView）
  void switchToPage(int page) {
    // 使用全局的 PageController 来切换页面
    state.pageController.jumpToPage(page);
    state = state.copyWith(currentPage: page);
  }

  /// 切换到商品列表页（ProductView）
  void switchToProductView() {
    switchToPage(1);
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

  void clearMedia() {
    state = state.copyWith(
      media: [],
      currentMediaId: null,
    );
  }

  Future<void> fetchWarehouses(Tenant? currentTenant) async {
    state = state.copyWith(isLoadingWarehouses: true);

    final resp = await getWarehouses();
    final warehouses = resp.data ?? [];
    var independentWarehouse = <Warehouse>[];
    // 若当前租户为 id==6，新增一项独立(部门)样品间
    if (currentTenant != null &&
        (currentTenant.id == TenantConstants.warehouseMainTenantId)) {
      independentWarehouse = [
        const Warehouse(
          name: '独立(部门)样品间',
          image: [
            WarehouseImage(
              url: 'assets/building2d.png',
              thumbUrl: 'assets/building2d.png',
            ),
          ],
        ),
      ];
    }
    // 过滤掉废弃的样品间
    final filteredWarehouses =
        warehouses.where((warehouse) => warehouse.abandoned != true).toList();

    state = state.copyWith(
      warehouses: [...filteredWarehouses, ...independentWarehouse],
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

  void setQuery(Map<String, dynamic> newQuery) {
    state = state.copyWith(query: newQuery);
  }

  Future<ApiResponse<List<Sample>>> fetchSamples({
    String? searchText,
    bool? init = false,
    TemporaryMedia? searchMedia,
  }) async {
    // 仅首次/刷新时显示全屏 loading，加载更多时不占位，避免列表被替换导致滚动回顶
    if (init == true) {
      state = state.copyWith(productListLoading: true, productCurrentPage: 1);
    }
    try {
      // 准备查询参数（使用当前状态）
      final currentPage = init == true ? 1 : state.productCurrentPage;
      final core = app.container.read(coreProvider).value;
      final tenant = core?.currentTenant;
      final queryParameters = {
        "search": searchText ?? state.search,
        if (searchMedia != null) "image": searchMedia.id,
        "item_type": "sample", // 样品间数据
        "page": currentPage,
        "pageSize": 20,
        "includes": 'supplyQuotes.supplier',
        if (state.isDetailedMode == true) ...state.query,
        if (tenant?.id == TenantConstants.warehouseMainTenantId &&
            state.currentSelectedWarehouse != null)
          'warehouse_id': state.currentSelectedWarehouse!.id.toString(),
      };
      logger.d('样品列表查询参数$queryParameters');
      final resp = await getSamples(queryParameters: queryParameters);

      // 使用 addPostFrameCallback 延迟状态更新，避免在构建过程中修改状态

      var updatedState = state.copyWith(
        search: searchText,
        // media: searchMedia != null ? [searchMedia] : state.media,
        currentMediaId: searchMedia?.id,
        productListLoading: false,
        samples: (init == true || currentPage == 1)
            ? resp.data
            : [...state.samples, ...resp.data],
        productNoMore: resp.data.length < 20,
      );
      if (state.productCurrentPage == 1 && state.facetCounts.isEmpty) {
        updatedState = updatedState.copyWith(
          facetCounts: resp.meta?.facetCounts ?? [],
        );
      }
      // 刷新(init)时重置页码为下一页；加载更多时递增页码
      if (init == true) {
        updatedState = updatedState.copyWith(
          productCurrentPage: resp.data.length >= 20 ? 2 : 1,
        );
      } else if (resp.data.length >= 20) {
        updatedState = updatedState.copyWith(
          productCurrentPage: state.productCurrentPage + 1,
        );
      }
      state = updatedState;
      return resp;
    } catch (e, st) {
      logger.e('fetchSamples 失败', error: e, stackTrace: st);
      state = state.copyWith(
        productListLoading: false,
      );
      return const ApiResponse.data(<Sample>[], null);
    }
  }
}
