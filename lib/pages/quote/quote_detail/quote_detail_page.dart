import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/quote_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cloud/pages/quote/quote_detail/widgets/timeline_list.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_timeline_provider.dart';

@RoutePage()
class QuoteDetailPage extends HookConsumerWidget {
  final int userId;
  final int id;

  const QuoteDetailPage({
    super.key,
    @pathParam required this.userId,
    @pathParam required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteTimelineProvider(userId));
    final notifier = ref.read(quoteTimelineProvider(userId).notifier);

    final quoteDetailState = ref.watch(quoteDetailProvider);
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);
    final scrollController = useScrollController();

    /// 当前选中节点（只属于 UI）
    final currentIndex = useState<int>(
        id >= 0 ? state.list.indexWhere((item) => item.id == id) : 0);

    // logger.d(currentIndex.value);
    // logger.d(id);
    // logger.d(userId);

    useEffect(() {
      if (userId <= 0) return null;
      Future.microtask(() {
        notifier.refresh();
      });

      return () {
        notifier.clear();
      };
    }, [userId]);

    useEffect(() {
      if (id > 0) {
        Future.microtask(() {
          quoteDetailNotifier.fetchQuoteDetail(id);
        });
      }

      return () {
        // quoteDetailNotifier.clear();
      };
    }, [id]);

    // ******** 监听 list/id 变化更新 currentIndex ********
    useEffect(() {
      if (state.list.isNotEmpty && id != 0) {
        final targetIndex = state.list.indexWhere((item) => item.id == id);
        if (targetIndex >= 0) {
          currentIndex.value = targetIndex;
        }
      }
      return null;
    }, [state.list, id]);

    /// 时间轴滚动到底 → 加载更多
    void onScroll(ScrollNotification notification) {
      if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 40 &&
          state.hasMore &&
          !state.isLoadingMore) {
        notifier.loadMore();
      }
    }

    /// 初始 loading
    if (state.isLoading && state.list.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 时间轴点击事件：取出对应id + 请求右侧数据
    void onTimelineTap(int index) {
      if (state.list.isEmpty || index >= state.list.length) return;
      // 1. 取出对应id
      final selectedId = state.list[index].id;
      // 2. 更新选中索引
      currentIndex.value = index;
      // 3. 请求右侧详情数据
      final nextId = state.list[index].id;
      if (nextId! > 0) quoteDetailNotifier.fetchQuoteDetail(nextId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('报价单详情'),
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          onScroll(notification);
          return false;
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  左侧时间轴
            // if (userId > 0)
            //   Container(
            //     padding: const EdgeInsets.fromLTRB(4, 20, 4, 20),
            //     // color: Theme.of(context).colorScheme.surface,
            //     child: SizedBox(
            //       width: 42,
            //       child: TimelineList(
            //         items: state.list,
            //         currentIndex: currentIndex.value,
            //         controller: scrollController,
            //         onTap: onTimelineTap,
            //       ),
            //     ),
            //   ),
            //  右侧详细信息
            Expanded(
              child: QuoteDetailBody(
                item: quoteDetailState.baseInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
