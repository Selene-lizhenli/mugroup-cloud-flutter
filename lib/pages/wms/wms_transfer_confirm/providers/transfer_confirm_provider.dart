import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/models/state.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer_confirm_provider.g.dart';

@riverpod
class TransferConfirmProvider extends _$TransferConfirmProvider {
  @override
  State build() {
    const defaultState = State(
      items: [],
    );
    return defaultState;
  }

  void clear() {
    state = state.copyWith(
      items: [],
    );
  }

  set items(List<TransferConfirmItem> items) {
    state = state.copyWith(items: items);
  }

  TransferConfirmItem? getItemByProduct(Sample product) {
    return state.items.firstWhereOrNull((item) =>
        item.product.id == product.id ||
        item.product.productNo == product.productNo ||
        item.product.barcode == product.barcode);
  }

  void setProduct(Sample product, int count) {
    final item = getItemByProduct(product);
    final items = [...state.items];

    if (item != null) {
      item.count = count;
    } else {
      items.insert(0, TransferConfirmItem(product: product, count: count));
    }

    state = state.copyWith(items: items);
  }
}
