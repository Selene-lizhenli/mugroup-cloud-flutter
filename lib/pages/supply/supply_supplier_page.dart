import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/list/widgets/home_app_bar.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/supply/widgets/supplier_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SupplySupplierPage extends HookConsumerWidget {
  const SupplySupplierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final currentPageIndex = useState<int>(0);

    return Scaffold(
        appBar: AppBar(
          title: const Text('供应商列表'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 8,
            ),
            HomeAppBar(
              controller: home.searchTextController,
              onSearchText: (search) {
                homeNotifier.setSearch(search);
                home.bus.dispatch(
                    SearchEvent(search: search, media: home.currentMedia));
              },
              onSearchMedia: (temporaryMedia) {
                homeNotifier.addMedia(temporaryMedia);
                if (temporaryMedia.id == home.currentMediaId) {
                  return;
                }
                home.bus.dispatch(
                    SearchEvent(search: home.search, media: temporaryMedia));
              },
              onDeleteMedia: (temporaryMedia) {
                final nextState = homeNotifier.deleteMedia(temporaryMedia);
                if (nextState.currentMediaId == home.currentMediaId) {
                  return;
                }

                home.bus.dispatch(SearchEvent(
                  media: nextState.currentMedia,
                  search: nextState.search,
                ));
              },
            ),
            Expanded(
              child: PageView(
                controller: home.pageController,
                onPageChanged: (page) {
                  homeNotifier.setCurrentPage(page);
                  currentPageIndex.value = page;
                  home.bus.dispatch(
                    SearchEvent(
                      media: home.currentMedia,
                      search: home.search,
                      from: SearchEventFrom.tab,
                    ),
                  );
                },
                allowImplicitScrolling: false,
                children: const [SupplierView()],
              ),
            ),
          ],
        ));
  }
}
