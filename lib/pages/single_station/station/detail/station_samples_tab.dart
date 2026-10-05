import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/station_product_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StationSamplesTab extends HookConsumerWidget {
  const StationSamplesTab({super.key, required this.stationItem});

  final SingleStationItem? stationItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singleStationProvider);

    final stationNotifier = ref.read(singleStationProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stationNotifier.loadStationSamples();
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            stationNotifier.cleanStationSamples();
          });
    }, const []);

    return MuListView<SingleStationSample>(
      state: state,
      list: state.stationSampleList,
      hPadding: 12,
      onRefresh: () async {
        await stationNotifier.loadStationSamples();
      },
      onLoadMore: () async {
        await stationNotifier.loadStationSamples(refresh: false);
      },
      refreshOnStart: false,
      itemBuilder: (context, item) => StationProductCard(
        item: item,
      ),
    );
  }
}
