import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/search_platform_l10n_helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Platform 和 Count 信息卡片
class TaskDetailInfoCard extends StatelessWidget {
  const TaskDetailInfoCard({
    required this.platform,
    required this.count,
  });

  final List platform;
  final String count;

  String _resolvePlatformLabel(BuildContext context) {
    final values = platform
        .where((item) => item != null && item.toString().trim().isNotEmpty)
        .map((item) => item.toString().trim())
        .toList();

    if (values.isEmpty) {
      return '—';
    }

    final l10n = context.l10n;
    final labels = values.map((value) {
      final matched = searchPlatform.any((element) => element.value == value);
      return matched ? searchPlatformLabel(l10n, value) : value;
    }).toList();

    return labels.join('、');
  }

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
              value: _resolvePlatformLabel(context),
            ),
            Container(
              width: 1,
              height: 24,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            _InfoItem(
              label: '源图：',
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
          value,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
