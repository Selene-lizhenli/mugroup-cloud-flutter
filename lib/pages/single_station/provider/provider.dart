import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/services/single_station.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// 独立站列表状态
class SingleStationState {
  const SingleStationState({
    this.list = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.stationSearchKeyword = '',
  });

  final List<SingleStationItem> list;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int page;
  final bool hasMore;
  final String stationSearchKeyword;

  SingleStationState copyWith({
    List<SingleStationItem>? list,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? stationSearchKeyword,
  }) {
    return SingleStationState(
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
class SingleStation extends _$SingleStation {
  @override
  SingleStationState build() {
    return const SingleStationState();
  }

  void setStationSearchKeyword(String keyword) {
    state = state.copyWith(stationSearchKeyword: keyword);
  }

  /// 列表加载（refresh=true 刷新重置页码；refresh=false 加载更多）
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
        'name_cn': state.stationSearchKeyword,
        ...?params,
      };
      final resp = await getSingleStationList(query);
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
