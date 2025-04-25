import 'package:auto_route/auto_route.dart';
import 'package:cloud/http/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

@RoutePage()
class Layout extends HookConsumerWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
