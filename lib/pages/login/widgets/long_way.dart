import 'dart:async';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/qrcode.dart';
import 'package:cloud/pages/login/shared.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginWay extends HookConsumerWidget {
  final String loginWay;
  final String? appleIdentityToken;
  final void Function()? onLogined;

  const LoginWay({
    super.key,
    required this.loginWay,
    this.onLogined,
    this.appleIdentityToken,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cloud = ref.watch(coreProvider).value!;
    final tenant = cloud.currentTenant;

    final accountController = useTextEditingController();
    final passwordController = useTextEditingController();

    final qrcodeTimer = useRef<Timer?>(null);
    final qrcodeLoading = useState(false);
    final qrcode = useState<Qrcode?>(null);

    final clearQrcode = useCallback(() {
      logger.d("clearQrcode");
      if (qrcodeTimer.value != null) {
        qrcodeTimer.value!.cancel();
      }

      if (context.mounted) {
        qrcode.value = null;
      }
    }, []);

    final fetchQrcode = useCallback(() async {
      clearQrcode();
      logger.d("获取二维码");

      Future innerFetchQrcode() async {
        qrcodeLoading.value = true;
        qrcode.value = null;

        await api.get("api/csrf-cookie");
        final resp = await api.post("api/tenant/login/qrcodes");

        qrcode.value = Qrcode.fromJson(resp.data);
        qrcodeLoading.value = false;
      }

      await innerFetchQrcode();

      qrcodeTimer.value = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (qrcode.value == null) {
          return;
        }

        final code = qrcode.value!;

        final resp = await api.get("api/tenant/login/qrcodes/${code.id}/show");
        final result = Qrcode.fromJson(resp.data);
        qrcode.value = result;
        if (result.usedAt != null) {
          logger.d("登录成功");
          onLogined?.call();
        }

        final expirationTime = DateTime.tryParse(result.expiredAt!)?.toLocal();
        if (expirationTime == null || DateTime.now().isAfter(expirationTime)) {
          logger.d("二维码已过期，获取新二维码...");
          await innerFetchQrcode();
        }
      });
    }, [clearQrcode]);

    final handleAccountLogin = useCallback(() async {
      final account = accountController.text;
      final password = passwordController.text;

      if (account == '' || password == '') {
        return;
      }

      await api.get("api/csrf-cookie");

      final data = {
        "type": "account",
        "email": account,
        "password": password,
        if (appleIdentityToken != null)
          "apple": {
            "identityToken": appleIdentityToken,
          }
      };

      await api.post("api/login", data: data);

      onLogined?.call();
    }, [appleIdentityToken]);

    useEffect(() {
      if (loginWay == "wxwork") {
        fetchQrcode();
      } else {
        clearQrcode();
      }

      return clearQrcode;
    }, [tenant, loginWay]);

    if (tenant == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            getLableByLoginWay(loginWay),
          ),

          // 账号密码
          if (loginWay == "account") ...[
            if (appleIdentityToken != null)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "绑定后可以 Apple 一键登录",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: accountController,
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: '账号',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 0.3,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 0.3,
                  ),
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: '密码',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 0.3,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ],

          // 企业扫码登录
          if (loginWay == "wxwork") ...[
            Center(
              child: Column(
                children: [
                  if (qrcodeLoading.value)
                    const SizedBox(
                      width: 220,
                      height: 220,
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    )
                  else if (qrcode.value?.userId != null)
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              qrcode.value!.user?.name ?? '未知用户',
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 16),
                            ),
                            const SizedBox(height: 18), // 添加间距
                            Text(
                              qrcode.value!.user?.jobNumber ?? '',
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            const Text(
                              "请在手机上点击确认",
                              style: TextStyle(
                                  color: Color(0xFF707070), fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    )
                  else if (qrcode.value != null)
                    Column(
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: QrImageView(
                            data:
                                '${tenant.baseUrl}login/qrcode/${qrcode.value!.id}',
                            version: QrVersions.auto,
                            size: 220.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const Text(
                          "请使用企业微信扫码登录",
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],

          if (['account'].contains(loginWay))
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 25),
              child: ElevatedButton(
                onPressed: handleAccountLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: const StadiumBorder(), // 胶囊形，圆角为高度一半
                ),
                child:
                    const Text(style: TextStyle(color: Colors.black), '立即登录'),
              ),
            ),
        ],
      ),
    );
  }
}
