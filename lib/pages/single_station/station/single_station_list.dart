import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/station_item_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 独立站列表
class SingleStationList extends HookConsumerWidget {
  const SingleStationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singleStationProvider);
    final stationNotifier = ref.read(singleStationProvider.notifier);

    void onTap(SingleStationItem? item) {
      stationNotifier.setStationId(item?.id);
      context.router.push(SingleStationDetailRoute(item: item));
    }

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
      itemBuilder: (context, item) => StationItemCard(
        item: item,
        onTap: () => onTap(item),
      ),
      hPadding: 16,
    );
  }
}
