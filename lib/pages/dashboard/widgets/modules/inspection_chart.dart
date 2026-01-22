import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:cloud/pages/dashboard/widgets/modules/common_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 验货模块 - 折线图
class InspectionChart extends ConsumerWidget {
  const InspectionChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStats = ref.watch(moduleStatsProvider('inspection'));
    final currentDimension = currentStats.timeDimension;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 模块标题和维度选择器
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 模块标题
                Text(
                  '验货',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                // 维度选择器
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.tune,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  offset: const Offset(-10, 45),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: '最近半年',
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: currentDimension == TimeDimension.last6Months
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '最近半年',
                            style: TextStyle(
                              color: currentDimension == TimeDimension.last6Months
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: currentDimension == TimeDimension.last6Months
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '最近一年',
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: currentDimension == TimeDimension.last12Months
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '最近一年',
                            style: TextStyle(
                              color: currentDimension == TimeDimension.last12Months
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: currentDimension == TimeDimension.last12Months
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '所有时间',
                      child: Row(
                        children: [
                          Icon(
                            Icons.all_inclusive,
                            size: 18,
                            color: currentDimension == TimeDimension.allTime
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '所有时间',
                            style: TextStyle(
                              color: currentDimension == TimeDimension.allTime
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: currentDimension == TimeDimension.allTime
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    TimeDimension? dimension;
                    switch (value) {
                      case '最近半年':
                        dimension = TimeDimension.last6Months;
                        break;
                      case '最近一年':
                        dimension = TimeDimension.last12Months;
                        break;
                      case '所有时间':
                        dimension = TimeDimension.allTime;
                        break;
                    }
                    if (dimension != null) {
                      ref.read(moduleStatsProvider('inspection').notifier).setTimeDimension(dimension);
                    }
                  },
                ),
              ],
            ),
          ),
          // 折线图
          const ModuleLineChart(
            moduleId: 'inspection',
            height: 200,
            emptyDataHeight: 100,
            isCurved: true,
          ),
        ],
      ),
    );
  }
}
