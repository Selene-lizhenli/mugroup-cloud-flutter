import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/modules/line_chart_demo.dart';
import 'package:cloud/pages/dashboard/widgets/modules/news_board.dart';
import 'package:cloud/pages/dashboard/widgets/modules/market_purchase_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/sample_room_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/inspection_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/customer_chart.dart';
import 'package:cloud/pages/dashboard/widgets/modules/supplier_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const _storageKey = 'selected_module_ids';

  late List<DashboardModule> modules;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initModules();
  }

  /// =======================
  /// 初始化：从本地读取选中模块
  /// =======================
  Future<void> _initModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds = prefs.getStringList(_storageKey) ?? [];

    /// 所有模块（固定定义）
    modules = [
      DashboardModule(
        id: 'news',
        title: '集团资讯',
        content: const NewsBoard(),
        group: '应用', // 添加分组
        selected: selectedIds.contains('news'),
      ),
      DashboardModule(
        id: 'rate',
        title: '今日汇率',
        content: const LineChartDemo(),
        group: '应用', // 添加分组
        selected: selectedIds.contains('rate'),
      ),
      DashboardModule(
        id: 'sample_room',
        title: '样品间',
        content: const SampleRoomChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains('sample_room'),
      ),
      DashboardModule(
        id: 'market_purchase',
        title: '市场采购',
        content: const MarketPurchaseChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains('market_purchase'),
      ),
      DashboardModule(
        id: 'inspection',
        title: '验货',
        content: const InspectionChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains('inspection'),
      ),
      DashboardModule(
        id: 'customer',
        title: '客户',
        content: const CustomerChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains('customer'),
      ),
      DashboardModule(
        id: 'supplier',
        title: '供应商',
        content: const SupplierChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains('supplier'),
      ),
    ];

    setState(() {
      _loading = false;
    });
  }

  /// =======================
  /// 保存当前选中模块
  /// =======================
  Future<void> _saveSelectedModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds =
        modules.where((e) => e.selected).map((e) => e.id).toList();

    await prefs.setStringList(_storageKey, selectedIds);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('模块配置已保存')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 已选中的模块按组分类
    final selectedDataOverview =
        modules.where((e) => e.selected && e.group == '数据统计').toList();
    final selectedApp =
        modules.where((e) => e.selected && e.group == '应用').toList();

    // 未选中的模块按组分类
    final unselectedDataOverview =
        modules.where((e) => !e.selected && e.group == '数据统计').toList();
    final unselectedApp =
        modules.where((e) => !e.selected && e.group == '应用').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('模块管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSelectedModules,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          /// =======================
          /// 已选中的模块
          /// =======================
          const _SectionTitle(title: '已选中的模块'),
          const SizedBox(height: 12),

          // 如果有选中的模块，显示模块列表
          if (selectedDataOverview.isNotEmpty || selectedApp.isNotEmpty) ...[
            /// 数据统计组（已选中）
            if (selectedDataOverview.isNotEmpty) ...[
              const _GroupTitle(title: '数据统计'),
              const SizedBox(height: 10),
              ...selectedDataOverview.map(
                (module) => _ModuleCard(
                  title: module.title,
                  selected: true,
                  onAction: () {
                    setState(() {
                      module.selected = false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// 应用组（已选中）
            if (selectedApp.isNotEmpty) ...[
              _GroupTitle(title: '应用'),
              const SizedBox(height: 10),
              ...selectedApp.map(
                (module) => _ModuleCard(
                  title: module.title,
                  selected: true,
                  onAction: () {
                    setState(() {
                      module.selected = false;
                    });
                  },
                ),
              ),
            ],
          ] else ...[
            // 如果没有选中的模块，显示空状态
            _EmptyState(),
          ],

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 10),

          /// =======================
          /// 更多模块
          /// =======================
          if (unselectedDataOverview.isNotEmpty ||
              unselectedApp.isNotEmpty) ...[
            const _SectionTitle(title: '更多模块'),
            const SizedBox(height: 12),

            /// 数据统计组（未选中）
            if (unselectedDataOverview.isNotEmpty) ...[
              _GroupTitle(title: '数据统计'),
              const SizedBox(height: 10),
              ...unselectedDataOverview.map(
                (module) => _ModuleCard(
                  title: module.title,
                  selected: false,
                  onAction: () {
                    setState(() {
                      module.selected = true;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// 应用组（未选中）
            if (unselectedApp.isNotEmpty) ...[
              _GroupTitle(title: '应用'),
              const SizedBox(height: 10),
              ...unselectedApp.map(
                (module) => _ModuleCard(
                  title: module.title,
                  selected: false,
                  onAction: () {
                    setState(() {
                      module.selected = true;
                    });
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// =======================
/// 模块模型
/// =======================
class DashboardModule {
  final String id;
  final String title;
  final Widget content;
  final String group; // 添加分组字段
  bool selected;

  DashboardModule({
    required this.id,
    required this.title,
    required this.content,
    required this.group, // 添加分组字段
    required this.selected,
  });
}

/// =======================
/// 模块卡片
/// =======================
class _ModuleCard extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onAction;

  const _ModuleCard({
    required this.title,
    required this.selected,
    required this.onAction,
  });

  /// 根据标题获取图标和颜色
  _ModuleIconConfig _getIconConfig() {
    // 根据标题判断模块类型，分配图标和颜色
    if (title.contains('资讯') || title.contains('新闻')) {
      return _ModuleIconConfig(
        icon: Icons.article_outlined,
        iconBgColor: const Color(0xFFE3F2FD), // 浅蓝色
        iconColor: const Color(0xFF1976D2), // 深蓝色
      );
    } else if (title.contains('汇率') || title.contains('图表')) {
      return _ModuleIconConfig(
        icon: Icons.show_chart,
        iconBgColor: const Color(0xFFE8F5E9), // 浅绿色
        iconColor: const Color(0xFF388E3C), // 深绿色
      );
    } else if (title.contains('报表')) {
      return _ModuleIconConfig(
        icon: Icons.description_outlined,
        iconBgColor: const Color(0xFFF3E5F5), // 浅紫色
        iconColor: const Color(0xFF7B1FA2), // 深紫色
      );
    } else if (title.contains('市场采购')) {
      return _ModuleIconConfig(
        icon: Icons.shopping_cart_outlined,
        iconBgColor: const Color(0xFFFFF3E0), // 浅橙色
        iconColor: const Color(0xFFE65100), // 深橙色
      );
    } else if (title.contains('样品间')) {
      return _ModuleIconConfig(
        icon: Icons.inventory_2_outlined,
        iconBgColor: const Color(0xFFE1F5FE), // 浅青色
        iconColor: const Color(0xFF0277BD), // 深青色
      );
    } else if (title.contains('验货')) {
      return _ModuleIconConfig(
        icon: Icons.check_circle_outline,
        iconBgColor: const Color(0xFFE8F5E9), // 浅绿色
        iconColor: const Color(0xFF2E7D32), // 深绿色
      );
    } else if (title.contains('客户')) {
      return _ModuleIconConfig(
        icon: Icons.people_outline,
        iconBgColor: const Color(0xFFEDE7F6), // 浅紫色
        iconColor: const Color(0xFF5E35B1), // 深紫色
      );
    } else if (title.contains('供应商')) {
      return _ModuleIconConfig(
        icon: Icons.factory_outlined,
        iconBgColor: const Color(0xFFFFEBEE), // 浅红色
        iconColor: const Color(0xFFC62828), // 深红色
      );
    } else {
      // 默认配置
      return _ModuleIconConfig(
        icon: Icons.dashboard_outlined,
        iconBgColor: const Color(0xFFFCE4EC), // 浅粉色
        iconColor: const Color(0xFF616161), // 深灰色
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getIconConfig();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [
              /// 左侧 icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: config.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(config.icon, color: config.iconColor, size: 26),
              ),
              const SizedBox(width: 16),

              /// 文本
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selected ? '已选中' : '未选中',
                      style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 右上角加减号
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onAction,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? Colors.redAccent : Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (selected ? Colors.redAccent : Colors.blueAccent)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                selected ? Icons.remove : Icons.add,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 模块图标配置
class _ModuleIconConfig {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  _ModuleIconConfig({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

/// =======================
/// 区块标题（一级菜单）
/// =======================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 1.3,
            ),
      ),
    );
  }
}

/// =======================
/// 组标题（二级菜单）
/// =======================
class _GroupTitle extends StatelessWidget {
  final String title;

  const _GroupTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
      ),
    );
  }
}

/// =======================
/// 空状态组件
/// =======================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 20,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            '暂无选中的模块',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
