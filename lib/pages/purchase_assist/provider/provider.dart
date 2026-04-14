import 'package:cloud/models/purchase_assist/meta.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/services/purchase_assist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

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
    this.searchImages = const [],
    this.searchMedia,
    this.searchMediaList = const [],
    this.selectedPlatform = 'cloud',
    this.selectedCountry = 'CA',
    this.sortOrder,
    this.priceMin,
    this.priceMax,
    this.taskDetailMeta,
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
  final List<dynamic> searchImages;
  final TemporaryMedia? searchMedia;
  final List<TemporaryMedia> searchMediaList;
  final String selectedPlatform;
  final String? selectedCountry;

  /// 排序：'price_desc' 价格降序，'price_asc' 价格升序
  final String? sortOrder;
  final String? priceMin;
  final String? priceMax;
  final PurchaseAssistMeta? taskDetailMeta;

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
    TemporaryMedia? searchMedia,
    List<TemporaryMedia>? searchMediaList,
    String? selectedPlatform,
    String? selectedCountry,
    Object? sortOrder = _unset,
    Object? priceMin = _unset,
    Object? priceMax = _unset,
    PurchaseAssistMeta? taskDetailMeta,
  }) {
    return PurchaseAssistState(
      hasSearched: hasSearched ?? this.hasSearched,
      productList: productList ?? this.productList,
      taskList: taskList ?? this.taskList,
      taskDetail: taskDetail ?? this.taskDetail,
      taskId: taskId ?? this.taskId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      searchImages: searchImagePaths ?? this.searchImages,
      searchMedia: searchMedia ?? this.searchMedia,
      searchMediaList: searchMediaList ?? this.searchMediaList,
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      sortOrder:
          identical(sortOrder, _unset) ? this.sortOrder : sortOrder as String?,
      priceMin:
          identical(priceMin, _unset) ? this.priceMin : priceMin as String?,
      priceMax:
          identical(priceMax, _unset) ? this.priceMax : priceMax as String?,
      taskDetailMeta: taskDetailMeta ?? this.taskDetailMeta,
    );
  }
}

/// 排序选项常量
const String kSortPriceDesc = 'price_desc';
const String kSortPriceAsc = 'price_asc';

double _parseCleanPrice(String? priceStr) {
  if (priceStr == null || priceStr.isEmpty) return 0.0;

  try {
    String singlePrice = priceStr.split('-').first.trim();

    String cleanStr = singlePrice.replaceAll(RegExp(r'[^\d.]'), '');

    return double.tryParse(cleanStr) ?? 0.0;
  } catch (e) {
    return 0.0;
  }
}

/// 按价格前端排序；默认（null/空）不排序，保持接口返回顺序
List<PurchaseAssistSearchProduct> _sortProductsByPrice(
  List<PurchaseAssistSearchProduct> list,
  String? sortOrder,
) {
  if (sortOrder == 'default' || sortOrder == null || sortOrder.isEmpty) {
    return list;
  }

  final sorted = List<PurchaseAssistSearchProduct>.from(list);

  if (sortOrder == kSortPriceDesc) {
    sorted.sort((a, b) {
      final va = _parseCleanPrice(a.price);
      final vb = _parseCleanPrice(b.price);
      // 降序：大的在前
      return vb.compareTo(va);
    });
  } else if (sortOrder == kSortPriceAsc) {
    sorted.sort((a, b) {
      final va = _parseCleanPrice(a.price);
      final vb = _parseCleanPrice(b.price);
      // 升序：小的在前
      return va.compareTo(vb);
    });
  }
  return sorted;
}

