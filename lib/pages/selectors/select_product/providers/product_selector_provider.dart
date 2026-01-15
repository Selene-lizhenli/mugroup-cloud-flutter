import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductSelectorState {
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final List<Sample> products;
  final Set<int> selectedIds;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final String? currentSearch;

  const ProductSelectorState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.products = const [],
    this.selectedIds = const {},
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = true,
    this.currentSearch,
  });

  ProductSelectorState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    List<Sample>? products,
    Set<int>? selectedIds,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    String? currentSearch,
  }) {
    return ProductSelectorState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      products: products ?? this.products,
      selectedIds: selectedIds ?? this.selectedIds,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      currentSearch: currentSearch ?? this.currentSearch,
    );
  }
}

class ProductSelectorNotifier extends StateNotifier<ProductSelectorState> {
  final int? supplierId;

  ProductSelectorNotifier(this.supplierId) : super(const ProductSelectorState()) {
    if (supplierId != null) {
      fetchProducts();
    }
  }

  Future<void> fetchProducts({String? search, bool reset = true}) async {
    if (supplierId == null) return;
    
    final isSearchChanged = search != state.currentSearch;
    final shouldReset = reset || isSearchChanged;
    
    // 如果搜索关键词改变，重置分页
    if (shouldReset) {
      state = state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        error: null,
        currentPage: 1,
        currentSearch: search,
      );
    } else {
      // 加载更多时，只设置 isLoadingMore
      state = state.copyWith(isLoadingMore: true, error: null);
    }
    
    try {
      final page = shouldReset ? 1 : state.currentPage + 1;
      final res = await getSamples(queryParameters: {
        'supplier_id': supplierId,
        if (search != null && search.isNotEmpty) 'search': search,
        'pageSize': 20,
        'page': page,
      });
      
      final products = res.data;
      final totalPages = res.meta?.pagination?.totalPages ?? 1;
      final hasMore = page < totalPages;
      
      logger.d('fetchProducts: loaded ${products.length} items, page $page/$totalPages');
      
      if (shouldReset) {
        state = state.copyWith(
          products: products,
          isLoading: false,
          currentPage: 1,
          totalPages: totalPages,
          hasMore: hasMore,
          currentSearch: search,
        );
      } else {
        // 加载更多时，追加数据
        final updatedProducts = [...state.products, ...products];
        state = state.copyWith(
          products: updatedProducts,
          isLoadingMore: false,
          currentPage: page,
          totalPages: totalPages,
          hasMore: hasMore,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) {
      return;
    }
    await fetchProducts(search: state.currentSearch, reset: false);
  }

  void toggleSelect(int id) {
    final newSelectedIds = Set<int>.from(state.selectedIds);
    if (newSelectedIds.contains(id)) {
      newSelectedIds.remove(id);
    } else {
      newSelectedIds.add(id);
    }
    state = state.copyWith(selectedIds: newSelectedIds);
  }

  void selectAll(List<int> ids) {
    state = state.copyWith(selectedIds: Set<int>.from(ids));
  }

  void deselectAll() {
    state = state.copyWith(selectedIds: const {});
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: const {});
  }
}

final productSelectorProvider = StateNotifierProvider.family<
    ProductSelectorNotifier, ProductSelectorState, int?>(
  (ref, supplierId) => ProductSelectorNotifier(supplierId),
);

