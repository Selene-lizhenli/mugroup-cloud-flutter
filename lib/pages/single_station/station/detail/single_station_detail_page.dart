import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/station/detail/christmas_detail_container.dart';
import 'package:cloud/pages/single_station/station/detail/default_detail_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SingleStationDetailPage extends HookConsumerWidget {
  const SingleStationDetailPage({
    super.key,
    required this.item,
  });

  final SingleStationItem? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationTheme = (item?.theme ?? '').toLowerCase();
    if (stationTheme.contains('christmas')) {
      return ChristmasDetailContainer(item: item);
    }
    return DefaultDetailContainer(item: item);
  }
}
