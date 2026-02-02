import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/app_feature_constants.dart'; 
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_chart_main.dart';
import 'package:cloud/pages/setting/widgets/setting_modlue_card.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room.main.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  static const _storageKey = 'selected_module_ids';
  static const _orderKey = 'module_order_ids';

  late List<DashboardModule> modules;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initModules();
  }

  /// =======================
  /// 初始化：从本地读取选中模块和排序顺序
  /// =======================
  Future<void> _initModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds = prefs.getStringList(_storageKey) ??
        ['rate', EntryFeatures.showroomSample.id];
    final orderIds = prefs.getStringList(_orderKey) ??
        ['rate', EntryFeatures.showroomSample.id];

    /// 所有模块（固定定义）
    final allModules = [
      DashboardModule(
        id: 'rate',
        title: '汇率',
        content: const LineChartDemo(),
        group: '应用', // 添加分组
        selected: selectedIds.contains('rate'),
      ),
      DashboardModule(
        id: EntryFeatures.showroomSample.id,
        title: "Top榜单",
        content: const SampleRoomChart(),
        group: '数据统计', // 添加分组
        selected: selectedIds.contains(EntryFeatures.showroomSample.id),
      ),
      // DashboardModule(
      //   id: 'news',
      //   title: '集团资讯',
      //   content: const NewsBoard(),
      //   group: '应用', // 添加分组
      //   selected: selectedIds.contains('news'),
      // ),
      // DashboardModule(
      //  id: EntryFeatures.marketPurchase.id,
      // title: EntryFeatures.marketPurchase.title,
      //   content: const MarketPurchaseChart(),
      //   group: '数据统计', // 添加分组
      //   selected: selectedIds.contains('market_purchase'),
      // ),
      // DashboardModule(
      //   id: EntryFeatures.crmCompany.id,
      //   title: EntryFeatures.crmCompany.title,
      //   content: const CustomerChart(),
      //   group: '数据统计', // 添加分组
      //   selected: selectedIds.contains(EntryFeatures.crmCompany.id),
      // ),
      // DashboardModule(
      //   id: EntryFeatures.supplySupplier.id,
      //   title: EntryFeatures.supplySupplier.title,
      //   content: const SupplierChart(),
      //   group: '数据统计', // 添加分组
      //   selected: selectedIds.contains(EntryFeatures.supplySupplier.id),
      // ),

      // DashboardModule(
      //   id: EntryFeatures.inspection.id,
      //   title: EntryFeatures.inspection.title,
      //   content: const InspectionChart(),
      //   group: '数据统计', // 添加分组
      //   selected: selectedIds.contains(EntryFeatures.inspection.id),
      // ),
    ];

    // 如果存在排序顺序，按照保存的顺序重新排列
    if (orderIds.isNotEmpty) {
      final orderedModules = <DashboardModule>[];
      final moduleMap = {for (var m in allModules) m.id: m};

      // 首先添加已排序的模块
      for (final id in orderIds) {
        if (moduleMap.containsKey(id)) {
          orderedModules.add(moduleMap[id]!);
        }
      }

      // 然后添加未排序的新模块
      for (final module in allModules) {
        if (!orderIds.contains(module.id)) {
          orderedModules.add(module);
        }
      }

      modules = orderedModules;
    } else {
      modules = allModules;
    }

    setState(() {
      _loading = false;
    });
  }

  /// =======================
  /// 保存当前选中模块和排序顺序
  /// =======================
  Future<void> _saveSelectedModules() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds =
        modules.where((e) => e.selected).map((e) => e.id).toList();
    final orderIds = modules.map((e) => e.id).toList();

    await prefs.setStringList(_storageKey, selectedIds);
    await prefs.setStringList(_orderKey, orderIds);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('模块配置已保存'),
          backgroundColor: Colors.green,
          padding: EdgeInsets.all(20)),
    );
  }

  /// =======================
  /// 处理组内拖拽排序（已选中模块）
  /// =======================
  void _onReorderSelected(String group, int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // 获取该组已选中的模块，保持它们在 modules 列表中的原始顺序
      final selectedInGroup = <DashboardModule>[];
      for (final module in modules) {
        if (module.group == group && module.selected) {
          selectedInGroup.add(module);
        }
      }

      if (oldIndex >= selectedInGroup.length ||
          newIndex >= selectedInGroup.length ||
          oldIndex < 0 ||
          newIndex < 0) {
        return;
      }

      // 在组内重新排序
      final item = selectedInGroup.removeAt(oldIndex);
      selectedInGroup.insert(newIndex, item);

      // 重新构建整个 modules 列表，保持组之间的相对位置
      final newModules = <DashboardModule>[];
      int selectedIndex = 0; // 用于跟踪已选中的新顺序索引

      // 遍历原始列表，保持相对位置，只更新该组已选中的顺序
      for (final module in modules) {
        if (module.group == group && module.selected) {
          // 使用新的顺序
          newModules.add(selectedInGroup[selectedIndex]);
          selectedIndex++;
        } else {
          // 其他模块保持原位置
          newModules.add(module);
        }
      }

      modules = newModules;
    });
  }

  /// =======================
  /// 处理组内拖拽排序（未选中模块）
  /// =======================
  void _onReorderUnselected(String group, int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // 获取该组未选中的模块，保持它们在 modules 列表中的原始顺序
      final unselectedInGroup = <DashboardModule>[];
      for (final module in modules) {
        if (module.group == group && !module.selected) {
          unselectedInGroup.add(module);
        }
      }

      if (oldIndex >= unselectedInGroup.length ||
          newIndex >= unselectedInGroup.length ||
          oldIndex < 0 ||
          newIndex < 0) {
        return;
      }

      // 在组内重新排序
      final item = unselectedInGroup.removeAt(oldIndex);
      unselectedInGroup.insert(newIndex, item);

      // 重新构建整个 modules 列表，保持组之间的相对位置
      final newModules = <DashboardModule>[];
      int unselectedIndex = 0; // 用于跟踪未选中的新顺序索引

      // 遍历原始列表，保持相对位置，只更新该组未选中的顺序
      for (final module in modules) {
        if (module.group == group && !module.selected) {
          // 使用新的顺序
          newModules.add(unselectedInGroup[unselectedIndex]);
          unselectedIndex++;
        } else {
          // 其他模块保持原位置
          newModules.add(module);
        }
      }

      modules = newModules;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(coreProvider.notifier);
    if (_loading) {
      return const Scaffold(
        body: Center(child: MuProgressIndicator()),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 设置 prePath 为 'setting'，然后返回
            notifier.setPrePath('setting');
            context.router.back();
          },
        ),
        backgroundColor: colorScheme.surfaceTint,
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
              _ReorderableModuleList(
                modules: selectedDataOverview,
                selected: true,
                group: '数据统计',
                onReorder: _onReorderSelected,
                onToggle: (module) {
                  setState(() {
                    module.selected = false;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            /// 应用组（已选中）
            if (selectedApp.isNotEmpty) ...[
              const _GroupTitle(title: '应用'),
              const SizedBox(height: 10),
              _ReorderableModuleList(
                modules: selectedApp,
                selected: true,
                group: '应用',
                onReorder: _onReorderSelected,
                onToggle: (module) {
                  setState(() {
                    module.selected = false;
                  });
                },
              ),
            ],
          ] else ...[
            // 如果没有选中的模块，显示空状态
            const _EmptyState(),
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
              const _GroupTitle(title: '数据统计'),
              const SizedBox(height: 10),
              _ReorderableModuleList(
                modules: unselectedDataOverview,
                selected: false,
                group: '数据统计',
                onReorder: _onReorderUnselected,
                onToggle: (module) {
                  setState(() {
                    module.selected = true;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            /// 应用组（未选中）
            if (unselectedApp.isNotEmpty) ...[
              const _GroupTitle(title: '应用'),
              const SizedBox(height: 10),
              _ReorderableModuleList(
                modules: unselectedApp,
                selected: false,
                group: '应用',
                onReorder: _onReorderUnselected,
                onToggle: (module) {
                  setState(() {
                    module.selected = true;
                  });
                },
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
/// 可拖拽排序的模块列表
/// =======================
class _ReorderableModuleList extends StatelessWidget {
  final List<DashboardModule> modules;
  final bool selected;
  final String group;
  final Function(String, int, int) onReorder;
  final Function(DashboardModule) onToggle;

  const _ReorderableModuleList({
    required this.modules,
    required this.selected,
    required this.group,
    required this.onReorder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (modules.length == 1) {
      // 只有一个模块时，不需要拖拽功能，直接显示
      final module = modules[0];
      return SettingModuleCard(
        key: ValueKey(module.id),
        title: module.title,
        selected: selected,
        onAction: () => onToggle(module),
        dragIndex: null, // 单个模块不需要拖拽
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      onReorder: (oldIndex, newIndex) {
        onReorder(group, oldIndex, newIndex);
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final animValue = Curves.easeInOut.transform(animation.value);
            final elevation = 0.0 + (6.0 - 0.0) * animValue;
            return Material(
              elevation: elevation,
              color: Colors.transparent,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(14),
              child: child,
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final module = modules[index];
        return SettingModuleCard(
          key: ValueKey(module.id),
          title: module.title,
          selected: selected,
          onAction: () => onToggle(module),
          dragIndex: index, // 传递索引用于拖拽
        );
      },
    );
  }
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
