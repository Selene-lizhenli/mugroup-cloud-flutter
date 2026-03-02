import 'package:cloud/app/app.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/http/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'wxwork_icon.dart';

/// 通用的企微快捷登录方法，可在任意位置复用
Future<void> handleWxworkQuickLogin({
  required String schema,
  required String corpId,
  required String agentId,
}) async {
  try {
    final wxwork = FlutterWxwork();
    await wxwork.register(
      scheme: schema,
      corpId: corpId,
      agentId: agentId,
    );

    final result = await wxwork.auth();
    if (result.errCode != '0') {
      throw Exception('请授权登录');
    }

    final code = result.code!;

    await silentApi.post(
      'api/tenant/wechat/login',
      data: {'code': code},
    );

    // await app.fetchUser();
  } catch (e) {
    var message = e.toString();
    if (e is DioException) {
      message = e.response?.data['message'] ?? message;
    }
    EasyLoading.showError(message);
  }
}

/// 企微快捷登录按钮（用于登录页）
class WxworkFastLoginBtn extends HookConsumerWidget {
  final String? schema;
  final String? corpId;
  final String? agentId;
  final Future<void> Function() onAfterLogin;
  final double? size;
  final ValueNotifier<String?> loginWay;

  const WxworkFastLoginBtn({
    super.key,
    required this.schema,
    required this.corpId,
    required this.agentId,
    required this.loginWay,
    required this.onAfterLogin,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
        onTap: () async {
          loginWay.value = 'wxwork_local_app';
          if (schema != null && corpId != null && agentId != null) {
            await handleWxworkQuickLogin(
              schema: schema!,
              corpId: corpId!,
              agentId: agentId!,
            );
            onAfterLogin?.call();
          }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WxworkIcon(size: size ?? 23),
              Text('企微登录',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.outline,
                  ))
            ],
          ),
        ));
  }
}
