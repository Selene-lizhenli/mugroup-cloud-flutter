import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/widgets/product_card.dart';
import 'package:cloud/pages/samples/widgets/product_card_detailed.dart';
import 'package:cloud/pages/samples/widgets/product_dropdown_menu.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:collection/collection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

const pageSize = 20;

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final cart = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);

    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    final home = ref.watch(homeProvider);
    final productListLoading = home.productListLoading;
    final homeNotifier = ref.read(homeProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    var crossAxisCount = 2;

    if (mediaQuery.size.width > 500) {
      crossAxisCount = 3;
    }

    if (mediaQuery.size.width > 800) {
      crossAxisCount = 4;
    }

    // 监听当前选中仓库变化、视图变化、搜索内容变化，如果改变了，就调用 fetchData
    useUpdateEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await homeNotifier.fetchSamples(
            searchText: home.search,
            searchMedia: home.currentMedia,
            init: true,
          );
          refreshController.finishRefresh();
        } catch (e) {
          refreshController.finishRefresh(IndicatorResult.fail, false);
        } finally {
          refreshController.resetFooter();
        }
      });
      return null;
    }, [home.currentSelectedWarehouse, home.isDetailedMode, home.query]);

    useEffect(() {
      final searchEventSubscription = home.bus.on<SearchEvent>().listen(
        (SearchEvent event) {
          final currentHome = ref.read(homeProvider);
          // 只有在当前处于商品列表页（PageView 第 2 页，索引为 1）时才响应搜索事件
          if (currentHome.currentPage != 1) {
            return;
          }

          if (event.from == SearchEventFrom.tab) {
            if (home.search == event.search &&
                home.currentMedia?.id == event.media?.id) {
              return;
            }
          }

          homeNotifier.setSearch(event.search ?? '');
          if (event.media != null) {
            homeNotifier.addMedia(event.media!);
          }

          refreshController.callRefresh(force: true);
        },
      );

      return () {
        searchEventSubscription.cancel();
      };
    }, []);

    return Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint,
          borderRadius: home.currentMedia != null
              ? null
              : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
        ),
        clipBehavior: Clip.hardEdge,
        child: EasyRefresh(
          controller: refreshController,
          refreshOnStart: true,
          onRefresh: () async {
            try {
              await homeNotifier.fetchSamples(
                searchText: home.search,
                searchMedia: home.currentMedia,
                init: true,
              );
              refreshController.finishRefresh();
            } catch (e) {
              refreshController.finishRefresh(IndicatorResult.fail, false);
            } finally {
              refreshController.resetFooter();
            }
          },
          onLoad: () async { 
            try {
              final resp = await homeNotifier.fetchSamples(
                searchText: home.search,
                searchMedia: home.currentMedia,
                init: false,
              );
              refreshController.finishLoad(resp.data.length >= pageSize
                  ? IndicatorResult.success
                  : IndicatorResult.noMore);
            } catch (e) {
              refreshController.finishLoad(IndicatorResult.fail, false);
            }
          },
          child: CustomScrollView(
            slivers: [
              MultiSliver(
                children: [
                  // 解决 Header 下拉刷新时不会跟着移动的
                  Container(
                    height: 0,
                  ),
                  if (home.facetCounts.isNotEmpty)
                    SliverPinnedHeader(
                      child: ProductDropdownMenu(
                        facetCounts: home.facetCounts,
                      ),
                    ),
                  if (productListLoading == true)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: MuProgressIndicator(showText: true),
                      ),
                    )
                  else if (home.samples.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          context.l10n.noData,
                          style: TextStyle(
                            color: colorScheme.surfaceContainerHighest,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemCount: home.samples.length,
                      padding: const EdgeInsets.all(5),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final sample = home.samples[index];

                        void navToDetail() {
                          final allIds =
                              home.samples.map((e) => e.id as int).toList();

                          context.router.push(ShowroomSampleViewerRoute(
                              initialIds: allIds,
                              initialIndex: index,
                              xTenantId: sample.xTenantId,
                              onLoadMore: (page) async {
                                final resp = await homeNotifier.fetchSamples(
                                  searchText: home.search,
                                  searchMedia: home.currentMedia,
                                  init: false,
                                );
                                return resp.data
                                    .map((e) => e.id as int)
                                    .toList();
                              }));
                        }

                        final cartItem = cartState.items.firstWhereOrNull(
                            (element) => element.sample.id == sample.id);

                        if (home.isDetailedMode) {
                          return ProductCardDetailed(
                            key: ValueKey(sample.id),
                            sample: sample,
                            cartCount: cartItem?.count,
                            onTap: navToDetail,
                            onTapAddSample: () {
                              cart.addSample(sample, 1);
                            },
                          );
                        } else {
                          return ProductCard(
                            key: ValueKey(sample.id),
                            sample: sample,
                            cartCount: cartItem?.count,
                            onTap: navToDetail,
                            onTapAddSample: () {
                              cart.addSample(sample, 1);
                            },
                          );
                        }
                      },
                    ),
                ],
              )
            ],
          ),
        ));
  }
}
