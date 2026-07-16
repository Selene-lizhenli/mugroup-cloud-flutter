import 'package:cloud/pages/sample_quotation/models/home_state.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/services/sample.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class SampleQuotation extends _$SampleQuotation {
  @override
  SampleQuotationState build() {
    final sampleQuotationState = SampleQuotationState(
      isLoading: false,
      isLoadingMore: false,
      errorMessage: null,
      page: 1,
      hasMore: true,
      searchKeyword: '',
      list: [],
      productsList: [],
      dynamicTemplates: [],
      baseInfo: null,
    );

    return sampleQuotationState;
  }

  void setSearch(String search) {
    state = state.copyWith(searchKeyword: search);
  }

  Future<void> loadExportTemplate() async {
    final resp = await getShowroomQuotationExportTemplate();
    final data = resp.data;
    state = state.copyWith(dynamicTemplates: data ?? []);
  }

  /// 报价单列表 加载（refresh=true 刷新重置页码；refresh=false 加载更多）
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
        "includes": 'supplyQuotes.supplier.media',
        "search": state.searchKeyword,
        // 'user_id': state.searchKeyword,
        ...?params,
      };
      final resp = await getShowroomQuotation(query);
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

  /// 报价单详情
  Future<void> loadBaseDetail({
    Map<String, dynamic>? params,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );
    try {
      final data = await getQuotationListById(params?['id']);

      state = state.copyWith(
        isLoading: false,
        baseInfo: data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 报价单产品详情  加载（refresh=true 刷新重置页码；refresh=false 加载更多）
  Future<void> loadDetail({
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
        "quotation_id": params?['id'],
      };
      final resp = await getShowroomQuotationDetail(query);
      final data = resp.data;
      final hasMore = (data.length >= 20);
      state = state.copyWith(
        productsList: refresh ? data : [...state.productsList, ...data],
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
