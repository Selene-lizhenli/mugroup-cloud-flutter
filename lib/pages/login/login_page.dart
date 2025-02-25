import 'dart:async';

import 'package:auto_route/auto_route.dart';
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
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        // TODO: 轮询
        logger.d("测试");
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
                    data: 'https://cloud.mugroup.com/qrcodes/1',
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
