import 'package:auto_route/auto_route.dart'; 
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/views/product_view.dart';
import 'package:cloud/pages/samples/views/showroom_view.dart';
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
    // 本地保存当前 PageView 索引，初始值来自全局状态
    final currentPageIndex = useState<int>(home.currentPage);
    final colorScheme = Theme.of(context).colorScheme;
    final currentWarehouse = home.currentSelectedWarehouse;

    return Scaffold(
        backgroundColor: colorScheme.surfaceTint,
        appBar: AppBar(
          title: Text(currentPageIndex.value == 1
              ? currentWarehouse?.name ?? '样品间'
              : '样品间'),
          backgroundColor: colorScheme.surfaceTint,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 25,
                  color: colorScheme.primary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.router.push(const CartRoute());
                },
              ),
            ),
            if (currentPageIndex.value == 1) ...[
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
              )
            ],
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (currentPageIndex.value == 1) {
                //清空搜索内容
                home.searchTextController.clear();
                homeNotifier.setSearch('');
                homeNotifier.clearMedia(); //清空图片媒体内容
                home.bus.dispatch(
                  SearchEvent(search: '', media: null),
                );
                homeNotifier.switchToPage(0);
                homeNotifier.setCurrentSelectedWarehouse(null);
              } else {
                context.router.maybePop();
              }
            },
          ),
        ),
        body: Container(
          // color: colorScheme.secondary,
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeAppBar(
                controller: home.searchTextController,
                onSearchText: (search) {
                  final text = search.trim();
                  // 文本为空时，使用样品间列表页（SamplesPageView）
                  if (text.isNotEmpty && home.currentPage == 0) {
                    homeNotifier.switchToProductView();
                  }
                  homeNotifier.setSearch(search);
                  homeNotifier.fetchSamples(
                    searchText: search,
                    searchMedia: home.currentMedia,
                    init: true,
                  );
                },
                onSearchMedia: (temporaryMedia) {
                  homeNotifier.switchToProductView();
                  homeNotifier.addMedia(temporaryMedia);
                  if (temporaryMedia.id == home.currentMediaId) {
                    return;
                  }
                  // 图片搜索后切换到商品列表页（ProductView）
                  homeNotifier.fetchSamples(
                    searchText: home.search,
                    searchMedia: temporaryMedia,
                    init: true,
                  );
                },
                onDeleteMedia: (temporaryMedia) {
                  final nextState = homeNotifier.deleteMedia(temporaryMedia);
                  if (nextState.currentMediaId == home.currentMediaId) {
                    return;
                  }
                  homeNotifier.fetchSamples(
                    searchText: nextState.search,
                    searchMedia: nextState.currentMediaId == null
                        ? null
                        : nextState.currentMedia,
                    init: true,
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: home.pageController,
                  onPageChanged: (page) {
                    homeNotifier.switchToPage(page);
                    currentPageIndex.value = page;
                    if (page == 0) {
                      homeNotifier.setCurrentSelectedWarehouse(null);
                    }
                  },
                  allowImplicitScrolling: false,
                  children: const [SamplesPageView(), ProductView()],
                ),
              ),
            ],
          ),
        ));
  }
}
