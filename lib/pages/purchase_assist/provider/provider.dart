import 'package:cloud/models/purchase_assist.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/services/purchase_assist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// 比价助手主页面状态
class PurchaseAssistState implements MuListState {
  const PurchaseAssistState({
    this.hasSearched = false,
    this.productList = const [],
    this.taskList = const [],
    this.taskId,
    this.taskDetail,
    this.loadTaskList,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.searchKeyword = '',
    this.searchImagePaths = const [],
    this.selectedPlatform = 'cloud',
  });

  final bool hasSearched;
  final List<PurchaseAssistSearchProduct> productList;
  final List<PurchaseAssistTaskListItem> taskList;
  final List<PurchaseAssistTaskDetailItem?>? loadTaskList;
  final int? taskId;
  final List<PurchaseAssistTaskDetailItem?>? taskDetail;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int page;
  final bool hasMore;
  final String searchKeyword;
  final List<String> searchImagePaths;
  final String selectedPlatform;

  PurchaseAssistState copyWith({
    bool? hasSearched,
    List<PurchaseAssistSearchProduct>? productList,
    List<PurchaseAssistTaskListItem>? taskList,
    List<PurchaseAssistTaskDetailItem?>? taskDetail,
    int? taskId,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? searchKeyword,
    List<String>? searchImagePaths,
    String? selectedPlatform,
  }) {
    return PurchaseAssistState(
      hasSearched: hasSearched ?? this.hasSearched,
      productList: productList ?? this.productList,
      taskList: taskList ?? this.taskList,
      taskDetail: taskDetail ?? this.taskDetail,
      taskId: taskId ?? taskId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      searchImagePaths: searchImagePaths ?? this.searchImagePaths,
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
    );
  }
}

/// 比价助手 Provider：搜索状态与商品列表，接口占位待补充
@riverpod
class PurchaseAssist extends _$PurchaseAssist {
  @override
  PurchaseAssistState build() {
    return const PurchaseAssistState();
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  void setSearchImagePaths(List<String> paths) {
    state = state.copyWith(searchImagePaths: paths);
  }

  void setSelectedPlatform(String platform) {
    state = state.copyWith(selectedPlatform: platform);
  }

  /// 执行搜索：标记已搜索，搜索框滑到顶部，并触发商品列表加载
  Future<void> doSearch() async {
    state = state.copyWith(hasSearched: true, errorMessage: null);
    await loadProducts(refresh: true);
  }

  void clearSearch() {
    state = state.copyWith(
      hasSearched: false,
      productList: [],
      searchKeyword: '',
      searchImagePaths: [],
      page: 1,
      hasMore: true,
      errorMessage: null,
    );
  }

  void setTaskId(id) {
    state = state.copyWith(taskId: id);
  }

  /// 加载商品列表（接口占位，后续替换为真实 API）
  Future<void> loadProducts(
      {bool refresh = true, Map<String, dynamic>? params}) async {
    final nextPage = refresh ? 1 : state.page;
    state = state.copyWith(
      isLoading: refresh ? true : state.isLoading,
      isLoadingMore: refresh ? false : true,
      errorMessage: null,
    );
    try {
      final data = {
        'keywords': state.searchKeyword,
        'page': nextPage,
        'pageSize': 20,
        'platform': params?['platform'] ?? state.selectedPlatform,
      };
      final resp = await getMultiPlatformSearch(data);
      final result = resp.data;
      const pageSize = 20;
      final hasMore = data.length >= pageSize;
      state = state.copyWith(
        productList: refresh ? result : [...state.productList, ...result],
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

  /// 比价任务列表
  Future<void> loadTaskList({bool refresh = true}) async {
    final nextPage = refresh ? 1 : state.page;
    state = state.copyWith(
      isLoading: refresh ? true : state.isLoading,
      isLoadingMore: refresh ? false : true,
      errorMessage: null,
    );
    const pageSize = 20;
    try {
      final resp = await getProductComparisonTasks({
        'page': nextPage,
        'pageSize': pageSize,
      });
      final data = resp.data; // 占位
      final hasMore = data.length >= pageSize;
      state = state.copyWith(
        taskList: refresh ? data : [...state.taskList, ...data],
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

  /// 比价任务详情
  Future<void> loadTaskDetail({bool refresh = true}) async {
    // taskId
    if (state.taskId == null) return;
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );
    try {
      final resp = await getProductComparisonTaskDetail(state.taskId!);
      final data = resp.data;
      state = state.copyWith(
        taskDetail: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
