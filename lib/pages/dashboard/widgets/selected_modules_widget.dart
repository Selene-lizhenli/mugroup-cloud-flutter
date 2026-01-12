import 'package:cloud/pages/dashboard/widgets/modules/line_chart_demo.dart';
import 'package:cloud/pages/dashboard/widgets/modules/news_board.dart';
import 'package:cloud/pages/dashboard/widgets/market/market_purchase_chart.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room_module.dart';
import 'package:cloud/pages/dashboard/widgets/modules/inspection_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/customer_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/supplier_chart.dart';
import 'package:cloud/pages/dashboard/provider/module_stats_provider.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 模块信息类
class ModuleInfo {
  final String id;
  final String title;
  final Widget Function() contentBuilder;
  final String group;

  const ModuleInfo({
    required this.id,
    required this.title,
    required this.contentBuilder,
    required this.group,
  });
}

/// 所有可用的模块定义
class DashboardModules {
  static const String _storageKey = 'selected_module_ids';
  static const String _orderKey = 'module_order_ids';

  static List<ModuleInfo> getAllModules() {
    return [
      ModuleInfo(
        id: 'sample_room',
        title: '样品间',
        contentBuilder: () => const SampleRoomChart(),
        group: '数据统计',
      ),
      ModuleInfo(
        id: 'inspection',
        title: '验货',
        contentBuilder: () => const InspectionChart(),
        group: '数据统计',
      ),
      ModuleInfo(
        id: 'market_purchase',
        title: '市场带客',
        contentBuilder: () => const MarketPurchaseChart(),
        group: '数据统计',
      ),
      ModuleInfo(
        id: 'customer',
        title: '客户',
        contentBuilder: () => const CustomerChart(),
        group: '数据统计',
      ),
      ModuleInfo(
        id: 'supplier',
        title: '供应商',
        contentBuilder: () => const SupplierChart(),
        group: '数据统计',
      ),
      ModuleInfo(
        id: 'news',
        title: '集团资讯',
        contentBuilder: () => const NewsBoard(),
        group: '应用',
      ),
      ModuleInfo(
        id: 'rate',
        title: '今日汇率',
        contentBuilder: () => const LineChartDemo(),
        group: '应用',
      ),
    ];
  }

  /// 获取已选中的模块（按照设置页面中保存的排序顺序）
  static Future<List<ModuleInfo>> getSelectedModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds = prefs.getStringList(_storageKey) ?? [];
    final orderIds = prefs.getStringList(_orderKey) ?? [];

    if (selectedIds.isEmpty) {
      return [];
    }

    final allModules = getAllModules();
    final moduleMap = {for (var m in allModules) m.id: m};

    // 如果存在排序顺序，按照保存的顺序排列
    if (orderIds.isNotEmpty) {
      final orderedModules = <ModuleInfo>[];
      final processedIds = <String>{};

      // 先按照排序顺序添加已选中的模块
      for (final id in orderIds) {
        if (selectedIds.contains(id) && moduleMap.containsKey(id)) {
          orderedModules.add(moduleMap[id]!);
          processedIds.add(id);
        }
      }

      // 如果排序列表中还有已选中但未处理的模块（不应该发生，但为了健壮性保留）
      for (final id in selectedIds) {
        if (!processedIds.contains(id) && moduleMap.containsKey(id)) {
          orderedModules.add(moduleMap[id]!);
        }
      }

      return orderedModules;
    } else {
      // 如果没有保存排序顺序，使用默认顺序（按 getAllModules 的顺序）
      return allModules
          .where((module) => selectedIds.contains(module.id))
          .toList();
    }
  }
}

/// 已选中的模块展示组件
class SelectedModulesWidget extends ConsumerStatefulWidget {
  const SelectedModulesWidget({super.key});

  @override
  ConsumerState<SelectedModulesWidget> createState() =>
      _SelectedModulesWidgetState();
}

class _SelectedModulesWidgetState extends ConsumerState<SelectedModulesWidget> {
  List<ModuleInfo> _selectedModules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedModules();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    if (_selectedModules.isEmpty) {
      return const SizedBox.shrink();
    }

