import 'package:cloud/pages/dashboard/dashboard_l10n_helper.dart';
import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:cloud/pages/dashboard/widgets/dashboard_time_dimension_menu.dart';
import 'package:cloud/pages/dashboard/widgets/modules/common_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 供应商模块 - 折线图
class SupplierChart extends ConsumerWidget {
  const SupplierChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentStats = ref.watch(moduleStatsProvider('supplier'));
    final currentDimension = currentStats.timeDimension;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.dashboardSupplier,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                DashboardTimeDimensionMenu(
                  currentDimension: currentDimension,
                  onSelected: (dimension) {
                    ref
                        .read(moduleStatsProvider('supplier').notifier)
                        .setTimeDimension(dimension);
                  },
                ),
              ],
            ),
          ),
          const ModuleLineChart(
            moduleId: 'supplier',
            height: 200,
            emptyDataHeight: 100,
            isCurved: false,
          ),
        ],
      ),
    );
  }
}
