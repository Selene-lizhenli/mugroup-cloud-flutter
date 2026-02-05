import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/station_product_card.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// 询盘详情 - 样品明细 Tab
/// 复用现有的样品卡片和列表结构，数据来源为 loadInquiriesProducts
class InquiryProductsTab extends HookConsumerWidget {
  const InquiryProductsTab({super.key, required this.inquiry});

  final SingleStationInquiries? inquiry;

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
      // 首次进入时加载当前询盘的样品明细
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (inquiry?.id != null) {
          stationNotifier.loadInquiriesProducts();
        }
      });
      // 离开 Tab 时清理数据
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            stationNotifier.cleanInquiriesProducts();
          });
    }, const []);

    if (state.isLoading && state.inquiriesProductList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.errorMessage != null && state.inquiriesProductList.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: TextStyle(color: colorScheme.error, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.inquiriesProductList.isEmpty) {
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
            await stationNotifier.loadInquiriesProducts();
            refreshController.finishRefresh();
          } catch (e) {
            refreshController.finishRefresh(IndicatorResult.fail, false);
          } finally {
            refreshController.resetFooter();
          }
        },
        onLoad: () async {
          await stationNotifier.loadInquiriesProducts(
            refresh: false,
          );
          refreshController.finishLoad(
            state.hasMore ? IndicatorResult.success : IndicatorResult.noMore,
          );
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
                    childCount: state.inquiriesProductList.length,
                    itemBuilder: (context, index) {
                      final itemValue = state.inquiriesProductList[index];
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
