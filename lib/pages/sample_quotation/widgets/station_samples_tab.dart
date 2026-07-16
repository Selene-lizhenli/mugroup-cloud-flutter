import 'package:cloud/pages/sample_quotation/providers/provider.dart';
import 'package:cloud/pages/single_station/station/station_product_card.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StationSamplesTab extends HookConsumerWidget {
  const StationSamplesTab({
    super.key,
    required this.quotationId,
  });

  final int? quotationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(sampleQuotationProvider.notifier);
    final state = ref.watch(sampleQuotationProvider);

    return MuListView(
      state: state,
      list: state.productsList,
      onRefresh: () async {
        if (quotationId == null) return;
        await notifier.loadDetail(params: {"id": quotationId});
      },
      onLoadMore: () async {
        if (quotationId == null) return;
        await notifier.loadDetail(
          params: {"id": quotationId},
          refresh: false,
        );
      },
      refreshOnStart: false,
      itemBuilder: (context, item) => StationProductCard(
        item: item,
      ),
      hPadding: 16,
    );
  }
}
