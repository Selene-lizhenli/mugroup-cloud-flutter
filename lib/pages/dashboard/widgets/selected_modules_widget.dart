import 'package:cloud/pages/setting/widgets/line_chart_demo.dart';
import 'package:cloud/pages/setting/widgets/news_board.dart';
import 'package:cloud/pages/setting/widgets/market_purchase_chart.dart';
import 'package:cloud/pages/setting/widgets/sample_room_chart.dart';
import 'package:cloud/pages/setting/widgets/inspection_chart.dart';
import 'package:cloud/pages/setting/widgets/customer_chart.dart';
import 'package:cloud/pages/setting/widgets/supplier_chart.dart';
import 'package:flutter/material.dart';
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

  static List<ModuleInfo> getAllModules() {
    return [
      ModuleInfo(
        id: 'news',
        title: '集团资讯',
        contentBuilder: () => const NewsBoard(),
        group: '应用',
      ),
      ModuleInfo(
        id: 'rate',
        title: '汇率波动',
        contentBuilder: () => const LineChartDemo(),
        group: '应用',
      ),
      ModuleInfo(
        id: 'market_purchase',
        title: '市场采购',
        contentBuilder: () => const MarketPurchaseChart(),
        group: '数据概览',
      ),
      ModuleInfo(
        id: 'sample_room',
        title: '样品间',
        contentBuilder: () => const SampleRoomChart(),
        group: '数据概览',
      ),
      ModuleInfo(
        id: 'inspection',
        title: '验货',
        contentBuilder: () => const InspectionChart(),
        group: '数据概览',
      ),
      ModuleInfo(
        id: 'customer',
        title: '客户',
        contentBuilder: () => const CustomerChart(),
        group: '数据概览',
      ),
      ModuleInfo(
        id: 'supplier',
        title: '供应商',
        contentBuilder: () => const SupplierChart(),
        group: '数据概览',
      ),
    ];
  }

  /// 获取已选中的模块
  static Future<List<ModuleInfo>> getSelectedModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds = prefs.getStringList(_storageKey) ?? [];
    
    if (selectedIds.isEmpty) {
      return [];
    }

    final allModules = getAllModules();
    return allModules
        .where((module) => selectedIds.contains(module.id))
        .toList();
  }
}

/// 已选中的模块展示组件
class SelectedModulesWidget extends StatefulWidget {
  const SelectedModulesWidget({super.key});

  @override
  State<SelectedModulesWidget> createState() => _SelectedModulesWidgetState();
}

class _SelectedModulesWidgetState extends State<SelectedModulesWidget> {
  List<ModuleInfo> _selectedModules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedModules();
  }

  Future<void> _loadSelectedModules() async {
    final modules = await DashboardModules.getSelectedModules();
    if (mounted) {
      setState(() {
        _selectedModules = modules;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    if (_selectedModules.isEmpty) {
      return const SizedBox.shrink();
    }

    // 按组分类
    final dataOverviewModules = _selectedModules
        .where((m) => m.group == '数据概览')
        .toList();
    final appModules = _selectedModules
        .where((m) => m.group == '应用')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 数据概览组
        if (dataOverviewModules.isNotEmpty) ...[
          _buildGroupSection('数据概览', dataOverviewModules),
          const SizedBox(height: 12),
        ],
        // 应用组
        if (appModules.isNotEmpty) ...[
          _buildGroupSection('应用', appModules),
        ],
      ],
    );
  }

  Widget _buildGroupSection(String groupTitle, List<ModuleInfo> modules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            groupTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...modules.map((module) => _buildModuleCard(module)),
      ],
    );
  }

  Widget _buildModuleCard(ModuleInfo module) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              module.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          module.contentBuilder(),
        ],
      ),
    );
  }
}

