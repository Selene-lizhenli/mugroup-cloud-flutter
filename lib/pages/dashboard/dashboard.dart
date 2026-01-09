import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/entry_grid_module.dart';
import 'package:cloud/pages/dashboard/widgets/home_user_header.dart';
import 'package:cloud/pages/dashboard/widgets/selected_modules_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> with WidgetsBindingObserver {
  late GlobalKey<State<SelectedModulesWidget>> _selectedModulesKey;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedModulesKey = GlobalKey<State<SelectedModulesWidget>>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 监听应用生命周期，当应用从后台恢复时刷新
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshModules();
    }
  }

  // 刷新模块
  Future<void> _refreshModules() async {
    final state = _selectedModulesKey.currentState;
    // 使用 dynamic 类型访问 refresh 方法
    if (state != null) {
      try {
        final dynamic stateDynamic = state;
        await stateDynamic.refresh();
      } catch (e) {
        // 忽略错误
      }
    }
  }

  Future<void> _onRefresh() async {
    await _refreshModules();
  }

  @override
  Widget build(BuildContext context) {
    
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint,
        ),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              const HomeUserHeader(),
              const SizedBox(height: 12),
              const EntryGridModule(),
              const SizedBox(height: 12),
              SelectedModulesWidget(key: _selectedModulesKey),
            ],
          ),
        ),
      ),
    );
  }
}
