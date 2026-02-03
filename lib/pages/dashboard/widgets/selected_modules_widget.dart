import 'package:cloud/constants/app_stat_module.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final permissionBools = ref.read(entryFeaturePermissionBoolsProvider);
    final modules = await DashboardModules.getOrderedModules(
      permissionBools,
      isSelected: true,
    );
    logger.d(
        'dashboard页面选中的modules: ${modules.map((e) => '${e.id} ${e.visible} ${e.selected}')}');
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
