import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            QrImageView(
              data: 'https://cloud.mugroup.com/qrcodes?code=12323',
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "请使用企业微信扫码登录",
              style: TextStyle(color: Color(0xFF707070), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
