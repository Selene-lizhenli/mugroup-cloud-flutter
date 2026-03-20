import 'package:cloud/app/app.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UserOperatorSection extends HookConsumerWidget {
  const UserOperatorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = ref.read(cartProvider.notifier); 
    final theme = Theme.of(context);

    void showThemeSelector() {
      final currentTheme = ref.read(appThemeProvider);
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 200,
          maxHeight: 320,
        ),
        builder: (_) => Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                          ? primaryColorPink
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
                          color: primaryColorPink,
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
                          ? primaryColorBlue
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
                          color: primaryColorBlue,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          onTap: showThemeSelector,
        ),
        Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: colorScheme.primary.withOpacity(0.05),
        ),
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
        Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: colorScheme.primary.withOpacity(0.05),
        ),
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
        Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: colorScheme.primary.withOpacity(0.05),
        ),
        ListTile(
          tileColor: colorScheme.surface,
          trailing: Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface,
          ),
          title: Row(children: [
            Text(
              '联系技术人员',
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ), 
          ]),
          leading: const Icon(
            Icons.phone,
            color: Color(0xFF08D9D6),
          ),
          onTap: () async {
            showFlanActionSheet(
              context,
              cancelText: "取消",
              actions: [
                FlanActionSheetAction(
                  name: '拨打短号($customerPhoneNumber)',
                  callback: (action) async {
                    final phoneNumber = customerPhoneNumber.toString().trim();
                    if (phoneNumber.isEmpty) {
                      EasyLoading.showError('短号为空');
                      return;
                    }
                    try {
                      final uri = Uri(scheme: 'tel', path: phoneNumber);
                      await launchUrl(uri);
                    } catch (e) {
                      EasyLoading.showError('${'拨号失败'}：${e.toString()}');
                    }
                  },
                ),
              ],
              closeable: false,
              safeAreaInsetBottom: true,
              closeOnClickAction: true,
            );
          },
        ),
        Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: colorScheme.primary.withOpacity(0.05),
        ),
        ListTile(
          tileColor: colorScheme.surface,
          title: Text(
            '退出登录',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          leading: Icon(
            Icons.logout,
            color: colorScheme.primary,
          ),
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
    );
  }
}
