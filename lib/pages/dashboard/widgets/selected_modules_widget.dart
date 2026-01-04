import 'package:cloud/pages/dashboard/widgets/modules/line_chart_demo.dart';
import 'package:cloud/pages/dashboard/widgets/modules/news_board.dart';
import 'package:cloud/pages/dashboard/widgets/modules/market_purchase_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/sample_room_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/inspection_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/customer_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/supplier_chart.dart';
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
        title: '市场采购',
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

    // 直接展示所有选中的模块，不分组
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedModules.map((module) => _buildModuleCard(module)).toList(),
    );
  }

  Widget _buildModuleCard(ModuleInfo module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行：标题居左，如果是数据统计组则右侧显示维度选择图标
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 模块标题，居左
              Text(
                module.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
                  offset: const Offset(0, 8), // 在按钮下方显示气泡菜单
                  itemBuilder: (BuildContext context) => _buildDimensionMenuItems(module.id),
                  onSelected: (String value) {
                    // TODO: 处理维度选择，可以根据模块ID和选中的维度值来更新数据
                    // 这里可以添加回调或状态管理来处理维度切换
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
        return [
          const PopupMenuItem<String>(
            value: '产品目录',
            child: Row(
              children: [
                const Icon(Icons.category, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('产品目录'),
              ],
            ),
          ),
         const PopupMenuItem<String>(
            value: '样品间',
            child: Row(
              children: [
                const Icon(Icons.warehouse, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('样品间'),
              ],
            ),
          ),
        ];
      case 'inspection':
      case 'customer':
      case 'supplier':
      case 'market_purchase':
        // 验货、客户、供应商的时间维度选项
        return [
          const PopupMenuItem<String>(
            value: '最近一个月',
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('最近一个月'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: '最近半年',
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('最近半年'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: '最近一年',
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('最近一年'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: '所有时间',
            child: Row(
              children: [
                const Icon(Icons.all_inclusive, size: 18, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('所有时间'),
              ],
            ),
          ),
        ];
        // 市场采购模块的维度选项（可以根据实际需求添加）
     
      default:
        return [];
    }
  }
}

