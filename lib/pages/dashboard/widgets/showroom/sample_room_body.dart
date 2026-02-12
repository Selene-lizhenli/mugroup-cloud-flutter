import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/models/dashboard/ship_top_stats.dart'; 
import 'package:cloud/pages/dashboard/widgets/showroom/quote_cart.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/ship_cart.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 样品间模块内容主体
class SampleRoomBody extends ConsumerWidget {
  final bool isLoading;
  final void Function(GlobalKey) handleExpandScroll;
  final List<ShipTopStats> shipTopDimensionData;
  final DateRange shipDateRange;
  final void Function(Map<String, String>?) handleShipRankData;
  final List<QuoteTopStats> quoteTopDimensionData;
  final DateRange quoteDateRange;
  final void Function(Map<String, String>?) handleQuoteRankData;

  const SampleRoomBody({
    super.key,
    required this.isLoading,
    required this.handleExpandScroll,
    required this.shipTopDimensionData,
    required this.shipDateRange,
    required this.handleShipRankData,
    required this.quoteTopDimensionData,
    required this.quoteDateRange,
    required this.handleQuoteRankData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentDimension = ref.watch(
      dashboardStatsProvider.select((state) => state.sampleRoomDimension),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
           boxShadow: const [
            BoxShadow(
              color: pageShadowColor,
              blurRadius: 10,
              offset: Offset(0, 0), // 上下左右均匀阴影
            ),
          ],
      ),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 根据数据状态显示内容
          if (currentDimension == sampleDimensionConfigs[0]['value'])
            ShipTopChartContent(
              isLoading: isLoading,
              handleExpandScroll: handleExpandScroll,
              data: shipTopDimensionData,
              selectedRange: shipDateRange,
              onRangeChanged: (DateRange range, Map<String, String> params) {
                handleShipRankData(params);
              },
            )
          else if (currentDimension == sampleDimensionConfigs[1]['value'])
            QuoteTopChartContent(
              handleExpandScroll: handleExpandScroll,
              isLoading: isLoading,
              data: quoteTopDimensionData,
              selectedRange: quoteDateRange,
              onRangeChanged: (DateRange range, Map<String, String> params) {
                handleQuoteRankData(params);
              },
            )
          else
            isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: MuProgressIndicator(),
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text("暂无数据"),
                    ),
                  )
        ],
      ),
    );
  }
}
