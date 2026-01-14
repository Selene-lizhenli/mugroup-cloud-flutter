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
          title: Text(currentWarehouse?.name ?? '样品间'),
          backgroundColor: colorScheme.surfaceTint,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 25,
                  // color: colorScheme.secondary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.router.push(const CartRoute());
                },
              ),
            ),
            if(currentPageIndex.value == 1)
            ...[PopupMenuButton<String>(
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
            )],
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if( currentPageIndex.value == 1 ){
                 //清空搜索内容
                 home.searchTextController.clear();
                 homeNotifier.setSearch('');
                 home.bus.dispatch(
                   SearchEvent(search: '', media: null),
                 ); 
                 homeNotifier.switchToPage(0);
              } else {
                context.router.maybePop();
              }
            
            },
          ),
        ) ,
        body: Container(
          // color: colorScheme.secondary,
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeAppBar(
                controller: home.searchTextController,
                onSearchText: (search) {
                  final text = search.trim();
                  // 文本为空时，使用样品间列表页（SamplesPageView）
                  if (text.isEmpty) {
                    homeNotifier.switchToPage(0);
                  } else {
                    // 有搜索内容时，切换到商品列表页（ProductView）
                    homeNotifier.switchToProductView();
                  }
                  homeNotifier.setSearch(search);
                  home.bus.dispatch(
                    SearchEvent(search: search, media: home.currentMedia),
                  );
                },
                onSearchMedia: (temporaryMedia) {
                  homeNotifier.addMedia(temporaryMedia);
                  if (temporaryMedia.id == home.currentMediaId) {
                    return;
                  }
                  // 图片搜索后切换到商品列表页（ProductView）
                  homeNotifier.switchToProductView();
                  home.bus.dispatch(
                    SearchEvent(search: home.search, media: temporaryMedia),
                  );
                },
                onDeleteMedia: (temporaryMedia) {
                  final nextState = homeNotifier.deleteMedia(temporaryMedia);
                  if (nextState.currentMediaId == home.currentMediaId) {
                    return;
                  }

                  home.bus.dispatch(
                    SearchEvent(
                      media: nextState.currentMedia,
                      search: nextState.search,
                    ),
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: home.pageController,
                  onPageChanged: (page) {
                    homeNotifier.switchToPage(page);
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
                  children: const [SamplesPageView(), ProductView()],
                ),
              ),
            ],
          ),
        ));
  }
}
