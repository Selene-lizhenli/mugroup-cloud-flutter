import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/views/product_view.dart';
import 'package:cloud/pages/home/views/supply_view.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    final currentPageIndex = useState<int>(0);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeAppBar(
            controller: home.searchTextController,
            onSearchText: (search) {
              homeNotifier.setSearch(search);

              home.bus.dispatch(SearchEvent(search: search));
            },
            onSearchMedia: (temporaryMedia) {
              homeNotifier.addMedia(temporaryMedia);

              if (temporaryMedia.id == home.currentMediaId) {
                return;
              }

              home.bus.dispatch(SearchEvent(media: temporaryMedia));
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
              },
              allowImplicitScrolling: false,
              children: const [ProductView(), SupplyView()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (currentPageIndex.value == 0) {
            final shouldRefresh =
                await context.router.push(const ShowroomSampleCreateRoute());
          }
          if (currentPageIndex.value == 1) {
            final shouldRefresh =
                await context.router.push(const SupplySupplierCreateRoute());
          }
        },
        tooltip: '创建',
        child: const Icon(Icons.add),
      ),
    );
  }
}
