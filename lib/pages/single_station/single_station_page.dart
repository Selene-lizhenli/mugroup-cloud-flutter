import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart'; 
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/single_station/provider/provider.dart';
import 'package:cloud/pages/single_station/station/single_station_list.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:cloud/pages/widgets/theme_icon.dart';
import 'package:cloud/router/router.gr.dart'; 
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SingleStationPage extends HookConsumerWidget {
  const SingleStationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final l10n = context.l10n;
    final searchController = useTextEditingController();
    final stationNotifier = ref.read(singleStationProvider.notifier);
    final state = ref.watch(singleStationProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度

    final refreshController = useMemoized(
      () => EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      ),
    );
    useEffect(() {
      return () =>
          {refreshController.dispose(), stationNotifier.cleanSearchKeyWord};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stationNotifier.load();
        stationNotifier.loadInquiriesMessages();
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            stationNotifier.cleanStationInquiriesMessages();
          });
    }, const []);

    final inquiriesMessageList = state.inquiriesMessageList;
    final inquiriesMessageListLength = state.inquiriesMessageList.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.featureIndependentWebsite),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                MuThemeIcon(
                  iconType: 'message',
                  iconSize: 20,
                  tooltip: l10n.stationInquiryMessages,
                  onPressed: () {
                    context.router.push(const InquiryMessageRoute());
                  },
                ),
                if (inquiriesMessageList.isNotEmpty)
                  Positioned(
                    left: 2,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        inquiriesMessageListLength > 99
                            ? '99+'
                            : '$inquiriesMessageListLength',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 8,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    Color.lerp(
                      colorScheme.surfaceTint,
                      colorScheme.surface,
                      0.9,
                    )!,
                    colorScheme.surfaceTint,
                  ],
                  stops: const [0.0, 0.2, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: 8,
            child: Image.asset(
              'assets/photo/single_website.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.topRight,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingTop + appbarHeight, left: 0, right: 0),
            child: Column(
              children: [
                // Text(l10n.featureIndependentWebsite, style: TextStyle(fontSize: 20,),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: MuSearchBar(
                    controller: searchController,
                    hintText: "根据独立站名称搜索",
                    buttonText: "搜索",
                    onSearch: (search) {
                      final keyword = search ?? searchController.text;
                      stationNotifier.setStationSearchKeyword(keyword);
                      stationNotifier.load(params: {'name_cn': keyword});
                    },
                  ),
                ),
                const SizedBox(height: 9),
                const Expanded(
                  child: SingleStationList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
