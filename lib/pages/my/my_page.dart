import 'package:auto_route/auto_route.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("我"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "${user?.name}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '工号: ${user?.jobNumber}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '部门: ${user?.department?.name}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              tileColor: Colors.white,
              textColor: Colors.grey,
              iconColor: Colors.grey,
              title: Text('设置(建设中)'),
              leading: Icon(CupertinoIcons.gear_alt_fill),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Colors.white,
              title: const Center(child: Text('退出登录')),
              onTap: () {
                showFlanActionSheet(
                  context,
                  cancelText: "取消",
                  actions: [
                    FlanActionSheetAction(
                      name: '退出登录',
                      callback: (action) async {
                        await api.post("api/logout");
                        authNotifier.logout();
                      },
                    ),
                  ],
                  closeOnClickAction: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
