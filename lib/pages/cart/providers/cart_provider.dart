import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/models/state.dart';
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

  void addSample(Sample sample, int count) {
    final items = [...state.items];

    bool include = false;

    for (var (index, item) in items.indexed) {
      if (item.sample.id == sample.id) {
        items[index] = item.copyWith(count: item.count + count);
        include = true;
        break;
      }
    }

    if (!include) {
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
