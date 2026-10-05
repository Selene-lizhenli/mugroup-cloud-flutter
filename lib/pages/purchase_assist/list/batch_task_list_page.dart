import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/list/task_list_item_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart'; 
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class BatchImageSearchResultPage extends HookConsumerWidget {
  const BatchImageSearchResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);

    void onTap(PurchaseAssistTaskListItem? item) {
      if (item == null) return;
      notifier.setTaskId(item.id);
      context.router.push(const BatchSearchDetailRoute());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('批量图搜结果'),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
          child: MuListView<PurchaseAssistTaskListItem>(
            state: state,
            list: state.taskList,
            onRefresh: () => notifier.loadTaskList(refresh: true),
            onLoadMore: () => notifier.loadTaskList(),
            refreshOnStart: false,
            itemBuilder: (context, item) => TaskListItemCard(
              item: item,
              onTap: () => onTap(item),
            ),
          )),
    );
  }
}
