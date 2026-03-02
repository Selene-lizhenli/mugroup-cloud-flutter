import 'package:cloud/app/app.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/login/widgets/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 第三方快捷登录区域（企微 / Apple）

class ApiEnableLoginWays extends StatelessWidget {
  final ValueNotifier<String?> loginWay;
  final Future<void> Function() onAfterLogin;
  final List<String> enableLoginWays;
  const ApiEnableLoginWays({
    super.key,
    required this.loginWay,
    required this.onAfterLogin,
    required this.enableLoginWays,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (enableLoginWays.contains('account'))
          GestureDetector(
            onTap: () {
              loginWay.value = "account";
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15),
                shape: BoxShape.circle,
                color: primaryColorPink.withOpacity(0.025),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.lock, // 锁图标常量
                      size: 24, // 大小（默认24）
                      color: colorScheme.secondary, // 颜色
                    ),
                    Text(
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.outline,
                      ),
                      "密码登录",
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (enableLoginWays.contains('wxwork'))
          GestureDetector(
            onTap: () {
              loginWay.value = "wxwork";
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColorPink.withOpacity(0.025),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomScanIcon(size: 25, color: primaryColorPink),
                    Text(
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.outline,
                      ),
                      "扫码登录",
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AppleFastLoginBtn extends StatelessWidget {
  final Future<List<String>> quickLoginWay;
  final ValueNotifier<String?> loginWay;
  final ValueNotifier<String?> appleIdentityToken;
  final Future<void> Function() onAfterLogin;
  const AppleFastLoginBtn({
    super.key,
    required this.quickLoginWay,
    required this.loginWay,
    required this.appleIdentityToken,
    required this.onAfterLogin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<List<String>>(
      future: quickLoginWay,
      builder: (context, snapshot) {
        final quickLoginWays = snapshot.data ?? [];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (quickLoginWays.contains("apple"))
              GestureDetector(
                onTap: () async {
                  try {
                    final credential =
                        await SignInWithApple.getAppleIDCredential(
                      scopes: [],
                    );

                    EasyLoading.show();

                    await api.get("api/csrf-cookie");

                    final loginResult = await api.post(
                      "api/tenant/apple/login",
                      data: {"identityToken": credential.identityToken},
                    );

                    final user = loginResult.data is Map
                        ? User.fromJson(loginResult.data)
                        : null;

                    if (user == null) {
                      appleIdentityToken.value = credential.identityToken;
                      loginWay.value = "account";
                      return;
                    }

                    // await app.fetchUser();
                    await onAfterLogin();
                  } catch (e) {
                    if (e is SignInWithAppleAuthorizationException) {
                      if (e.code == AuthorizationErrorCode.canceled) {
                        return;
                      }
                    }
                    EasyLoading.showError(e.toString());
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(15),
                    shape: BoxShape.circle,
                    color: primaryColorPink.withOpacity(0.025),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        FontAwesomeIcons.apple,
                        size: 25,
                        color: Colors.black,
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.outline,
                        ),
                        "Apple登录",
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
