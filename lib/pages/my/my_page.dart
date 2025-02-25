import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/widgets/app_tabbar/app_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class MyPage extends HookWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text('设置'),
              leading: Icon(CupertinoIcons.person_alt),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
            ),
            ElevatedButton(
              onPressed: () async {
                await api.post("api/logout");
                app.logout();
              },
              child: const Text("退出登录"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppTabbar(),
    );
  }
}
