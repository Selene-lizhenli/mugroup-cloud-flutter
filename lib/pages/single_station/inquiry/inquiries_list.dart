import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/inquiry/inquiriy_item_card.dart';
import 'package:cloud/pages/single_station/inquiry/detail/inquiry_detail_container.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 独立站列表
class InquiriesList extends HookConsumerWidget {
  const InquiriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singleStationProvider);
    final stationNotifier = ref.read(singleStationProvider.notifier);

    void onTap(SingleStationInquiries? item) {
      if (item == null) return;
      stationNotifier.setInquiryId(item.id);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InquiryDetailContainer(item: item),
        ),
      );
    }

    return MuListView<SingleStationInquiries>(
      state: state,
      hPadding: 16,
      list: state.inquiriesMessageList,
      onRefresh: () async {
        await stationNotifier.loadInquiriesMessages();
      },
      onLoadMore: () async {
        await stationNotifier.loadInquiriesMessages(refresh: false);
      },
      refreshOnStart: false,
      itemBuilder: (context, item) => InquiriesItemCard(
        item: item,
        onTap: () => onTap(item),
      ),
    );
  }
}
