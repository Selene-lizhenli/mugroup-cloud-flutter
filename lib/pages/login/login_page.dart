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
    final qrcode = useState<Qrcode?>(null);

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
          qrcode.value = Qrcode.fromJson(resp.data);
        } catch (e) {
          logger.e('获取QR码失败：$e');
        }
      }

      fetchQrcode();

      final timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        // TODO: 轮询
        final resp =
            await api.get("api/tenant/login/qrcodes/${qrcode.value!.id}/show");
        qrcode.value = Qrcode.fromJson(resp.data);
        logger.d("轮询,$qrcode");
        try {
          final expirationTime =
              DateTime.tryParse(qrcode.value!.expiredAt ?? '')?.toLocal();
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

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("云链"),
            const SizedBox(
              height: 5,
            ),
            qrcode.value != null
                ? QrImageView(
                    data:
                        'https://cloud.mugroup.com/qrcodes/${qrcode.value!.id}',
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.black,
                  ),
            const SizedBox(
              height: 5,
            ),
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
