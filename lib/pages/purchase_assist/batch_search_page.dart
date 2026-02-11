import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/widgets/task_list_item_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    }

    useEffect(() {
      // 首次进入时加载当前询盘的样品明细
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadTaskList();
      });
      // 离开 Tab 时清理数据
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            // notifier.cleanInquiriesProducts();
          });
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('批量图搜结果'),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: MuListView<PurchaseAssistTaskListItem>(
        state: state,
        list: state.taskList,
        onRefresh: () => notifier.loadTaskList(refresh: true),
        onLoadMore: () => notifier.loadTaskList(),
        refreshOnStart: false,
        itemBuilder: (context, item) => TaskListItemCard(
          item: item, 
          onTap: () => onTap(item),
        ),
      ),
    );
  }
}
