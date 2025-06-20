import 'package:cloud/pages/login/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginWay extends HookConsumerWidget {
  final String loginWay;

  const LoginWay({super.key, required this.loginWay});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrcodeLoading = useState(false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: const TextStyle(fontWeight: FontWeight.w700),
            getLableByLoginWay(loginWay),
          ),

          // 账号密码
          if (loginWay == "account") ...[
            const SizedBox(
              height: 50,
            ),
            TextField(
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

          // TODO: 企业扫码登录
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
                  else
                    Column(
                      children: [
                        QrImageView(
                          data: '12123',
                          version: QrVersions.auto,
                          size: 220.0,
                          backgroundColor: Colors.white,
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
                onPressed: () {},
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
