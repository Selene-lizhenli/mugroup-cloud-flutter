import 'package:flutter/material.dart';

/// 首页顶部信息卡片
/// 用途：概览 / 快捷操作 / 提示
class HomeTopSummaryCard extends StatelessWidget {
  const HomeTopSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ===== 左侧文案 =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日待处理',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '报价单 · 3',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ===== 右侧快捷按钮 =====
            Text(
              '去处理 »',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            // _ActionButton(
            //   label: '去处理',
            //   onTap: () {
            //     // TODO: 跳转到新建报价
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

/// 右侧按钮
class _ActionButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _ActionButton({
    this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 16, color: colorScheme.secondary),
            const SizedBox(width: 4),
            Text(
              label ?? " ",
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
