import 'dart:async';

import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/warehouse.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_provider.g.dart';

@riverpod
class Scan extends _$Scan {
  /// Classes annotated by `@riverpod` **must** define a [build] function.
  /// This function is expected to return the initial state of your shared state.
  /// It is totally acceptable for this function to return a [Future] or [Stream] if you need to.
  /// You can also freely define parameters on this method.
  @override
  List<String> build() {
    logger.d("scan 初始化 啦");

    BroadcastReceiver receiver = BroadcastReceiver(
      names: [
        "com.android.decodewedge.decode_action",
        "android.intent.ACTION_SCAN_OUTPUT",
      ],
    );
    FlutterDataWedge dw = FlutterDataWedge(profileName: "云链");
    StreamSubscription onScanSubscription =
        dw.onScanResult.listen((ScanResult result) {
      unawaited(_handle(result.data.trim()));
    });

    final sub = receiver.messages.listen((message) async {
      logger.d("收到广播啦: ${message.data}");
      final scanString =
          message.data?["com.android.decode.intentwedge.barcode_string"] ??
              message.data?["barcode"];
      if (scanString == null) {
        return;
      }

      String barcodeString = scanString.toString().trim();
      if (barcodeString.isEmpty) {
        return;
      }

      unawaited(_handle(barcodeString));
    });

    ref.onDispose(() {
      logger.d("scan dispos 啦");

      sub.cancel();
      receiver.stop();
      onScanSubscription.cancel();
    });

    receiver.start();
    return <String>[];
  }

  Future<void> _handle(String barcodeString) async {
    if (isUrl(barcodeString)) {
      // 判断是否是调拨单
      if (true) {
        RegExp transferExp = RegExp(r'wms/transfer/(.*)');
        final match = transferExp.firstMatch(barcodeString);

        /// 解析结果为调拨单
        if (match != null) {
          final orderNo = match.group(1)!;

          app.router.push(WmsTransferRoute(code: orderNo));
          return;
        }
      }

      //判断是不是出货单
      if (true) {
        RegExp deliveryExp = RegExp(r'wms/delivery/(.*)');
        final match = deliveryExp.firstMatch(barcodeString);

        /// 解析结果为出货单
        if (match != null) {
          final orderNo = match.group(1)!;

          app.router.push(WmsDeliveryRoute(code: orderNo));
          return;
        }
      }

      //判断是不是报价单
      if (true) {
        RegExp quotationExp = RegExp(r'showroom/quotations/(.*)');
        final matchQuotation = quotationExp.firstMatch(barcodeString);
        if (matchQuotation != null) {
          final quoteNo = matchQuotation.group(1)!;

          app.router.push(ShowroomQuotationsRoute(quoteNo: quoteNo));
          return;
        }
      }

      // 默认不处理
      return;
    }

    RegExp regReceiptId = RegExp(r'^receiptId=(\d+)');
    Match? match = regReceiptId.firstMatch(barcodeString);
    if (match != null) {
      String matchedReceiptId = match.group(1)!;
      int receiptId = int.tryParse(matchedReceiptId) ?? -1;
      if (receiptId != -1) {
        _openWarehouseReceiptDetail(receiptId);
      }
      return;
    }

    RegExp regReceiptHashid = RegExp(r'^receiptHashid=([A-Za-z0-9]+)$');
    match = regReceiptHashid.firstMatch(barcodeString);
    if (match != null) {
      await _openWarehouseReceiptDetailByHashid(match.group(1)!);
      return;
    }

    RegExp regReceiptItemId = RegExp(r'^receiptItemId=(\d+)');
    match = regReceiptItemId.firstMatch(barcodeString);
    if (match != null) {
      String receiptItemId = match.group(1)!;
      int itemId = int.tryParse(receiptItemId) ?? -1;
      if (itemId != -1) {
        _openWarehouseReceiptItemDetail(itemId);
      }
      return;
    }

    RegExp regReceiptItemHashid = RegExp(r'^receiptItemHashid=([A-Za-z0-9]+)$');
    match = regReceiptItemHashid.firstMatch(barcodeString);
    if (match != null) {
      await _openWarehouseReceiptItemDetailByHashid(match.group(1)!);
      return;
    }

    // 普通条形码：设置state后跳转到购物车页面
    state = [barcodeString];
    // 如果当前已经在购物车页面，就不需要跳转了
    if (app.router.current.name != CartRoute.name) {
      app.router.push(const CartRoute());
    }
  }

  Future<void> _openWarehouseReceiptItemDetailByHashid(String hashid) async {
    EasyLoading.show(status: '识别入库明细...');
    try {
      final item = await fetchWarehouseReceiptItemByHashid(hashid);
      if (item.id == null) {
        EasyLoading.showError('未找到入库明细');
        return;
      }
      EasyLoading.dismiss();
      _openWarehouseReceiptItemDetail(item.id!);
    } catch (_) {
      EasyLoading.showError('未找到入库明细');
    }
  }

  Future<void> _openWarehouseReceiptDetailByHashid(String hashid) async {
    EasyLoading.show(status: '识别入库单...');
    try {
      final receipt = await fetchWarehouseReceiptByHashid(hashid);
      if (receipt.id == null) {
        EasyLoading.showError('未找到入库单');
        return;
      }
      EasyLoading.dismiss();
      _openWarehouseReceiptDetail(receipt.id!);
    } catch (_) {
      EasyLoading.showError('未找到入库单');
    }
  }

  void _openWarehouseReceiptItemDetail(int itemId) {
    final route = WarehouseReceiptItemDetailRoute(id: itemId);
    if (app.router.current.name == WarehouseReceiptItemDetailRoute.name) {
      app.router.replace(route);
      return;
    }

    app.router.removeWhere(
      (routeData) => routeData.name == WarehouseReceiptItemDetailRoute.name,
    );
    app.router.push(route);
  }

  void _openWarehouseReceiptDetail(int receiptId) {
    final route = WarehouseReceiptDetailRoute(receiptId: receiptId);
    if (app.router.current.name == WarehouseReceiptDetailRoute.name) {
      app.router.replace(route);
      return;
    }

    app.router.removeWhere(
      (routeData) => routeData.name == WarehouseReceiptDetailRoute.name,
    );
    app.router.push(route);
  }
}
