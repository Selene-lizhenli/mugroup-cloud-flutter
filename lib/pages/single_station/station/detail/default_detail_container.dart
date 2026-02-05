import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/station/detail/basic_info_tab.dart';
import 'package:cloud/pages/single_station/station/detail/station_samples_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultDetailContainer extends HookConsumerWidget {
  const DefaultDetailContainer({
    super.key,
    required this.item,
  });

  final SingleStationItem? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item?.nameCn ?? item?.nameEn ?? '独立站详情',
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () => context.router.maybePop(),
        ),
        // backgroundColor: colorScheme.primary,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  // const Color(0xFF165B33), // 绿色
                  // colorScheme.primary,
                  colorScheme.surfaceTint,
                  colorScheme.surfaceTint,
                  colorScheme.surfaceTint,
                  colorScheme.surfaceTint,
                ],
              ),
            ),
            child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(text: '基本信息'),
                    Tab(text: '样品明细'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BasicInfoTab(item: item),
                      StationSamplesTab(stationItem: item),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