/// 比价助手 Provider：搜索状态与商品列表，接口占位待补充
@riverpod
class PurchaseAssist extends _$PurchaseAssist {
  @override
  PurchaseAssistState build() {
    return const PurchaseAssistState();
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword, hasSearched: true);
  }

  void setSearchMedia(TemporaryMedia? media) {
    state = state.copyWith(searchMedia: media, hasSearched: true);
  }

  /// 添加上传的搜索图片（用于展示与搜索）
  void addSearchMedia(TemporaryMedia media) {
    state = state.copyWith(
      searchMedia: media,
      hasSearched: true,
      searchMediaList: [...state.searchMediaList, media],
    );
  }

  /// 移除已上传的搜索图片，并重新切换当前选中项、刷新该图的搜索结果
  Future<void> removeSearchMedia(int index) async {
    final list = List<TemporaryMedia>.from(state.searchMediaList)
      ..removeAt(index);
    // 删除后优先选中同位置图片，若越界则选最后一张
    final newIndex = list.isEmpty ? -1 : index.clamp(0, list.length - 1);
    final newMedia = list.isEmpty ? null : list[newIndex];
    state = state.copyWith(
      searchMedia: newMedia,
      searchMediaList: list,
    );
    if (newMedia != null) {
      await loadProducts(params: {"media_id": newMedia.id});
    } else {
      state = state.copyWith(hasSearched: false, productList: []);
    }
  }

  void setSelectedPlatform(String platform) {
    state = state.copyWith(selectedPlatform: platform);
  }

  void setSortOrder(String? order) {
    state = state.copyWith(sortOrder: order);
  }

  void setPriceRange(String? min, String? max) {
    state = state.copyWith(priceMin: min, priceMax: max);
  }

  void setSelectedCountry(String country) {
    state = state.copyWith(selectedCountry: country);
  }

  void clearSearch() {
    state = state.copyWith(
      hasSearched: false,
      productList: [],
      searchKeyword: '',
      searchImagePaths: [],
      searchMedia: null,
      searchMediaList: [],
      sortOrder: null,
      priceMin: null,
      priceMax: null,
      page: 1,
      hasMore: true,
      errorMessage: null,
    );
  }

  void setTaskId(id) {
    state = state.copyWith(taskId: id);
  }

  void resetFilterContent() {
    state = state.copyWith(
      sortOrder: "default",
      priceMin: '',
      priceMax: '',
    );
    loadProducts(refresh: true, params: {
      "sortOrder": 'default',
      "priceMin": '',
      "priceMax": '',
    });
  }

  List<PurchaseAssistSearchProduct> _filterProductsByPrice(
      List<PurchaseAssistSearchProduct> list) {
    if ((state.priceMin == null || state.priceMin!.isEmpty) &&
        (state.priceMax == null || state.priceMax!.isEmpty)) {
      return list;
    }

    final double min = double.tryParse(state.priceMin ?? '') ?? 0.0;

    final double max = (state.priceMax == null || state.priceMax!.isEmpty)
        ? double.infinity
        : (double.tryParse(state.priceMax!) ?? double.infinity);

    return list.where((item) {
      final double itemPrice = _parseCleanPrice(item.price);
      final bool match = itemPrice >= min && itemPrice <= max;

      return match;
    }).toList();
  }

  /// 加载商品列表（接口占位，后续替换为真实 API）
  Future<void> loadProducts(
      {bool refresh = true, Map<String, dynamic>? params}) async {
    final nextPage = refresh ? 1 : state.page;
    state = state.copyWith(
      isLoading: refresh ? true : state.isLoading,
      isLoadingMore: refresh ? false : true,
      errorMessage: null,
      hasSearched: true,
    );
    try {
      final data = <String, dynamic>{
        'page': nextPage,
        'pageSize': 20,
        'media_id': params?['media_id'] ?? state.searchMedia?.id,
        'platform': params?['platform'] ?? state.selectedPlatform,
      };
      // 只有当关键字有值且非空时才追加 keywords 字段
      final keyword = state.searchKeyword.trim();
      final platform = params?['platform'] ?? state.selectedPlatform;

      // 如果平台既不是 alibabaglobal 也不是 amazon，则赋值关键词
      if (platform != 'alibabaglobal' && platform != 'amazon') {
        data['keywords'] = keyword;
      }

      if (platform == 'amazon') {
        data['country'] = params?['country'] ?? state.selectedCountry ?? 'CA';
      }

      if (state.priceMax != null && state.priceMax!.isNotEmpty ||
          state.priceMin != null && state.priceMin!.isNotEmpty) {
        data["priceRange"] = [state.priceMin, state.priceMax];
      }
      final resp = await getMultiPlatformSearch(data);
      var result = resp as List<PurchaseAssistSearchProduct>;

      final currentPlatform = params?['platform'] ?? state.selectedPlatform;
      if (currentPlatform != 'cloud') {
        result = _filterProductsByPrice(result);
      }

      // 前端按价格排序
      result =
          _sortProductsByPrice(result, params?['sortOrder'] ?? state.sortOrder);
      const pageSize = 20;
      final hasMore = data.length >= pageSize;
      state = state.copyWith(
        productList: refresh
            ? result
            : _sortProductsByPrice([...state.productList, ...result],
                params?['sortOrder'] ?? state.sortOrder),
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
      state = state.copyWith(
        taskDetail: resp.data,
        taskDetailMeta: resp.meta ??
            const PurchaseAssistMeta(
                pagination: PurchaseAssistPagination(
                    total: 0, count: 0, totalPages: 0)),
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
