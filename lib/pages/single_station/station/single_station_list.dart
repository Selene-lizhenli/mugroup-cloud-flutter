// import 'package:auto_route/auto_route.dart';
// import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
// import 'package:cloud/models/single_station/single_station_item.dart';
// import 'package:cloud/pages/single_station/provider/provider.dart';
// import 'package:cloud/pages/single_station/widgets/station_item_card.dart';
// import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
// import 'package:cloud/pages/widgets/empty.dart';
// import 'package:cloud/router/router.gr.dart';
// import 'package:easy_refresh/easy_refresh.dart';
// import 'package:flutter/material.dart'; 
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sliver_tools/sliver_tools.dart';

// /// 独立站列表
// class StationList extends HookConsumerWidget {
//   const StationList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(singleStationProvider);
//     final colorScheme = Theme.of(context).colorScheme;
//     final refreshController = useEasyRefreshController(
//       controlFinishLoad: true,
//       controlFinishRefresh: true,
//     );
//     final stationNotifier = ref.read(singleStationProvider.notifier);

//     if (state.isLoading && state.list.isEmpty) {
//       return const Center(
//         child: MuProgressIndicator(text: '加载中...', showText: true),
//       );
//     }

//     if (state.errorMessage != null && state.list.isEmpty) {
//       return Center(
//         child: Text(
//           state.errorMessage!,
//           style: TextStyle(color: colorScheme.error, fontSize: 14),
//           textAlign: TextAlign.center,
//         ),
//       );
//     }

//     if (state.list.isEmpty) {
//       return const Center(
//         child: Empty(
//           text: '暂无数据', 
//         ),
//       );
//     }

//     void onTap(SingleStationItem? item) {
//       stationNotifier.setStationId(item?.id);
//       context.router.push(SingleStationDetailRoute(item: item));
//     }

//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 2, 12, 0),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceTint,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(8),
//           topRight: Radius.circular(8),
//         ),
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: EasyRefresh(
//         controller: refreshController,
//         refreshOnStart: true,
//         onRefresh: () async {
//           try {
//             await stationNotifier.load();
//             refreshController.finishRefresh();
//           } catch (e) {
//             refreshController.finishRefresh(IndicatorResult.fail, false);
//           } finally {
//             refreshController.resetFooter();
//           }
//         },
//         onLoad: () async {
//           await stationNotifier.load(
//             refresh: false,
//           );
//           refreshController.finishLoad(
//               state.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
//         },
//         child: CustomScrollView(
//           slivers: [
//             MultiSliver(
//               children: [
//                 SliverPadding(
//                   padding: const EdgeInsets.all(5),
//                   sliver: SliverMasonryGrid.count(
//                     crossAxisCount: 1,
//                     mainAxisSpacing: 0,
//                     childCount: state.list.length,
//                     itemBuilder: (context, index) {
//                       final itemValue = state.list[index];
//                       return StationItemCard(
//                         item: itemValue,
//                         onTap: () => onTap(itemValue),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:auto_route/auto_route.dart'; 
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/provider/provider.dart'; 
import 'package:cloud/pages/single_station/station/station_item_card.dart';
import 'package:cloud/pages/single_station/widgets/list.dart'; 
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

    return SingleStationListView(
      state: state,
      list: state.list,
      onRefresh: () async {
        await stationNotifier.load();
      },
      onLoadMore: () async {
        await stationNotifier.load(refresh: false);
      },
      itemBuilder: (context, item) => StationItemCard(
        item: item,
        onTap: () => onTap(item),
      ),
    );
  }
}

