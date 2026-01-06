import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectedProduct {
  final int id;
  final String sku;
  final String image;
  final String supplierPrice;
  final String qty;
  final String name;

  const SelectedProduct({
    required this.id,
    required this.sku,
    required this.image,
    required this.supplierPrice,
    required this.qty,
    required this.name,
  });

  SelectedProduct copyWith({
    String? supplierPrice,
    String? qty,
  }) {
    return SelectedProduct(
      id: id,
      sku: sku,
      image: image,
      supplierPrice: supplierPrice ?? this.supplierPrice,
      qty: qty ?? this.qty,
      name: name,
    );
  }
}

class ProductBatchImportState {
  final bool isLoading;
  final String? error;
  final int? supplierId;
  final String? supplierName;
  final List<Sample> products;
  final List<SelectedProduct> selected;

  const ProductBatchImportState({
    this.isLoading = false,
    this.error,
    this.supplierId,
    this.supplierName,
    this.products = const [],
    this.selected = const [],
  });

  ProductBatchImportState copyWith({
    bool? isLoading,
    String? error,
    int? supplierId,
    String? supplierName,
    List<Sample>? products,
    List<SelectedProduct>? selected,
  }) {
    return ProductBatchImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      products: products ?? this.products,
      selected: selected ?? this.selected,
    );
  }
}

class ProductBatchImportNotifier
    extends StateNotifier<ProductBatchImportState> {
  ProductBatchImportNotifier() : super(const ProductBatchImportState());

  Future<void> setSupplier(int id, String name) async {
    state = state.copyWith(
      supplierId: id,
      supplierName: name,
      isLoading: true,
      error: null,
      products: [],
      selected: [],
    );
    await fetchProducts();
  }

  Future<void> fetchProducts({String? search}) async {
    if (state.supplierId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
        // final res = await getMarketProducts(queryParameters: {
      //   'supplier_id': supplierId,
      //   'pageSize': 30,
      //   'page': 1,
      // });
 
      final res = await getSamples(queryParameters: {
        'supplier_id': state.supplierId,
        'search': search,
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

  void toggleSelect(Sample sample) {
    final sampleId = sample.id ?? -1;
    final exists = state.selected.any((element) => element.id == sampleId);
    if (exists) {
      state = state.copyWith(
        selected: state.selected
            .where((e) => e.id != sampleId)
            .toList(growable: false),
      );
    } else {
      final item = SelectedProduct(
        id: sampleId,
        sku: sample.productNo ?? '',
        image: sample.cover ?? '',
        supplierPrice: '',
        qty: '1',
        name: sample.name,
      );
      state = state.copyWith(selected: [...state.selected, item]);
    }
  }

  void updateSelectedPrice(int id, String price) {
    state = state.copyWith(
      selected: state.selected
          .map((e) => e.id == id ? e.copyWith(supplierPrice: price) : e)
          .toList(growable: false),
    );
  }

  void updateSelectedQty(int id, String qty) {
    state = state.copyWith(
      selected: state.selected
          .map((e) => e.id == id ? e.copyWith(qty: qty) : e)
          .toList(growable: false),
    );
  }

  void removeSelected(int id) {
    state = state.copyWith(
      selected: state.selected.where((e) => e.id != id).toList(growable: false),
    );
  }
}

final productBatchImportProvider =
    StateNotifierProvider<ProductBatchImportNotifier, ProductBatchImportState>(
        (ref) => ProductBatchImportNotifier());
