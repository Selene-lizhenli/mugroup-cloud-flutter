import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  State build() {
    return const State(items: []);
  }

  set type(CartType type) {
    state = state.copyWith(type: type);
  }

  CartItem? getItemBySample(Sample sample) {
    return state.items.firstWhereOrNull((item) =>
        item.sample.id == sample.id ||
        item.sample.productNo == sample.productNo);
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
