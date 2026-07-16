import 'package:cloud/app/app.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/samples.dart';
import 'package:cloud/core/rx_bus.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/providers/app_provider.dart';
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
      privateWarehouseList: [], //查询到的有权限的保密的样品间展厅
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
      currentMediaId: media.idAsInt,
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

  /// 从样品间图片点击跳转到产品列表，并带入分类 ID
  void jumpToProductWithCategory(Warehouse warehouse, int categoryId) {
    state = state.copyWith(
      currentSelectedWarehouse: warehouse,
      isDetailedMode: true,
    );

    final newQuery = {
      ...state.query,
      'category_id': [categoryId.toString()],
    };

    state = state.copyWith(
      query: newQuery,
    );

    switchToProductView();
  }

  /// 切换到样品间全库视图（清空分类等筛选）
  void switchToWarehouseFullView(Warehouse warehouse) {
    state = state.copyWith(
      currentSelectedWarehouse: warehouse,
      query: {},
      isDetailedMode: true,
    );
    switchToProductView();
  }

  HomeState deleteMedia(TemporaryMedia media) {
    final nextMedia = List.of(state.media);
    var nextCurrentMediaId = state.currentMediaId;

    nextMedia.remove(media);

    if (media.idEquals(nextCurrentMediaId)) {
      nextCurrentMediaId = nextMedia.firstOrNull?.idAsInt;
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

    try {
      final responses = await Future.wait<ApiResponse<List<Warehouse>>>([
        getWarehousesPublic(),
        getWarehousesPrivate(),
      ]);

      final respPublic = responses[0];
      final respPrivate = responses[1];
      final warehouses = [...respPublic.data, ...respPrivate.data];
      var independentWarehouse = <Warehouse>[];

      // 过滤掉废弃的样品间
      final filteredWarehouses =
          warehouses.where((warehouse) => warehouse.abandoned != true).toList();

      // 若当前租户为 id==6，且没有私有样品间展厅，追加新增一项独立(部门)样品间
      if (currentTenant != null &&
          (currentTenant.id == TenantConstants.warehouseMainTenantId)) {
        if (respPrivate.data.isEmpty) {
          independentWarehouse = [
            const Warehouse(
              name: '独立(部门)样品间', 
              // name_en: 'INDEPENDENT (DEPARTMENT) SHOWROOM',
              image: [
                WarehouseImage(
                  url: 'assets/bs_self.jpg',
                  thumbUrl: 'assets/bs_self.jpg',
                ),
              ],
            ),
          ];
        }
      }

      state = state.copyWith(
        warehouses: [...filteredWarehouses, ...independentWarehouse],
        privateWarehouseList: respPrivate.data,
      );
    } finally {
      state = state.copyWith(isLoadingWarehouses: false);
    }
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
    final hasPrivateWarehouse = state.privateWarehouseList.isNotEmpty;
    final currentSelectedWarehouse = state.currentSelectedWarehouse;
    final search = state.search;
    final isDetailedMode = state.isDetailedMode;
    final query = state.query;
    final productCurrentPage = state.productCurrentPage;
    final privateWarehouseList = state.privateWarehouseList;

    try {
      // 准备查询参数（使用当前状态）
      final currentPage = init == true ? 1 : productCurrentPage;
      final core = app.container.read(coreProvider).value;
      final tenant = core?.currentTenant;
      final queryParameters = {
        "search": searchText ?? search,
        if (searchMedia != null) "image": searchMedia.id,
        "item_type": "sample", // 样品间数据
        "page": currentPage,
        "pageSize": 20,
        "includes": 'supplyQuotes.supplier',
        if (isDetailedMode == true) ...query,
        if (tenant?.id == TenantConstants.warehouseMainTenantId &&
            currentSelectedWarehouse != null &&
            PublicWarehouseId.ids.contains(currentSelectedWarehouse
                .id)) // 当前租户是云链，当前选中的样品间展厅有值，且值是集团公共样品展厅中的一个
          'warehouse_id': currentSelectedWarehouse!.id.toString(),
      };

      //在云链的租户上，有保密展厅，当前选中的展厅为空
      final shouldSearchOnPublicAndPrivate =
          tenant?.id == TenantConstants.warehouseMainTenantId &&
              hasPrivateWarehouse &&
              currentSelectedWarehouse == null;

      //在云链的租户上，有保密展厅，当前选中的展厅不是公开展厅时走私有搜索
      final searchOnPrivate =
          tenant?.id == TenantConstants.warehouseMainTenantId &&
              hasPrivateWarehouse &&
              currentSelectedWarehouse != null &&
              !PublicWarehouseId.ids.contains(currentSelectedWarehouse.id);

      /// 保密展厅列表里出现的租户 id（去重，顺序与列表中首次出现一致）。
      final distinctPrivateTenantIds = <int>{
        for (final w in privateWarehouseList)
          if (w.tenantId != null) w.tenantId!,
      }.toList();

      late ApiResponse<List<Sample>> resp;
      //如果应该在公共、私有样品间同时搜索
      if (shouldSearchOnPublicAndPrivate) {
        if (distinctPrivateTenantIds.isEmpty) {
          resp = await getSamples(queryParameters: queryParameters);
        } else {
          final responses = await Future.wait<ApiResponse<List<Sample>>>([
            getSamples(queryParameters: queryParameters),
            ...distinctPrivateTenantIds.map(
              (tid) => getSamples(
                queryParameters: queryParameters,
                extraHeaders: <String, dynamic>{'X-Tenant-ID': tid},
              ),
            ),
          ]);

          final respPublic = responses.first;
          final mergedPrivate =
              responses.skip(1).expand((r) => r.data).toList();

          resp = ApiResponse<List<Sample>>.data(
            [...mergedPrivate, ...respPublic.data],
            respPublic.meta ?? responses.last.meta,
          );
        }
        //如果应该在某个独立样品间独立搜索
      } else if (searchOnPrivate) {
        final responses = await Future.wait<ApiResponse<List<Sample>>>(
          distinctPrivateTenantIds.map(
            (tid) => getSamples(
              queryParameters: queryParameters,
              extraHeaders: <String, dynamic>{'X-Tenant-ID': tid},
            ),
          ),
        );
        resp = ApiResponse<List<Sample>>.data(
          responses.expand((r) => r.data).toList(),
          responses.last.meta ?? responses.first.meta,
        );
      } else {
        resp = await getSamples(
          queryParameters: queryParameters,
        );
      }

      logger.d('样品列表查询参数$queryParameters');

      // 使用 addPostFrameCallback 延迟状态更新，避免在构建过程中修改状态

      var updatedState = state.copyWith(
        search: searchText,
        // media: searchMedia != null ? [searchMedia] : state.media,
        currentMediaId: searchMedia?.idAsInt,
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
