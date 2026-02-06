 
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuoteDetailNotifier extends StateNotifier<QuoteDetailState> {
  QuoteDetailNotifier() : super(QuoteDetailState.initial());

  Future<void> fetchQuoteDetail(int id) async {
    if (id <= 0) return;

    //  同时标记 loading
    state = state.copyWith(
      isBaseLoading: true,
      isProductLoading: true,
      baseError: null,
      productError: null,
    );

    //  并发请求
    await Future.wait([
      _fetchBaseInfo(id),
      _fetchProducts(id, 1), 
    ]);
  }

  Future<void> _fetchBaseInfo(int id) async {
    final data = await getQuotationListById(id) as QuotationList?;
    state = state.copyWith(
      isBaseLoading: false,
      baseInfo: data,
    );
  }

  Future<void> _fetchProducts(int id, int page) async {
    try {
      final params = {
        "page": page,
        "pageSize": 100000000,
      };
      final resp = await getQuotationProductListByProductId(id, params);
      final list = resp.data ?? [];
      final total = resp.meta!.pagination!.total.toString();
      final totalPages = resp.meta!.pagination!.totalPages;

      state = state.copyWith(
        isProductLoading: false,
        products: list,
        productTotalCount: total,
        productPage: page,
        productTotalPages: totalPages,
        productError: null,
      );
    } catch (e) {
      state = state.copyWith(
        isProductLoading: false,
        productError: e.toString(),
      );
    }
  }

  // Future<void> _fetchSuppliers(
  //   int id,
  // ) async {
  //   final list = await getQuotationSupplierListById(id);
  //   logger.d('供应商列表：$list');
  //   state = state.copyWith(
  //     isSupplierLoading: false,
  //     suppliers: list,
  //   );
  // }

  /// 对外暴露：切换产品页
  Future<void> fetchProductsPage(int id, int page) async {
    if (id <= 0) return;

    state = state.copyWith(
      isProductLoading: true,
      productError: null,
    );

    await _fetchProducts(id, page);
  }

  void clear() {
    state = QuoteDetailState.initial();
  }
}

final quoteDetailProvider =
    StateNotifierProvider<QuoteDetailNotifier, QuoteDetailState>(
  (ref) => QuoteDetailNotifier(),
);
