import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/views/product_view.dart';
import 'package:cloud/pages/home/views/supply_view.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeAppBar(
            controller: home.searchTextController,
            onSearchText: (search) {
              homeNotifier.setSearch(search);

              home.bus.dispatch(SearchEvent(search));
            },
            onSearchMedia: (temporaryMedia) {
              homeNotifier.addMedia(temporaryMedia);
            },
          ),
          Expanded(
            child: PageView(
              controller: home.pageController,
              onPageChanged: (page) {
                homeNotifier.setCurrentPage(page);
              },
              allowImplicitScrolling: false,
              children: const [ProductView(), SupplyView()],
            ),
          ),
        ],
      ),
    );
  }
}
