import 'package:cloud/pages/changxiang_inventory/provider/provider.dart';
import 'package:cloud/pages/changxiang_inventory/widgets/inventory_item_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 在仓明细列表
class InventoryList extends HookConsumerWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cxInventoryProvider);
    final stationNotifier = ref.read(cxInventoryProvider.notifier);

    return MuListView(
      state: state,
      list: state.list,
      onRefresh: () async {
        await stationNotifier.load();
      },
      onLoadMore: () async {
        await stationNotifier.load(refresh: false);
      },
      refreshOnStart: false,
      itemBuilder: (context, item) => InventoryItemCard(item: item),
      hPadding: 16,
    );
  }
}
