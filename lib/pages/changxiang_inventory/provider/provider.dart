// import 'package:cloud/models/cx_inventory/cx.inventory.dart';
import 'package:cloud/models/cx_inventory/cx.inventory.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/services/inventory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart'; 

/// 独立站列表状态
class CxInventoryState implements MuListState {
  const CxInventoryState({
    this.list = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.stationSearchKeyword = '',
  });

  final List<CxInventoryType> list; // 列表
  final bool isLoading; // 是否加载中
  final bool isLoadingMore; // 是否加载更多
  final String? errorMessage; // 错误信息
  final int page; // 页码
  final bool hasMore; // 是否有更多数据
  final String stationSearchKeyword; // 站点搜索关键词

  CxInventoryState copyWith({
    List<CxInventoryType>? list,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? stationSearchKeyword,
    }) {
    return CxInventoryState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      stationSearchKeyword: stationSearchKeyword ?? this.stationSearchKeyword,
    );
  }
}

/// 独立站列表 Provider：页面加载后调用 [load] 拉取列表，通过 [singleStationProvider] 读取状态
@riverpod
class CxInventory extends _$CxInventory {
  @override
  CxInventoryState build() {
    // 首次创建 provider 时自动拉一次列表
    Future.microtask(() => load());
    return const CxInventoryState();
  }

  void setStationSearchKeyword(String keyword) {
    state = state.copyWith(stationSearchKeyword: keyword);
  }

  void cleanSearchKeyWord() {
    state = state.copyWith(stationSearchKeyword: '');
  }

  ///  列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
  Future<void> load({
    Map<String, dynamic>? params,
    bool refresh = true,
  }) async {
    final nextPage = refresh ? 1 : state.page;
    state = state.copyWith(
      isLoading: refresh ? true : state.isLoading,
      isLoadingMore: refresh ? false : true,
      errorMessage: null,
    );
    try {
      final query = {
        'page': nextPage,
        'pageSize': 20,
        'PurchaseOrderNo': state.stationSearchKeyword,
        ...?params,
      };
      final resp = await getInventoryList(query);
      final data = resp.data;
      final hasMore = (data.length >= 20);
      state = state.copyWith(
        list: refresh ? data : [...state.list, ...data],
        isLoading: false,
        isLoadingMore: false,
        page: nextPage + 1,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }
}
