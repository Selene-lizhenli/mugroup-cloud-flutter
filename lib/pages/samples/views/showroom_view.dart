import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/widgets/warehous_item_card.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 展示样品间页面
class SamplesPageView extends HookConsumerWidget {
  const SamplesPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);

    final warehouses = home.warehouses;
    final pageScreenHeight = MediaQuery.of(context)
        .size
        .height; // 使用 ListView.builder 构建可滚动列表，避免使用 ListView.separated
    final pageScreenWidth = MediaQuery.of(context).size.width;

    if (home.isLoadingWarehouses) {
      return const Center(
        child: MuProgressIndicator(
          showText: true,
        ),
      );
    }
    if (warehouses.isEmpty) {
      return const Center(
        child: Empty(
          icon: FontAwesomeIcons.boxOpen,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      cacheExtent: 500, // 增加缓存范围，减少重建
      itemCount: warehouses.length,
      itemBuilder: (context, index) {
        final warehouse = warehouses[index];
        return RepaintBoundary(
          child: Padding(
            padding:
                EdgeInsets.only(bottom: index == warehouses.length - 1 ? 0 : 8),
            child: WarehouseShowCard(
              warehouse: warehouse,
              pageScreenHeight: pageScreenHeight,
              pageScreenWidth: pageScreenWidth,
            ),
          ),
        );
      },
    );
  }
}
