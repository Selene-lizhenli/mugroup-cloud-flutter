import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:version/version.dart';

@RoutePage()
class Layout extends HookConsumerWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartState = ref.watch(cartProvider);

    final checkVersion = useCallback(() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final checkResp = await silentApi
          .get("https://s3.mugroup.com/global/apks/cloud/version.json");

      final info = checkResp.data;
      final system = Platform.operatingSystem;
      final systemVersionInfo = info[system];
      if (systemVersionInfo == null) {
        return;
      }

      Version currentVersion = Version.parse(packageInfo.version);
      Version latestVersion = Version.parse(systemVersionInfo['version']);

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
              content: Text(systemVersionInfo['detail']),
              actions: [
                TextButton(
                  child: const Text('升级'),
                  onPressed: () {
                    UpdateModel model = UpdateModel(
                      info['apkUrl'],
                      "cloud.apk",

                      /// android res/mipmap icon name
                      "ic_launcher",
                      info['iosUrl'],
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

    // final items = [
    //   const BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
    //   const BottomNavigationBarItem(icon: Icon(Icons.home), label: "样品"),
    //   BottomNavigationBarItem(
    //     icon: Stack(
    //       clipBehavior: Clip.none,
    //       alignment: Alignment.bottomCenter,
    //       children: [
    //         const Icon(Icons.shopping_cart),
    //         Positioned(
    //           top: -8,
    //           right: -10,
    //           child: TDBadge(
    //             TDBadgeType.message,
    //             color: colorScheme.primary,
    //             textColor: colorScheme.tertiary,
    //             size: TDBadgeSize.large,
    //             showZero: false,
    //             count: cartState.items.length.toString(),
    //           ),
    //         )
    //       ],
    //     ),
    //     label: "选样车",
    //   ),
    //   const BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
    // ];

    // return AutoTabsRouter(
    //   builder: (context, child) {
    //     return Scaffold(
    //       body: child,
    //       bottomNavigationBar: BottomNavigationBar(
    //         type: BottomNavigationBarType.fixed,
    //         currentIndex: context.tabsRouter.activeIndex,
    //         onTap: (index) {
    //           final item = items[index];
    //           if (item.label == "选样车") {
    //             app.container.refresh(cartProvider);
    //           }
    //           debugPrint(
    //               'activeIndex666: ${context.tabsRouter.activeIndex}${items[index].label}');
    //           if (item.label == "我的") {
    //             app.fetchUser();
    //           }
    //           context.tabsRouter.setActiveIndex(index);
    //         },
    //         items: items,
    //         selectedItemColor: colorScheme.primary, // 选中文字 + 图标颜色
    //         unselectedItemColor: colorScheme.surfaceContainerHighest, // 非选中颜色
    //         showUnselectedLabels: true, // 未选中也显示文字
    //       ),
    //     );
    //   },
    // );

    return DashboardPage();
  }
}
