import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:flutter/material.dart';

/// Platform 和 Count 信息卡片
class TaskDetailInfoCard extends StatelessWidget {
  const TaskDetailInfoCard({
    required this.platform,
    required this.count,
  });

  final String platform;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _InfoItem(
              label: '平台：',
              value: platform.isNotEmpty ? platform : '—',
            ),
            Container(
              width: 1,
              height: 24,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            _InfoItem(
              label: '源图数量：',
              value: count,
            ),
          ],
        ),
      ),
    );
  }
}

/// Platform 和 Count 信息项
class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          searchPlatform
              .firstWhere(
                (element) => element.value == value,
                orElse: () => SearchPlatformItem(label: value, value: value),
              )
              .label,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
