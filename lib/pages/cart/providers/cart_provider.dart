import 'dart:convert';

import 'package:cloud/app/app.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

const cacheKey = "cart_v1";

@riverpod
class Cart extends _$Cart {
  @override
  State build() {
    const defaultState = State(
      items: [],
      carts: [
        CartSelect(CartType.borrowOut),
        CartSelect(CartType.borrowIn),
        CartSelect(CartType.inout),
        CartSelect(CartType.quotation),
      ],
    );

    final cache = app.prefs.getString(cacheKey);
    if (cache != null) {
      final map = jsonDecode(cache) as Map<String, dynamic>;

      final cacheState = State.fromJson(map);

      return defaultState.copyWith(
        borrow: cacheState.borrow,
        cartName: cacheState.cartName,
        items: cacheState.items,
        transfer: cacheState.transfer,
        type: cacheState.type,
        warehouse: cacheState.warehouse,
      );
    }

    return defaultState;
  }

  set type(CartType type) {
    state = state.copyWith(type: type, cartName: cartNames[type] ?? "选样车");
    save();
  }

  set warehouse(Warehouse? warehouse) {
    state = state.copyWith(warehouse: warehouse);
    save();
  }

  set borrow(Borrow? borrow) {
    state = state.copyWith(borrow: borrow);
    save();
  }

  set transfer(Transfer? transfer) {
    state = state.copyWith(transfer: transfer);
    save();
  }

  void clear() {
    state = state.copyWith(
      items: [],
      warehouse: null,
      borrow: null,
      transfer: null,
    );
    app.prefs.remove(cacheKey);
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
      items.insert(0, CartItem(sample: sample, count: step));
    }

    state = state.copyWith(items: items);
    save();
  }

  void save() {
    final string = json.encode(state.toJson());
    app.prefs.setString(cacheKey, string);
  }

  void setSample(Sample sample, int count) {
    final item = getItemBySample(sample);
    final items = [...state.items];

    if (item != null) {
      item.count = count;
    } else {
      items.insert(0, CartItem(sample: sample, count: count));
    }

    state = state.copyWith(items: items);
    save();
  }

  void removeSample(Sample sample) {
    final items =
        state.items.where((element) => element.sample.id != sample.id);

    state = state.copyWith(items: [...items]);
    save();
  }
}
