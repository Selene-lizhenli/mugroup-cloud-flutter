import 'package:cloud/models/sample/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectedProduct {
  final int id;
  final String sku;
  final String image;
  final String qty;
  final String name;
  final String? purchaseCost;

  const SelectedProduct({
    required this.id,
    required this.sku,
    required this.image,
    required this.qty,
    required this.name,
    required this.purchaseCost,
  });

  SelectedProduct copyWith({
    String? supplierPrice,
    String? qty,
  }) {
    return SelectedProduct(
      id: id,
      sku: sku,
      image: image,
      qty: qty ?? this.qty,
      purchaseCost: purchaseCost,
      name: name,
    );
  }
}

class ProductBatchImportState {
  final int? supplierId;
  final String? supplierName;
  final List<SelectedProduct> selected;

  const ProductBatchImportState({
    this.supplierId,
    this.supplierName,
    this.selected = const [],
  });

  ProductBatchImportState copyWith({
    int? supplierId,
    String? supplierName,
    List<SelectedProduct>? selected,
  }) {
    return ProductBatchImportState(
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      selected: selected ?? this.selected,
    );
  }
}

class ProductBatchImportNotifier
    extends StateNotifier<ProductBatchImportState> {
  ProductBatchImportNotifier() : super(const ProductBatchImportState());

  void setSupplier(int id, String name) {
    state = state.copyWith(
      supplierId: id,
      supplierName: name,
      selected: [],
    );
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

  void setSelected(List<Sample> samples) {
    final items = samples
        .where((sample) => sample.id != null)
        .map((sample) => SelectedProduct(
              id: sample.id!,
              sku: sample.productNo ?? '',
              image: sample.cover ?? '',
              purchaseCost: sample.purchaseCost,
              qty: '1',
              name: sample.name,
            ))
        .toList(growable: false);
    state = state.copyWith(selected: items);
  }

  void clearSelected() {
    state = state.copyWith(selected: []);
  }

  void clean() {
    state = state.copyWith(
      supplierId: null,
      supplierName: null,
      selected: [],
    );
  }
}

final productBatchImportProvider =
    StateNotifierProvider<ProductBatchImportNotifier, ProductBatchImportState>(
        (ref) => ProductBatchImportNotifier());
