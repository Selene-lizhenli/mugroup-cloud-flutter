import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/single_station/inquiry/inquiries_list.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/single_station_list.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/pages/widgets/icon.dart';
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

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stationNotifier.loadInquiriesMessages();
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            stationNotifier.cleanStationInquiriesMessages();
            stationNotifier.cleanSearchKeyWord;
          });
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('询盘'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: MuSearchBar(
              controller: searchController,
              hintText: '请输入关键字进行搜索',
              buttonText: '搜索',
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
