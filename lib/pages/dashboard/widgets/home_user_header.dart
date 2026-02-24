import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/theme.dart';
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

  Widget _buildUpdateItem(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, String version, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontSize: 12,
                  color: item.startsWith('  •') || item.isEmpty
                      ? colorScheme.onSurface.withOpacity(0.7)
                      : colorScheme.onSurface,
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(userProvider).user;

    void showUpdateLog(BuildContext context) {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '版本更新日志：',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildUpdateItem(
                  context,
                  theme,
                  colorScheme,
                  '2.0最新升级内容',
                  [
                    '✨ 新增功能',
                    '  • 新增《验货》模块，记录商品验货数据',
                    '  • 新增《采购助手》模块，帮助您采购寻源',
                    '  • 新增《独立站》模块，帮助您管理您的独立站数据',
                    '  • 新增《留言板》模块，帮助您对系统进行留言反馈',
                    '  • 新增《客户》模块，管理客户信息',
                    '  • 新增《供应商》模块，管理供应商信息',
                    '  • 新增系统主題切换功能',  
                    '🔧 功能改进', 
                    '  • 商品列表展示优化，提供简洁模式和详细模式',
                    '  • 首页布局优化， 展示数据统计模块和应用入口',
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    void openLayoutSetting(BuildContext context) {
      context.router.push(const SettingRoute());
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            isSpringFestival
                ? 'assets/element/logonoicon.png'
                : 'assets/logo.webp',
            width: isSpringFestival ? 85 : 116,
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
                      size: 24, color: colorScheme.onSurface.withOpacity(0.72)),
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
