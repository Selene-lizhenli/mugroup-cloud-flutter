import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final cloud = ref.watch(coreProvider).value!;
    final cart = ref.read(cartProvider.notifier);
    final tenant = cloud.currentTenant;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(tenant?.title ?? ""),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "${user?.name}",
                    style: TextStyle(
                        fontSize: 24,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '工号: ${user?.jobNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  if (user?.department != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '部门: ${user?.department?.name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: colorScheme.surface,
              title: Text(
                '报价单管理',
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
              leading: Icon(
                Icons.receipt_long,
                color: colorScheme.primary,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface,
              ),
              onTap: () {
                context.router.push(const QuoteRoute());
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: colorScheme.surface,
              title: Text(
                '清空缓存',
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface,
              ),
              leading: Icon(
                Icons.cleaning_services,
                color: colorScheme.secondary,
              ),
              onTap: () {
                showFlanActionSheet(
                  context,
                  cancelText: "取消",
                  actions: [
                    FlanActionSheetAction(
                      name: '清空选样车缓存',
                      callback: (action) async {
                        cart.clear();
                        EasyLoading.showSuccess("清理成功");
                      },
                    ),
                  ],
                  closeable: false,
                  safeAreaInsetBottom: true,
                  closeOnClickAction: true,
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: colorScheme.surface,
              title: Text(
                '版本信息(${app.fullVersion})',
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
              leading: Icon(
                CupertinoIcons.info,
                color: colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: colorScheme.surface,
              title: Center(
                  child: Text(
                '退出登录',
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              )),
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
