import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/config/config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/qrcode.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final void Function()? onLogin;

  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrcodeState = useState<Qrcode?>(null);
    final cloud = ref.watch(coreProvider).value!;
    final core = ref.read(coreProvider.notifier);
    final tenant = cloud.currentTenant;

    final afterLogin = useCallback(() {
      if (onLogin != null) {
        onLogin!();
        return;
      }

      // 默认跳转到首页
      final router = AutoRouter.of(context);
      router.replace(const HomeRoute());
    }, [onLogin]);

    useEffect(() {
      logger.d(tenant);
      qrcodeState.value = null;
      Future fetchQrcode() async {
        await api.get("api/csrf-cookie");
        final resp = await api.post("api/tenant/login/qrcodes");
        qrcodeState.value = Qrcode.fromJson(resp.data);
      }

      fetchQrcode();

      final timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (qrcodeState.value == null) {
          return;
        }

        final qrcode = qrcodeState.value!;

        final resp =
            await api.get("api/tenant/login/qrcodes/${qrcode.id}/show");
        qrcodeState.value = Qrcode.fromJson(resp.data);

        //登录后跳转
        if (qrcodeState.value?.usedAt != null) {
          await app.fetchUser();
          afterLogin();
        }

        logger.d("轮询,$qrcodeState");

        final expirationTime =
            DateTime.tryParse(qrcodeState.value!.expiredAt ?? '')?.toLocal();
        if (expirationTime == null || DateTime.now().isAfter(expirationTime)) {
          logger.d("二维码已过期，获取新二维码...");
          await fetchQrcode();
        }
      });

      return timer.cancel;
    }, [tenant]);

    final qrcode = qrcodeState.value;
    double qrcodeSize = 200;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tenant == null ? "请在底部选在租户后操作" : tenant.title ?? "",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            // 请求二维码
            if (qrcode == null)
              Container(
                width: qrcodeSize,
                height: qrcodeSize,
                color: Colors.white,
              )
            // 二维码被扫, 展示扫码者信息
            else if (qrcode.userId != null)
              SizedBox(
                width: 220,
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        qrcodeState.value!.user?.name ?? '未知用户',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      const SizedBox(height: 18), // 添加间距
                      Text(
                        qrcodeState.value!.user?.jobNumber ?? '无工号',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            // 默认展示已有二维码
            else
              QrImageView(
                data: '${Config.webUrl}login/qrcode/${qrcodeState.value!.id}',
                version: QrVersions.auto,
                size: 220.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(
              height: 20,
            ),
            if (qrcode?.userId != null)
              const Text(
                "请在手机上确认登录",
                style: TextStyle(color: Color(0xFF707070), fontSize: 14),
              )
            else
              const Text(
                "请使用企业微信扫码登录",
                style: TextStyle(color: Color(0xFF707070), fontSize: 14),
              ),

            if (cloud.tenants.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      '切换租户',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
