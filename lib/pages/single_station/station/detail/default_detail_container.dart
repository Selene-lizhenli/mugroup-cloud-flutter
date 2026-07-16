import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/station/detail/basic_info_tab.dart';
import 'package:cloud/pages/single_station/station/detail/station_samples_tab.dart';
import 'package:cloud/pages/widgets/text_adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultDetailContainer extends HookConsumerWidget {
  const DefaultDetailContainer({
    super.key,
    required this.item,
    this.stationTheme = 'default',
  });

  final SingleStationItem? item;
  final String? stationTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tabController = useTabController(initialLength: 2);
    final colorScheme = Theme.of(context).colorScheme;

    // 渐变可调参数：角度（度，0=上→下，90=左→右）、颜色分界位置（0~1）
    const double gradientAngleDegrees = 0;
    final pageColor =
        stationTheme == 'meimeiimage' ? primaryColorPink : primaryColorBlue;
    final headerColor = pageColor.withOpacity(0.45); // 渐变颜色
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AdaptiveTitleText(
          title: item?.nameCn ?? item?.nameEn ?? l10n.stationDetailTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.router.maybePop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 最底层：渐变铺满整页
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: const GradientRotation(
                    gradientAngleDegrees * math.pi / 180,
                  ),
                  colors: [
                    headerColor,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.8,
                    )!,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.94,
                    )!,
                    colorScheme.surface,
                    colorScheme.surface,
                    Color.lerp(
                      colorScheme.surface,
                      colorScheme.surfaceTint,
                      0.8,
                    )!,
                  ],
                  stops: null,
                ),
              ),
            ),
          ),
          // 中间层：图片
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/photo/single_website.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // 上层：从 AppBar 下方开始的 TabBar + TabBarView
          Positioned(
            left: 0,
            right: 0,
            top: paddingTop + appbarHeight,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TabBar(
                    dividerColor: pageColor,
                    labelColor: pageColor,
                    indicatorColor: pageColor,
                    controller: tabController,
                    tabs: [
                      Tab(text: l10n.quoteBasicInfo),
                      Tab(text: l10n.stationDetailSamplesTab),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        BasicInfoTab(item: item),
                        StationSamplesTab(stationItem: item),
                      ],
                    ),
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
