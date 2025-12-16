import 'package:cloud/providers/app_provider.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

class BuildQuickAction extends HookConsumerWidget {
  final IconData icon; // 图标
  final String title; // 文字
  final Color color;
  final PageRouteInfo Function(String itemType) route;

  const BuildQuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.route,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProvider).user;

    void handleTap() async {
      final permissions = user?.permissions ?? [];
      const marketPerm = 'showroom.market_product.store';
      const samplePerm = 'showroom.sample.store';

      final hasMarket = permissions.contains(marketPerm);
      final hasSample = permissions.contains(samplePerm);

      // A. 两个权限都有：弹窗选择
      if (hasMarket && hasSample) {
        await showFlanActionSheet(
          context,
          cancelText: "取消",
          actions: [
            FlanActionSheetAction(
                name: '市场产品',
                callback: (action) {
                  context.router.push(route('market_product'));
                }),
            FlanActionSheetAction(
                name: '集团产品',
                callback: (action) {
                  context.router.push(route('sample'));
                }),
          ],
        );
        return;
      }

      // B. 只有市场产品权限
      if (hasMarket) {
        context.router.push(route('market_product'));
        return;
      }

      // C. 只有集团产品权限
      if (hasSample) {
        context.router.push(route('sample'));
        return;
      }

      // D. 没有任何权限
      EasyLoading.showError("您没有创建样品的权限");
    }

    return Column(
      children: [
        Material(
          color: color.withOpacity(0.1), // 背景色
          shape: const CircleBorder(), // 圆形
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: handleTap,
            child: Padding(
              padding: const EdgeInsets.all(6), // 控制按钮大小
              child: Icon(icon, color: color, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(title,
            style: TextStyle(
                fontSize: 12, height: 1, color: colorScheme.onSurface)),
      ],
    );
  }
}