    // 直接展示所有选中的模块，不分组
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _selectedModules.map((module) => _buildModuleCard(module)).toList(),
    );
  }

  /// 刷新模块数据
  Future<void> refresh() async {
    await _loadSelectedModules();
  }

  Future<void> _loadSelectedModules() async {
    setState(() {
      _loading = true;
    });

    final modules = await DashboardModules.getSelectedModules();
    if (mounted) {
      setState(() {
        _selectedModules = modules;
        _loading = false;
      });

      final coreAsync = ref.watch(coreProvider);
      final notifier = ref.read(coreProvider.notifier);
      if (coreAsync.value?.prePath == 'setting') {
        notifier.setPrePath(null);
      }
    }
  }

  Widget _buildModuleCard(ModuleInfo module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 标题行：标题居左，如果是数据统计组则右侧显示维度选择图标
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 模块标题，居左
              Text(
                module.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
              ),
              // 如果是数据统计组，显示维度选择图标
              if (module.group == '数据统计')
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.tune,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  offset: const Offset(-10, 45), // 在按钮下方显示气泡菜单
                  itemBuilder: (BuildContext context) =>
                      _buildDimensionMenuItems(module.id),
                  onSelected: (String value) {
                    _handleDimensionSelection(module.id, value);
                  },
                ),
            ],
          ),
        ),
        // 白色card只包含内容
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: module.contentBuilder(),
        ),
      ],
    );
  }

  /// 构建维度选择菜单项
  List<PopupMenuEntry<String>> _buildDimensionMenuItems(String moduleId) {
    // 根据不同的模块ID返回不同的维度选项
    // 可以根据实际需求扩展每个模块的维度选项
    switch (moduleId) {
      case 'sample_room':
        final currentDimension = ref.watch(dashboardStatsProvider.select((state) => state.sampleRoomDimension));
        return [
          PopupMenuItem<String>(
            value: '产品目录',
            child: Row(
              children: [
                Icon(
                  Icons.category,
                  size: 18,
                  color: currentDimension == '产品目录'
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  '产品目录',
                  style: TextStyle(
                    color: currentDimension == '产品目录'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    fontWeight: currentDimension == '产品目录'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: '样品间',
            child: Row(
              children: [
                Icon(
                  Icons.warehouse,
                  size: 18,
                  color: currentDimension == '样品间'
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  '样品间',
                  style: TextStyle(
                    color: currentDimension == '样品间'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    fontWeight: currentDimension == '样品间'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ];
      case 'inspection':
      case 'customer':
      case 'supplier':
      case 'market_purchase':
        // 验货、客户、供应商的时间维度选项
        final currentStats = ref.watch(moduleStatsProvider(moduleId));
        final currentDimension = currentStats.timeDimension;

        return [
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
        ];
      // 市场带客模块的维度选项（可以根据实际需求添加）

      default:
        return [];
    }
  }

  /// 处理维度选择
  void _handleDimensionSelection(String moduleId, String value) {
    // 处理样品间模块的维度选择
    if (moduleId == 'sample_room') {
      ref.read(dashboardStatsProvider.notifier).setSampleRoomDimension(value);
      return;
    } 

    // 处理时间维度相关的模块
    if (moduleId == 'inspection' ||
        moduleId == 'customer' ||
        moduleId == 'supplier' ||
        moduleId == 'market_purchase') {
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
        // 针对特定模块设置时间维度并刷新数据
        ref
            .read(moduleStatsProvider(moduleId).notifier)
            .setTimeDimension(dimension);

        // 市场带客模块需要同时更新客户和供应商模块的时间维度，以保持数据一致性
        if (moduleId == 'market_purchase') {
          ref
              .read(moduleStatsProvider('customer').notifier)
              .setTimeDimension(dimension);
          ref
              .read(moduleStatsProvider('supplier').notifier)
              .setTimeDimension(dimension);
        }
      }
    }
    // 其他模块的维度选择可以在这里扩展
  }
}
