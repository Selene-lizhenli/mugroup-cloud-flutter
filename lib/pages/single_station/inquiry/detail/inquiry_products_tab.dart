import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/station_product_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 询盘详情 - 样品明细 Tab
/// 复用现有的样品卡片和列表结构，数据来源为 loadInquiriesProducts
class InquiryProductsTab extends HookConsumerWidget {
  const InquiryProductsTab({super.key, required this.inquiry}); 
  final SingleStationInquiries? inquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singleStationProvider);
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

    return MuListView<SingleStationSample>(
      state: state,
      hPadding: 16,
      list: state.inquiriesProductList,
      onRefresh: () async {
        await stationNotifier.loadInquiriesMessages();
      },
      onLoadMore: () async {
        await stationNotifier.loadInquiriesMessages(refresh: false);
      },
      refreshOnStart: false,
      itemBuilder: (context, item) => StationProductCard(
        item: item,
      ),
    );
  }
}
