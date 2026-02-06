import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/login/shared.dart';
import 'package:cloud/pages/login/widgets/long_way.dart';
import 'package:cloud/constants/theme_color_config.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:dio/dio.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final void Function()? onLogin;

  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginWay = useState<String?>(null);
    final restEnableLoginWays = useState<List<String>>([]);
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

    final quickLoginWay = useMemoized(() async {
      final result = <String>[];

      if (enableLoginWays.contains("wxwork") &&
          tenant?.wxwork?.schema != null) {
        // 判断是否安装
        final wxwork = FlutterWxwork();
        final isInstall = await wxwork.isAppInstalled();
        if (isInstall) {
          result.add("wxwork");
        }
      }

      if (Platform.isIOS && tenant?.loginWays?.contains.call("apple") == true) {
        result.add("apple");
      }
      return result;
    }, [enableLoginWays, tenant]);

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
            'assets/photo/trival_small.jpg',
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
                                if (loginWay.value != null)
                                  LoginWay(
                                    loginWay: loginWay.value!,
                                    appleIdentityToken:
                                        appleIdentityToken.value,
                                    onLogined: () async {
                                      await app.fetchUser();
                                      afterLogin();
                                    },
                                  ),
                                if (restEnableLoginWays.value.isNotEmpty) ...[
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          colorScheme.surface.withOpacity(0.5),
                                    ),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: SizedBox(
                                            height: 60,
                                            child: FlanDivider(
                                              child: Text(
                                                style: TextStyle(fontSize: 15),
                                                "其他登录方式",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (var (index, item)
                                                in restEnableLoginWays
                                                    .value.indexed) ...[
                                              if (index != 0)
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  color: colorScheme.outline,
                                                  height: 20,
                                                  width: 1,
                                                ),
                                              GestureDetector(
                                                onTap: () {
                                                  loginWay.value = item;
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: primaryColorPink
                                                        .withOpacity(0.025),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: primaryColorPink,
                                                      ),
                                                      getLableByLoginWay(item),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                                const Spacer(),
                                // 第三方快捷登录
                                FutureBuilder(
                                  future: quickLoginWay,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }

                                    final quickLoginWays = snapshot.data!;

                                    if (quickLoginWays.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 60,
                                            child: FlanDivider(
                                              child: Text('快捷登录方式'),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (quickLoginWays
                                                  .contains("wxwork"))
                                                GestureDetector(
                                                  onTap: () async {
                                                    try {
                                                      final wxwork =
                                                          FlutterWxwork();

                                                      await wxwork.register(
                                                        scheme: tenant
                                                            .wxwork!.schema!,
                                                        corpId: tenant
                                                            .wxwork!.corpId!,
                                                        agentId: tenant
                                                            .wxwork!.agentId!,
                                                      );

                                                      final result =
                                                          await wxwork.auth();
                                                      if (result.errCode !=
                                                          '0') {
                                                        throw Exception(
                                                            '请授权登录');
                                                      }

                                                      final code = result.code!;

                                                      await silentApi.post(
                                                          'api/tenant/wechat/login',
                                                          data: {"code": code});

                                                      await app.fetchUser();
                                                      afterLogin();
                                                    } catch (e) {
                                                      var message =
                                                          e.toString();
                                                      if (e is DioException) {
                                                        message = e.response
                                                                    ?.data[
                                                                'message'] ??
                                                            message;
                                                      }

                                                      EasyLoading.showError(
                                                          message);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFFEBEDF0),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      width: 20,
                                                      height: 20,
                                                      'assets/icons/wxwork.svg',
                                                    ),
                                                  ),
                                                ),
                                              if (quickLoginWays
                                                  .contains("apple"))
                                                GestureDetector(
                                                  onTap: () async {
                                                    try {
                                                      final credential =
                                                          await SignInWithApple
                                                              .getAppleIDCredential(
                                                        scopes: [],
                                                      );

                                                      EasyLoading.show();

                                                      await api.get(
                                                          "api/csrf-cookie");

                                                      final loginResult =
                                                          await api.post(
                                                        "api/tenant/apple/login",
                                                        data: {
                                                          "identityToken":
                                                              credential
                                                                  .identityToken
                                                        },
                                                      );

                                                      final user = loginResult
                                                              .data is Map
                                                          ? User.fromJson(
                                                              loginResult.data)
                                                          : null;

                                                      if (user == null) {
                                                        appleIdentityToken
                                                                .value =
                                                            credential
                                                                .identityToken;
                                                        loginWay.value =
                                                            "account";
                                                        return;
                                                      }

                                                      await app.fetchUser();
                                                      afterLogin();
                                                    } catch (e) {
                                                      if (e
                                                          is SignInWithAppleAuthorizationException) {
                                                        if (e.code ==
                                                            AuthorizationErrorCode
                                                                .canceled) {
                                                          return;
                                                        }
                                                      }
                                                      EasyLoading.showError(
                                                          e.toString());
                                                    } finally {
                                                      EasyLoading.dismiss();
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black,
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      FontAwesomeIcons.apple,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("网页版: https://cloud.mugroup.com"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("客服: 669082"),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
