import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// 列表状态接口，供 MuListView 复用（如独立站、比价助手、批量图搜等）
abstract class MuListState {
  bool get isLoading;
  String? get errorMessage;
  bool get hasMore;
}

/// 可复用的列表组件
class MuListView<T> extends HookWidget {
  final MuListState state;
  final List<T> list;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final bool? refreshOnStart;
  final double? hPadding;
  final bool? isAdapColumn;

  const MuListView({
    super.key,
    required this.state,
    required this.list,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.refreshOnStart,
    this.hPadding = 0.0,
    this.isAdapColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    var crossAxisCount = 1;
    if (isAdapColumn == true) {
      final mediaQuery = MediaQuery.of(context);
      if (mediaQuery.size.width > 200) {
        crossAxisCount = 2;
      }
      if (mediaQuery.size.width > 500) {
        crossAxisCount = 3;
      }
      if (mediaQuery.size.width > 800) {
        crossAxisCount = 4;
      }
    }

    if (state.isLoading && list.isEmpty) {
      return Center(
        child: MuProgressIndicator(text: '${l10n.loading}...', showText: true),
      );
    }

    if (state.errorMessage != null && list.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: TextStyle(color: colorScheme.error, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (list.isEmpty) {
      return Center(
        child: Empty(
          text: l10n.noData,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(hPadding ?? 0, 2, hPadding ?? 0, 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: EasyRefresh(
        controller: refreshController,
        refreshOnStart: refreshOnStart ?? true,
        onRefresh: () async {
          try {
            await onRefresh();
            refreshController.finishRefresh();
          } catch (e) {
            refreshController.finishRefresh(IndicatorResult.fail, false);
          } finally {
            refreshController.resetFooter();
          }
        },
        onLoad: () async {
          await onLoadMore();
          refreshController.finishLoad(
            state.hasMore ? IndicatorResult.success : IndicatorResult.noMore,
          );
        },
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverPadding(
                  padding: const EdgeInsets.all(0),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: isAdapColumn == true ? 5 : 0,
                    crossAxisSpacing: isAdapColumn == true ? 5 : 0,
                    childCount: list.length,
                    itemBuilder: (context, index) {
                      final itemValue = list[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          itemBuilder(context, itemValue),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
