import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/helper/theme.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
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
    ref.watch(cartProvider); //禁止删除，监听Pda扫描动作
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

    return Stack(
      children: [
        // 最底层背景色
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter, 
                colors: isSpringFestival || isYuanxiaoFestival
                    ? [
                        const Color.fromARGB(235, 168, 20, 9),
                        const Color.fromARGB(235, 176, 38, 28),
                        colorScheme.surfaceTint,
                        colorScheme.surfaceTint,
                      ]
                    : [
                        colorScheme.surfaceTint,
                        colorScheme.surfaceTint,
                      ],
                stops: isSpringFestival || isYuanxiaoFestival
                    ? const [0.0, 0.2, 0.6, 1.0]
                    : const [0.0, 1],
              ),
            ),
          ),
        ),
        // 最底层背景图：顶部对齐
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Image.asset(
            getBackgroundPic,
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
          ),
        ),
        SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
                  child: HomeUserHeader(),
                ),
                Stack(
                  children: [
                    // if (notNeedTopPosition) ...[const SizedBox(height: 1)] else
                    //   Positioned.fill(
                    //     top: 70,
                    //     child: Container(color: colorScheme.surfaceTint),
                    //   ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: pageHorizontalPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          const EntryGridModule(),
                          const SizedBox(height: 5),
                          SelectedModulesWidget(key: selectedModulesKey),
                          const SizedBox(height: 20), 
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
