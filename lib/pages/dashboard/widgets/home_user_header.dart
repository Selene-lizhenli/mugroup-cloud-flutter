import 'package:auto_route/auto_route.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 首页顶部用户信息模块

enum _MoreAction {
  updateLog,
  layout,
}

class HomeUserHeader extends HookConsumerWidget {
  const HomeUserHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(userProvider).user;

    void showUpdateLog(BuildContext context) {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (_) => const Center(
          child: Text('这里展示版本更新内容'),
        ),
      );
    }

    void openLayoutSetting(BuildContext context) {
      context.router.push(const SettingRoute());
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/logo.webp',
            width: 100,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: colorScheme.primary,
            onTap: () {
              context.router.push(const MyRoute());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person,
                      size: 24, color: colorScheme.onSurface.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Text(
                    user?.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(height: 1),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<_MoreAction>(
            offset: const Offset(-1, 40),
            icon: Icon(
              Icons.more_vert,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onSelected: (value) {
              switch (value) {
                case _MoreAction.updateLog:
                  showUpdateLog(context);
                  break;
                case _MoreAction.layout:
                  openLayoutSetting(context);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _MoreAction.updateLog,
                child: Row(
                  children: [
                    Icon(Icons.volume_up, size: 20),
                    SizedBox(width: 6),
                    Text('版本更新日志'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _MoreAction.layout,
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 6),
                    Text('设置页面布局'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
