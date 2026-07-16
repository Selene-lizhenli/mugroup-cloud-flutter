import 'package:cloud/app/app.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/services/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _productViewModeKey = 'quote_detail_product_view_mode';

ProductViewMode _resolveProductViewMode() {
  final saved = app.prefs.getString(_productViewModeKey);
  for (final mode in ProductViewMode.values) {
    if (mode.name == saved) return mode;
  }
  return ProductViewMode.time;
}

class QuoteDetailNotifier extends StateNotifier<QuoteDetailState> {
  QuoteDetailNotifier()
      : super(QuoteDetailState.initial(
          productViewMode: _resolveProductViewMode(),
        ));

  Future<void> fetchQuoteDetail(int id) async {
    if (id <= 0) return;

    //  同时标记 loading
    state = state.copyWith(
      isBaseLoading: true,
      isProductLoading: true,
      isTemplateLoading: true,
      baseError: null,
      productError: null,
      templateError: null,
      dynamicTemplates: const [],
    );

    //  并发请求
    await Future.wait(
        [_fetchBaseInfo(id), _fetchProducts(id, 1), loadExportTemplate()]);
  }

  Future<void> loadExportTemplate() async {
    state = state.copyWith(isTemplateLoading: true, templateError: null);
    try {
      final resp = await getShowroomQuotationExportTemplate();
      final data = resp.data;
      state = state.copyWith(
        isTemplateLoading: false,
        dynamicTemplates: data,
      );
    } catch (e) {
      state = state.copyWith(
        isTemplateLoading: false,
        templateError: e.toString(),
      );
    }
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
      // 按创建时间排序,最新在前
      final list = List<QuotationSample>.from(resp.data)
        ..sort((a, b) {
          final aTime = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
          final bTime = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
          return bTime.compareTo(aTime);
        });
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
    state = QuoteDetailState.initial(
      productViewMode: _resolveProductViewMode(),
    );
  }

  void toggleProductViewMode() {
    final next = state.productViewMode == ProductViewMode.supplier
        ? ProductViewMode.time
        : ProductViewMode.supplier;
    state = state.copyWith(productViewMode: next);
    app.prefs.setString(_productViewModeKey, next.name);
  }
}

final quoteDetailProvider =
    StateNotifierProvider<QuoteDetailNotifier, QuoteDetailState>(
  (ref) => QuoteDetailNotifier(),
);
