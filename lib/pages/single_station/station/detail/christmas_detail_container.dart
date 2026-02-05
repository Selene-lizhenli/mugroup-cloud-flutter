import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/station/detail/basic_info_tab.dart';
import 'package:cloud/pages/single_station/station/detail/station_samples_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
 
class  ChristmasDetailContainer extends HookConsumerWidget {
  const ChristmasDetailContainer({
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
          style: TextStyle(color: colorScheme.surface),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.surface,
          ),
          onPressed: () => context.router.maybePop(),
        ),
        backgroundColor: const Color(0xFF165B33),
      ),
      body: Stack(
        children: [
          // 最底层：渐变
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    const Color(0xFF165B33), // 绿色
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                  ],
                ),
              ),
            ),
          ),
          // 中间层：图片
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/photo/christmastree.png',
              fit: BoxFit.contain,
              width: 280,
            ),
          ),
          // 最上层：TabBar + TabBarView
          Positioned.fill(
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
                      StationSamplesTab(
                          stationItem: item, ),
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
