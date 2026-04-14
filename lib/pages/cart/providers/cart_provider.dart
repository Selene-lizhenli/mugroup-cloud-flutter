import 'dart:convert';

import 'package:cloud/app/app.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/delivery.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/providers/scan_provider.dart';
import 'package:cloud/services/sample.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

var cacheKey = "cart_v1";

@riverpod
class Cart extends _$Cart {
  @override
  State build() {
    final cloud = ref.watch(coreProvider).value!;
    final user = authNotifier.user;
    //监听红外线扫描事件
    final scanProviderSubscription = ref.listen(
      scanProvider,
      (previous, next) {
        for (var barcode in next) {
          addItemByBarcode(barcode);
        }
      },
    );

    handleAuthChange() {
      logger.d(authNotifier.user);
    }

    authNotifier.addListener(handleAuthChange);
    ref.onDispose(() {
      logger.d("购物车 dispos 拉");
      scanProviderSubscription.close();
      authNotifier.removeListener(handleAuthChange);
    });

    const defaultQuotationInfo = QuotationInfo(true, false, 'CNY', null, null);
    final defaultCarts = [
      if (user?.permissions?.contains('showroom.quotation.store') ?? false)
        const CartSelect(CartType.quotation),
      if (user?.permissions?.contains("wms.stock_inout.store") ?? false)
        const CartSelect(CartType.stockIn),
      if (user?.permissions?.contains("wms.stock_borrow.store") ?? false)
        const CartSelect(CartType.borrowOut),
      if (user?.permissions?.contains("wms.stock_borrow.store") ?? false)
        const CartSelect(CartType.borrowIn),
      if (user?.permissions?.contains('wms.stock_inventory.show') ?? false)
        const CartSelect(CartType.inout),

      // if (user?.permissions?.contains('showroom.stock_delivery.store') ?? false)
      //   const CartSelect(CartType.deliveryOut),
    ];
    final defaultCart = defaultCarts.length == 1 ? defaultCarts[0] : null;

    final defaultState = State(
      items: [],
      carts: defaultCarts,
      quotationInfo: defaultQuotationInfo,
      type: defaultCart?.type,
      cartName: defaultCart != null ? cartNames[defaultCart.type] : null,
    );

    if (cloud.currentTenant?.id == TenantConstants.warehouseMainTenantId) {
      cacheKey = "cart_v1";
    } else if (cloud.currentTenant?.id != null) {
      cacheKey = "tenant${cloud.currentTenant!.id!}_cart_v1";
    }

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
        quotationInfo: defaultQuotationInfo.copyWith(
          showPrice: cacheState.quotationInfo?.showPrice,
          curreny: cacheState.quotationInfo?.curreny,
          exchange: cacheState.quotationInfo?.exchange,
          commissionRate: cacheState.quotationInfo?.commissionRate,
        ),
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

  set delivery(Delivery? delivery) {
    state = state.copyWith(delivery: delivery);
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
    final barcode = sample.barcode?.trim(); //pda使用条形码

    return state.items.firstWhereOrNull((item) {
      final itemBarcode = item.sample.barcode?.trim();

      final sameId = item.sample.id == sample.id;
      final sameBarcode =
          barcode != null && barcode.isNotEmpty && itemBarcode == barcode;

      return sameId || sameBarcode;
    });
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

  void setSapleByProductId(List<Map<String, dynamic>> items) {
    final updateMap = {
      for (final item in items)
        item['product_id'] as int: item['inout_qty'] as int,
    };

    final newItems = state.items
        .where((item) => updateMap.containsKey(item.sample.id))
        .map((item) => item.copyWith(count: updateMap[item.sample.id]!))
        .toList();

    state = state.copyWith(items: newItems);
    save();
  }
}
