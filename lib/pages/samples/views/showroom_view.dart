 
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/widgets/empty.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/warehous_item_card.dart';

// 样品间列表页
class SamplesPageView extends HookConsumerWidget {
  const SamplesPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    useEffect(() {
      Future.microtask(() async {
        await homeNotifier.fetchWarehouses();
      });

      return null;
    }, []);

    if (home.isLoadingWarehouses) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 过滤掉 abandoned 为 true 的样品间
    final filteredWarehouses = home.warehouses
        .where((warehouse) => warehouse.abandoned != true)
        .toList();


    // 使用 ListView.builder 构建可滚动列表，避免使用 ListView.separated
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.2;


    if (filteredWarehouses.isEmpty) {
      return const Center(
        child: Empty(  icon: FontAwesomeIcons.boxOpen,),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      cacheExtent: 500, // 增加缓存范围，减少重建
      itemCount: filteredWarehouses.length,
      itemBuilder: (context, index) {
        final warehouse = filteredWarehouses[index];
        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: index == filteredWarehouses.length - 1 ? 0 : 8),
            child: WarehouseShowCard(
              warehouse: warehouse,
              imageHeight: imageHeight,
            ),
          ),
        );
      },
    );
  }
}
 