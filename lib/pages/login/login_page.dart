import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/login/widgets/long_way.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final supportLoginWays = ["account", "wxwork"];

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final void Function()? onLogin;

  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWay = useState<String?>(null);
    final restEnableLoginWays = useState<List<String>>([]);
    final cloud = ref.watch(coreProvider).value!;
    final core = ref.read(coreProvider.notifier);
    final tenant = cloud.currentTenant;

    final enableLoginWays = useMemoized(() {
      final tenantLoginWays = tenant?.loginWays ?? [];

      return tenantLoginWays
          .where((it) => supportLoginWays.contains(it))
          .toList();
    }, [tenant]);

    useEffect(() {
      if (loginWay.value != null && enableLoginWays.contains(loginWay.value)) {
        return;
      }

      loginWay.value = enableLoginWays.elementAtOrNull(0);

      return null;
    }, [enableLoginWays, loginWay.value]);

    useEffect(() {
      logger.d("运行啦${loginWay.value ?? ""}");
      if (loginWay.value == null) {
        restEnableLoginWays.value = [];
      }

      final rest = [...enableLoginWays];
      rest.remove(loginWay.value);
      restEnableLoginWays.value = rest;

      return null;
    }, [enableLoginWays, loginWay.value]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(tenant == null ? "" : tenant.title!),
        actions: [
          TextButton(
            onPressed: () {
              showFlanActionSheet(
                context,
                cancelText: "取消",
                actions: [
                  for (final tenant in cloud.tenants)
                    FlanActionSheetAction(
                      name: tenant.title ?? "未命名租户(${tenant.id})",
                      callback: (action) async {
                        core.setCurrentTenantId(tenant.id);
                      },
                    ),
                ],
                closeOnClickAction: true,
              );
            },
            child: Text(tenant == null ? "选择租户" : "切换租户"),
          ),
        ],
      ),
      body: tenant == null
          ? Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child:
                  const Text(style: TextStyle(color: Colors.grey), "请选择租户后登录"),
            )
          : Column(
              children: [
                if (loginWay.value != null) LoginWay(loginWay: loginWay.value!),

                // 登录方式
                if (restEnableLoginWays.value.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var item in restEnableLoginWays.value)
                        GestureDetector(
                          onTap: () {
                            loginWay.value = item;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.blue,
                            child: Center(child: Text(item)),
                          ),
                        )
                    ],
                  )
                ]
              ],
            ),
    );
  }
}
