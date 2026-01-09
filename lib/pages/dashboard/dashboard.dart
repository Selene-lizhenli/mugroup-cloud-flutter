import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/dashboard/widgets/entry_grid_module.dart';
import 'package:cloud/pages/dashboard/widgets/home_user_header.dart';
import 'package:cloud/pages/dashboard/widgets/selected_modules_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardPage extends HookConsumerWidget {
  final GlobalKey<State<SelectedModulesWidget>>? selectedModulesKey;

  const DashboardPage({super.key, this.selectedModulesKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final internalKey = useMemoized(
      () => GlobalKey<State<SelectedModulesWidget>>(),
    );
    final selectedModulesKey = this.selectedModulesKey ?? internalKey;
    final scrollController = useScrollController();

    // 使用 useRef 保存 refresh 函数，确保生命周期回调能访问到最新的函数
    final refreshModulesRef = useRef<Future<void> Function()?>(null);

    // 刷新模块的函数
    Future<void> refreshModules() async {
      final state = selectedModulesKey.currentState;
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

    // 更新 ref 中的函数引用
    refreshModulesRef.value = refreshModules;

    // 监听应用生命周期，当应用从后台恢复时刷新
    useEffect(() {
      final observer = _LifecycleObserver(() async {
        await refreshModulesRef.value?.call();
      });
      WidgetsBinding.instance.addObserver(observer);
      return () {
        WidgetsBinding.instance.removeObserver(observer);
      };
    }, []);

    Future<void> onRefresh() async {
      logger.d('onRefresh');
      await refreshModules();
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint,
        ),
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              const HomeUserHeader(),
              const SizedBox(height: 12),
              const EntryGridModule(),
              const SizedBox(height: 12),
              SelectedModulesWidget(key: selectedModulesKey),
            ],
          ),
        ),
      ),
    );
  }
}

// 生命周期观察者类
class _LifecycleObserver extends WidgetsBindingObserver {
  final Future<void> Function() onResumed;

  _LifecycleObserver(this.onResumed);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
