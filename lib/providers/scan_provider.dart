import 'dart:async';

import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/router/router.gr.dart';
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
    logger.d("scan 初始化 拉");

    BroadcastReceiver receiver = BroadcastReceiver(
      names: [
        "com.android.decodewedge.decode_action",
      ],
    );
    FlutterDataWedge dw = FlutterDataWedge(profileName: "云链");
    StreamSubscription onScanSubscription =
        dw.onScanResult.listen((ScanResult result) {
      _handle(result.data);
    });

    final sub = receiver.messages.listen((message) async {
      String? scanString =
          message.data?["com.android.decode.intentwedge.barcode_string"];
      if (scanString == null) {
        return;
      }

      String barcodeString = scanString.toString().trim();

      _handle(barcodeString);
    });

    ref.onDispose(() {
      logger.d("scan dispos 拉");

      sub.cancel();
      receiver.stop();
      onScanSubscription.cancel();
    });

    receiver.start();
    return <String>[];
  }

  _handle(String barcodeString) {
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

      // 默认不处理
      return;
    }

    state = [barcodeString];
  }
}
