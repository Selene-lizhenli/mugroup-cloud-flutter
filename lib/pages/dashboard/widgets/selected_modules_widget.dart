import 'package:cloud/pages/dashboard/widgets/market/market_purchase_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/customer_chart.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_chart_main.dart';
import 'package:cloud/pages/dashboard/widgets/modules/inspection_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/news_board.dart';
import 'package:cloud/pages/dashboard/widgets/modules/supplier_chart.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room_module.dart';
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
    final selectedIds =
        prefs.getStringList(_storageKey) ?? ['rate', 'news', 'sample_room'];
    final orderIds =
        prefs.getStringList(_orderKey) ?? ['rate', 'news', 'sample_room'];

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
         module.contentBuilder(), 
      ],
    );
  }

}
