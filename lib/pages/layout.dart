import 'package:auto_route/auto_route.dart';
import 'package:cloud/controllers/scan_controller.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

@RoutePage()
class Layout extends HookConsumerWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      BroadcastReceiver receiver = BroadcastReceiver(
        names: [
          "com.android.decodewedge.decode_action",
        ],
      );

      final sub = receiver.messages.listen((message) async {
        var barcodeString =
            message.data?["com.android.decode.intentwedge.barcode_string"];
        if (barcodeString == null) {
          return;
        }

        barcodeString = barcodeString.toString().trim();

        if (isUrl(barcodeString)) {
          // 判断是否是调拨单
          if (true) {
            RegExp transferExp = RegExp(r'wms/transfer/(.*)');
            final match = transferExp.firstMatch(barcodeString);

            /// 解析结果为调拨单
            if (match != null) {
              final orderNo = match.group(1)!;

              context.router.push(WmsTransferRoute(code: orderNo));
              return;
            }
          }

          // 默认不处理
          return;
        }

        scanConroller.add(barcodeString);
      });

      receiver.start();
      return () {
        sub.cancel();
        receiver.stop();
      };
    }, []);

    final checkVersion = useCallback(() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final checkResp = await silentApi
          .get("https://s3.mugroup.com/global/apks/cloud/version.json");

      Version currentVersion = Version.parse(packageInfo.version);
      Version latestVersion = Version.parse(checkResp.data['version']);

      bool needUpgrade = latestVersion > currentVersion;

      if (!needUpgrade) {
        return;
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("发现新版本"),
              content: Text(checkResp.data['detail']),
              actions: [
                TextButton(
                  child: const Text('升级'),
                  onPressed: () {
                    UpdateModel model = UpdateModel(
                      checkResp.data['url'],
                      "cloud.apk",

                      /// android res/mipmap icon name
                      "ic_launcher",
                      '',
                    );
                    AzhonAppUpdate.update(model);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }, []);

    useEffect(() {
      checkVersion();

      return null;
    }, [checkVersion]);

    return AutoTabsRouter(
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: context.tabsRouter.activeIndex,
            onTap: context.tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "选样车"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
            ],
          ),
        );
      },
    );
  }
}
