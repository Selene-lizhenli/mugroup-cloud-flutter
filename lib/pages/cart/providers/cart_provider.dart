import 'dart:convert';

import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/providers/scan_provider.dart';
import 'package:cloud/services/sample.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

const cacheKey = "cart_v1";

@riverpod
class Cart extends _$Cart {
  @override
  State build() {
    logger.d("购物车 初始化");
    ref.onDispose(() {
      logger.d("购物车 dispos 拉");
    });

    ref.listen(
      scanProvider,
      (previous, next) {
        for (var barcode in next) {
          addItemByBarcode(barcode);
        }
      },
    );

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
        quotationInfo: cacheState.quotationInfo,
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

  void addItemByBarcode(String barcode) async {
    final Sample sample = Sample(barcode: barcode);
    var item = getItemBySample(sample);

    if (item != null) {
      addSample(sample, 1);
      return;
    }

    EasyLoading.show(status: '加载中...');
    var samples = await getSamples(queryParameters: {"barcode": barcode})
        .then((res) => res.data);
    EasyLoading.dismiss();
    if (samples.isEmpty) {
      EasyLoading.showInfo("库中未找到该样品!");
      return;
    }
    for (var item in samples) {
      addSample(item, 1);
    }
  }

  set borrow(Borrow? borrow) {
    state = state.copyWith(borrow: borrow);
    save();
  }

  set transfer(Transfer? transfer) {
    state = state.copyWith(transfer: transfer);
    save();
  }

  set quotationInfo(QuotationInfo? quotationInfo) {
    state = state.copyWith(quotationInfo: quotationInfo);
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
        item.sample.id == sample.id || item.sample.barcode == sample.barcode);
  }

  void addSample(Sample sample, int step) {
    final item = getItemBySample(sample);
    final items = [...state.items];

    if (item != null) {
      items.remove(item);
      items.insert(0, item);
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

  void setSamplePrice(Sample sample, String? price) {
    final item = getItemBySample(sample);
    final items = [...state.items];

    if (item != null) {
      item.price = price;
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
