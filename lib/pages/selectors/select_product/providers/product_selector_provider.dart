import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductSelectorState {
  final bool isLoading;
  final String? error;
  final List<Sample> products;
  final Set<int> selectedIds;

  const ProductSelectorState({
    this.isLoading = false,
    this.error,
    this.products = const [],
    this.selectedIds = const {},
  });

  ProductSelectorState copyWith({
    bool? isLoading,
    String? error,
    List<Sample>? products,
    Set<int>? selectedIds,
  }) {
    return ProductSelectorState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
      selectedIds: selectedIds ?? this.selectedIds,
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

  Future<void> fetchProducts({String? search}) async {
    if (supplierId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await getSamples(queryParameters: {
        'supplier_id': supplierId,
        if (search != null && search.isNotEmpty) 'search': search,
        'pageSize': 30,
        'page': 1,
      });
      final products = res.data;
      logger.d('fetchProducts: loaded ${products.length} items');
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
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

