import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/qrcode.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class LoginPage extends HookWidget {
  final void Function()? onLogin;

  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    final qrcodeState = useState<Qrcode?>(null);

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
      Future fetchQrcode() async {
        try {
          final resp = await api.post("api/tenant/login/qrcodes");
          qrcodeState.value = Qrcode.fromJson(resp.data);
        } catch (e) {
          logger.e('获取QR码失败：$e');
        }
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
          afterLogin();
        }

        logger.d("轮询,$qrcodeState");
        try {
          final expirationTime =
              DateTime.tryParse(qrcodeState.value!.expiredAt ?? '')?.toLocal();
          if (expirationTime == null ||
              DateTime.now().isAfter(expirationTime)) {
            logger.d("二维码已过期，获取新二维码...");
            await fetchQrcode();
          }
        } catch (e) {
          logger.e("轮询时出错: $e");
        }
      });

      return timer.cancel;
    }, []);

    final qrcode = qrcodeState.value;
    double qrcodeSize = 200;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("云链"),
            const SizedBox(
              height: 5,
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
                width: 200,
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        qrcodeState.value!.user?.name ?? '未知用户',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 8), // 添加间距
                      Text(
                        qrcodeState.value!.user?.jobNumber ?? '无工号',
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            // 默认展示已有二维码
            else
              QrImageView(
                data:
                    'https://cloud.mugroup.com/login/qrcodes/${qrcodeState.value!.id}',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(
              height: 5,
            ),
            if (qrcode?.userId != null)
              const Text(
                "请在手机上确认登录",
                style: TextStyle(color: Color(0xFF707070), fontSize: 10),
              )
            else
              const Text(
                "请使用企业微信扫码登录",
                style: TextStyle(color: Color(0xFF707070), fontSize: 10),
              ),
            TextButton(
              onPressed: () async {
                // 模拟登录，请在自己的环境中增加下面路由设置登录
                await api.get("api/tenant/test");
                await app.user;
                afterLogin();
              },
              child: const Text("模拟登录"),
            ),
          ],
        ),
      ),
    );
  }
}
