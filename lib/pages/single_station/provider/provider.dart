import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/services/single_station.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// 独立站列表状态
class SingleStationState implements MuListState {
  const SingleStationState({
    this.list = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.stationSearchKeyword = '',
    this.stationId,
    this.inquiryId,
    this.stationSampleList = const [],
    this.inquiriesMessageList = const [],
    this.inquiriesProductList = const [],
  });

  final List<SingleStationItem> list; // 站点列表
  final List<SingleStationSample> stationSampleList; // 站点样品列表
  final List<SingleStationSample> inquiriesProductList; // 站点样品列表
  final List<SingleStationInquiries> inquiriesMessageList; // 询盘消息列表
  final bool isLoading; // 是否加载中
  final bool isLoadingMore; // 是否加载更多
  final String? errorMessage; // 错误信息
  final int page; // 页码
  final bool hasMore; // 是否有更多数据
  final String stationSearchKeyword; // 站点搜索关键词
  final int? stationId; // 站点ID
  final int? inquiryId; // 询盘记录的ID

  SingleStationState copyWith({
    List<SingleStationItem>? list,
    List<SingleStationSample>? stationSampleList,
    List<SingleStationSample>? inquiriesProductList,
    List<SingleStationInquiries>? inquiriesMessageList,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? stationSearchKeyword,
    int? stationId,
    int? inquiryId,
  }) {
    return SingleStationState(
      list: list ?? this.list,
      stationSampleList: stationSampleList ?? this.stationSampleList,
      inquiriesProductList: inquiriesProductList ?? this.inquiriesProductList,
      inquiriesMessageList: inquiriesMessageList ?? this.inquiriesMessageList,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      stationSearchKeyword: stationSearchKeyword ?? this.stationSearchKeyword,
      stationId: stationId ?? this.stationId,
      inquiryId: inquiryId ?? this.inquiryId,
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

  void setStationId(int? id) {
    state = state.copyWith(stationId: id);
  }

  void cleanSearchKeyWord() {
    state = state.copyWith(stationSearchKeyword: '');
  }

  void cleanStationSamples() {
    state = state.copyWith(stationSampleList: []);
  }

  void cleanStationInquiriesMessages() {
    state = state.copyWith(inquiriesMessageList: []);
  }

  void setInquiryId(int? id) {
    state = state.copyWith(inquiryId: id);
  }

  void cleanInquiriesProducts() {
    state = state.copyWith(inquiriesProductList: []);
  }

  /// 独立站列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
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

  /// 独立站样品列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
  Future<void> loadStationSamples({
    bool refresh = true,
    Map<String, dynamic>? params,
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
        'station_id': params?['station_id'] ?? state.stationId,
      }; 
      final resp = await getStationSamplesList(query);
      final data = resp.data;
      final hasMore = (data.length >= 20);
      state = state.copyWith(
        stationSampleList:
            refresh ? data : [...state.stationSampleList, ...data],
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

  /// 询盘列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
  Future<void> loadInquiriesMessages({
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
        'name': state.stationSearchKeyword,
        ...?params,
      };
      final resp = await getInquiriesList(query);
      final data = resp.data;
      final hasMore = (data.length >= 20);
      state = state.copyWith(
        inquiriesMessageList:
            refresh ? data : [...state.inquiriesMessageList, ...data],
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

  /// 询盘样品列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
  Future<void> loadInquiriesProducts({
    bool refresh = true,
    Map<String, dynamic>? params,
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
        'inquiry_id': params?['inquiry_id'] ?? state.inquiryId,
      };
      logger.d('loadInquiriesProducts query: $query');
      final resp = await getInquiriesProductList(query);
      final data = resp.data;
      final hasMore = (data.length >= 20);
      state = state.copyWith(
        inquiriesProductList:
            refresh ? data : [...state.inquiriesProductList, ...data],
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
