import 'package:cloud/models/sample/sample.dart';
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
