import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/views/product_view.dart';
import 'package:cloud/pages/samples/widgets/home_app_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SamplesListPage extends HookConsumerWidget {
  const SamplesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final currentPageIndex = useState<int>(0);
    final colorScheme = Theme.of(context).colorScheme;
    // 使用 provider 中的 currentSelectedWarehouse
    final currentWarehouse = home.currentSelectedWarehouse;

    return Scaffold(
        backgroundColor: colorScheme.surfaceTint,
        appBar: AppBar(
          title: Text(currentWarehouse?.name ?? '样品间'),
          backgroundColor: colorScheme.surfaceTint,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                context.router.push(ShowroomSampleCreateRoute());
              },
              child: Text(
                "新增",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              offset: const Offset(-8, 38),
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onSelected: (String value) {
                if (value == 'detailed') {
                  homeNotifier.setViewMode(true);
                } else if (value == 'simple') {
                  homeNotifier.setViewMode(false);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: home.isDetailedMode ? 'simple' : 'detailed',
                    child: Text(home.isDetailedMode ? '精简模式' : '详细模式'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          // color: colorScheme.secondary,
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  children: const [ProductView()],
                ),
              ),
            ],
          ),
        ));
  }
}
