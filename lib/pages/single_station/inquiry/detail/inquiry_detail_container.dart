import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/pages/single_station/inquiry/detail/inquiry_basic_info_tab.dart';
import 'package:cloud/pages/single_station/inquiry/detail/inquiry_products_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 询盘详情容器页面（风格参考 DefaultDetailContainer）

class InquiryDetailContainer extends HookConsumerWidget {
  const InquiryDetailContainer({
    super.key,
    required this.item,
  });

  final SingleStationInquiries? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inquiryDetailTitle),
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
                  tabs: [
                    Tab(text: l10n.inquiryBasicInfoTab),
                    Tab(text: l10n.stationDetailSamplesTab),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      InquiryBasicInfoTab(item: item),
                      InquiryProductsTab(inquiry: item),
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
