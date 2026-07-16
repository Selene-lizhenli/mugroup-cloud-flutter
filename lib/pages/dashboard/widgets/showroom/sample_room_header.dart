import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/pages/dashboard/dashboard_l10n_helper.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 样品间模块标题 + 维度选择器
class SampleRoomHeader extends ConsumerWidget {
  const SampleRoomHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final currentDimension = ref.watch(
      dashboardStatsProvider.select((state) => state.sampleRoomDimension),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.dashboardTopRank,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 16),
          ),
          PopupMenuButton<String>(
            icon: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                hoverColor: colorScheme.primary.withOpacity(0.1),
                highlightColor: colorScheme.primary.withOpacity(0.1),
                splashColor: colorScheme.primary.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.tune,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            offset: const Offset(-10, 45),
            itemBuilder: (BuildContext context) =>
                sampleDimensionConfigs.map((config) {
              final value = config['value'] as String;
              return PopupMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Icon(
                      config['icon'],
                      size: 18,
                      color: currentDimension == value
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.dashboardSampleDimensionLabel(value),
                      style: TextStyle(
                        color: currentDimension == value
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        fontWeight: currentDimension == value
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onSelected: (String value) {
              ref
                  .read(dashboardStatsProvider.notifier)
                  .setSampleRoomDimension(value);
            },
          ),
        ],
      ),
    );
  }
}
