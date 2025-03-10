import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  State build() {
    return State(items: [], carts: [
      CartSelect(CartType.borrowOut),
      CartSelect(CartType.borrowIn),
      CartSelect(CartType.quotation),
      CartSelect(CartType.inout),
    ]);
  }

  set type(CartType type) {
    state = state.copyWith(type: type, cartName: cartNames[type] ?? "选样车");
  }

  set warehouse(Warehouse? warehouse) {
    state = state.copyWith(warehouse: warehouse);
  }

  set borrow(Borrow? borrow) {
    state = state.copyWith(borrow: borrow);
  }

  set transfer(Transfer? transfer) {
    state = state.copyWith(transfer: transfer);
  }

  set user(User? user) {
    state = state.copyWith(user: user);
  }

  void clear() {
    state = state.copyWith(
      items: [],
      warehouse: null,
      borrow: null,
      transfer: null,
      user: null,
    );
  }

  CartItem? getItemBySample(Sample sample) {
    return state.items.firstWhereOrNull((item) =>
        item.sample.id == sample.id ||
        item.sample.productNo == sample.productNo ||
        item.sample.barcode == sample.barcode);
  }

  void addSample(Sample sample, int step) {
    final item = getItemBySample(sample);
    final items = [...state.items];

    if (item != null) {
      item.count = item.count + step;
    } else {
      items.add(CartItem(sample: sample, count: step));
    }

    state = state.copyWith(items: items);
  }

  void setSample(Sample sample, int count) {
    final item = getItemBySample(sample);
    final items = [...state.items];

    if (item != null) {
      item.count = count;
    } else {
      items.add(CartItem(sample: sample, count: count));
    }

    state = state.copyWith(items: items);
  }

  void removeSample(Sample sample) {
    final items =
        state.items.where((element) => element.sample.id != sample.id);

    state = state.copyWith(items: [...items]);
  }
}
