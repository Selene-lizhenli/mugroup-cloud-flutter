import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/login/shared.dart';
import 'package:cloud/pages/login/widgets/login_way.dart';
import 'package:cloud/pages/login/widgets/login_content.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/pages/login/widgets/wxwork.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final void Function()? onLogin;

  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWay = useState<String?>(null);
    // 是否安装了企业微信
    final isWxworkInstalled = useState<bool?>(null);
    final appleIdentityToken = useState<String?>(null);
    final cloud = ref.watch(coreProvider).value!;
    final core = ref.read(coreProvider.notifier);
    final tenant = cloud.currentTenant;
    final colorScheme = Theme.of(context).colorScheme;

    final afterLogin = useCallback(() {
      if (onLogin != null) {
        onLogin!();
        return;
      }

      // 默认跳转到首页
      final router = AutoRouter.of(context);
      router.replace(DashboardRoute());
    }, [onLogin]);

    final enableLoginWays = useMemoized(() {
      final tenantLoginWays = tenant?.loginWays ?? [];

      return tenantLoginWays
          .where((it) => supportLoginWays.contains(it))
          .toList();
    }, [tenant]);

    // 检查是否安装企业微信，并缓存到 state 中
    useEffect(() {
      Future.microtask(() async {
        if (!enableLoginWays.contains("wxwork") ||
            tenant?.wxwork?.schema == null) {
          isWxworkInstalled.value = false;
          return;
        }

        final wxwork = FlutterWxwork();
        final installed = await wxwork.isAppInstalled();
        isWxworkInstalled.value = installed;
      });
      return null;
    }, [enableLoginWays, tenant]);

    final quickLoginWay = useMemoized(() async {
      final result = <String>[];

      if (enableLoginWays.contains("wxwork") &&
          tenant?.wxwork?.schema != null) {
        result.add("wxwork"); //租户里面有企微登录方式，则添加企微登录方式
      }

      if (Platform.isIOS && tenant?.loginWays?.contains.call("apple") == true) {
        result.add("apple"); //租户里面有苹果方式，且是苹果的平台，才添加企微登录方式
      }
      return result;
    }, [enableLoginWays, tenant]);

    useEffect(() {
      // 如果当前选择的登录方式不在可用列表中，则清空；否则保持用户选择
      if (loginWay.value != null && enableLoginWays.contains(loginWay.value)) {
        return;
      }
      //初始化登录方式
      if (enableLoginWays.contains('wxwork') &&
          tenant?.wxwork?.schema != null &&
          tenant?.wxwork?.corpId != null &&
          tenant?.wxwork?.agentId != null) {
        loginWay.value = 'wxwork_local_app';
      } else if (enableLoginWays.contains('wxwork') &&
          (tenant?.wxwork?.schema == null ||
              tenant?.wxwork?.corpId == null ||
              tenant?.wxwork?.agentId == null)) {
        loginWay.value = 'wxwork';
      } else {
        loginWay.value = enableLoginWays.isNotEmpty ? enableLoginWays[0] : null;
      }

      return null;
    }, [enableLoginWays, loginWay.value]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/logo.webp',
          width: 116,
          fit: BoxFit.contain,
        ),
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
                        loginWay.value = null;
                        appleIdentityToken.value = null;
                      },
                    ),
                ],
                closeOnClickAction: true,
              );
            },
            child: Text(
              tenant == null ? "选择租户" : "切换租户",
              style: const TextStyle(color: primaryColorPink),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/photo/login.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: tenant == null
                ? Consumer(
                    builder: (context, ref, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        alignment: Alignment.center,
                        child: Text(
                            style: TextStyle(color: colorScheme.outline),
                            "请选择租户后登录"),
                      );
                    },
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                LoginContent(
                                  loginWay: loginWay.value,
                                  isWxworkInstalled: isWxworkInstalled.value,
                                  appleIdentityToken: appleIdentityToken.value,
                                  onAfterLogin: () async {
                                    await app.fetchUser();
                                    afterLogin();
                                  },
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: SizedBox(
                                          height: 60,
                                          child: FlanDivider(
                                            style: FlanDividerStyle(
                                              color: colorScheme.outline,
                                              borderColor: colorScheme.outline
                                                  .withOpacity(0.3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                            ),
                                            child: const Text(
                                              style: TextStyle(fontSize: 15),
                                              "登录方式",
                                            ),
                                          ),
                                        ),
                                      ),
                                      // 登录方式
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ApiEnableLoginWays(
                                            enableLoginWays: enableLoginWays,
                                            loginWay: loginWay,
                                            onAfterLogin: () async {
                                              await app.fetchUser();
                                              afterLogin();
                                            },
                                          ),
                                          //本地企微app 登录方式
                                          if (tenant.wxwork?.schema != null &&
                                              tenant.wxwork?.corpId != null &&
                                              tenant.wxwork?.agentId != null)
                                            WxworkFastLoginBtn(
                                              schema: tenant.wxwork?.schema,
                                              corpId: tenant.wxwork?.corpId!,
                                              agentId: tenant.wxwork?.agentId!,
                                              loginWay: loginWay,
                                              onAfterLogin: () async {
                                                await app.fetchUser();
                                                afterLogin();
                                              },
                                            ),
                                          //apple 登录方式
                                          AppleFastLoginBtn(
                                            quickLoginWay: quickLoginWay,
                                            loginWay: loginWay,
                                            appleIdentityToken:
                                                appleIdentityToken,
                                            onAfterLogin: () async {
                                              await app.fetchUser();
                                              afterLogin();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("网页版: https://cloud.mugroup.com"),
                                      SizedBox(width: 10),
                                      Text("客服: 669082"),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
