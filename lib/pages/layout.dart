import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/dashboard/dashboard.dart';
import 'package:cloud/pages/dashboard/widgets/selected_modules_widget.dart'; 
import 'package:cloud/providers/core_provider.dart'; 
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
 

    // 创建用于刷新 DashboardPage 的 key
    final dashboardModulesKey = useMemoized(
      () => GlobalKey<State<SelectedModulesWidget>>(),
    );

    // 监听 coreProvider 的 prePath，当值为 'setting' 时刷新 DashboardPage
    final coreAsync = ref.watch(coreProvider);
    final processedPrePath = useRef<String?>(null);
    useEffect(() {
      final prePath = coreAsync.value?.prePath;
      // 只有当 prePath 为 'setting' 且之前未处理过时才执行
      if (prePath == 'setting' && processedPrePath.value != 'setting') {
        processedPrePath.value = prePath;
        // 使用 Future.microtask 延迟执行，确保在构建完成后再修改 provider
        Future.microtask(() { 
          final state = dashboardModulesKey.currentState;
          if (state != null) {
            try {
              final dynamic stateDynamic = state; 
              stateDynamic.refresh().catchError((e) {   });
            } catch (e) {
              logger.e('刷新 DashboardPage 失败: $e');
            }
          } 
          ref.read(coreProvider.notifier).setPrePath(null); 
          processedPrePath.value = null;
        });
      } else if (prePath != 'setting') { 
        processedPrePath.value = null;
      }
      return null;
    }, [coreAsync.value?.prePath]);

    return DashboardPage(selectedModulesKey: dashboardModulesKey);
  }
}
