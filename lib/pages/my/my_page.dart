import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
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
    final theme = Theme.of(context);

    return Scaffold( 
      appBar: AppBar(
      
        title: Text(tenant?.title ?? "我的"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal:20),
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
                '我的主题',
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface,
              ),
              leading: Icon(
                Icons.palette,
                color: colorScheme.primary,
              ),
              onTap: () {
                _showThemeSelector(context, ref, theme, colorScheme);
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

  void _showThemeSelector(BuildContext context, WidgetRef ref,
      ThemeData theme, ColorScheme colorScheme) {
    final currentTheme = ref.read(appThemeProvider);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '请选择主题',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, 
              ),
            ),
            const SizedBox(height: 20),
            // 玫粉色选项
            InkWell(
              onTap: () {
                ref.read(appThemeProvider.notifier).setTheme(ThemeType.pink);
                Navigator.pop(context);
                EasyLoading.showSuccess("已切换为玫粉色主题");
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentTheme == ThemeType.pink
                        ? const Color(0xFFFA338A)
                        : colorScheme.outlineVariant,
                    width: currentTheme == ThemeType.pink ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA338A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '玫粉色',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: currentTheme == ThemeType.pink
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (currentTheme == ThemeType.pink)
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 蓝色选项
            InkWell(
              onTap: () {
                ref.read(appThemeProvider.notifier).setTheme(ThemeType.blue);
                Navigator.pop(context);
                EasyLoading.showSuccess("已切换为蓝色主题");
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration( 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentTheme == ThemeType.blue
                        ? const Color(0xFF355EBF)
                        : colorScheme.outlineVariant,
                    width: currentTheme == ThemeType.blue ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF355EBF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '蓝色',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: currentTheme == ThemeType.blue
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (currentTheme == ThemeType.blue)
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
