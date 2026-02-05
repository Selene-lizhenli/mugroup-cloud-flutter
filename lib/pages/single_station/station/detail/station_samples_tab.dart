 
 
import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/station_product_card.dart'; 
import 'package:cloud/pages/widgets/empty.dart'; 
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class StationSamplesTab extends HookConsumerWidget {
  const StationSamplesTab({super.key, required this.stationItem});

  final SingleStationItem? stationItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singleStationProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    final stationNotifier = ref.read(singleStationProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stationNotifier.loadStationSamples();
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            stationNotifier.cleanStationSamples();
          });
    }, const []);

    if (state.isLoading && state.stationSampleList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null && state.stationSampleList.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: TextStyle(color: colorScheme.error, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.stationSampleList.isEmpty) {
      return const Center(
        child: Empty(
          text: '暂无数据',
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 2, 12, 0),
      decoration: const BoxDecoration( 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: EasyRefresh(
        controller: refreshController,
        refreshOnStart: false,
        onRefresh: () async {
          try {
            await stationNotifier.loadStationSamples();
            refreshController.finishRefresh();
          } catch (e) {
            refreshController.finishRefresh(IndicatorResult.fail, false);
          } finally {
            refreshController.resetFooter();
          }
        },
        onLoad: () async {
          await stationNotifier.loadStationSamples(
            refresh: false,
          );
          refreshController.finishLoad(
              state.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
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
                    childCount: state.stationSampleList.length,
                    
                    itemBuilder: (context, index) {
                      final itemValue = state.stationSampleList[index];
                      return StationProductCard(stationSample: itemValue);
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
