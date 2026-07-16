import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/single_station/inquiry/inquiries_list.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InquiryMessagePage extends HookConsumerWidget {
  const InquiryMessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final l10n = context.l10n;
    final searchController = useTextEditingController();
    final stationNotifier = ref.read(singleStationProvider.notifier);
    final refreshController = useMemoized(
      () => EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      ),
    );
    useEffect(() {
      return () => refreshController.dispose();
    }, const []);

    // useEffect(() {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     stationNotifier.loadInquiriesMessages();
    //   });
    //   return () => WidgetsBinding.instance.addPostFrameCallback((_) {
    //         stationNotifier.cleanStationInquiriesMessages();
    //         stationNotifier.cleanSearchKeyWord;
    //       });
    // }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inquiryTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: MuSearchBar(
              controller: searchController,
              hintText: l10n.inquirySearchHint,
              buttonText: l10n.search,
              onSearch: (search) {
                final keyword = search ?? searchController.text;
                stationNotifier.setStationSearchKeyword(keyword);
                stationNotifier
                    .loadInquiriesMessages(params: {'name_cn': keyword});
              },
            ),
          ),
          const Expanded(
            child: InquiriesList(),
          ),
        ],
      ),
    );
  }
}
