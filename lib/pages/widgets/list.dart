import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
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

  const MuListView({
    super.key,
    required this.state,
    required this.list,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.refreshOnStart,
    this.hPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    if (state.isLoading && list.isEmpty) {
      return const Center(
        child: MuProgressIndicator(text: '加载中...', showText: true),
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
      return const Center(
        child: Empty(
          text: '暂无数据',
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(hPadding ?? 0, 2, hPadding ?? 0, 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
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
                  padding: const EdgeInsets.all(5),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 0,
                    childCount: list.length,
                    itemBuilder: (context, index) {
                      final itemValue = list[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // if (index < list.length - 1)
                          //   Divider(
                          //     height: 1,
                          //     thickness: 1,
                          //     color:
                          //         colorScheme.outlineVariant.withOpacity(0.5),
                          //   ),
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
