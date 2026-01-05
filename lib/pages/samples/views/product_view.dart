import 'package:cloud/helper/helper.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/hooks/useUpdateEffect/hook.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/widgets/product_card.dart';
import 'package:cloud/pages/samples/widgets/product_card_detailed.dart';
import 'package:cloud/pages/samples/widgets/product_dropdown_menu.dart';
import 'package:cloud/services/sample.dart';
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
         final currentHome = ref.read(homeProvider);
    final isDetailedMode = home.isDetailedMode;
    final search = useState(home.search);
    // 初始化 query，如果有选中的样品间，将其添加到 query 中
    final initialQuery = <String, dynamic>{};
    if (home.currentSelectedWarehouse != null && 
        home.currentSelectedWarehouse!.id != 0) {
      initialQuery['warehouse_id'] = home.currentSelectedWarehouse!.id.toString();
    }
    final query = useState<Map<String, dynamic>>(initialQuery);
    final previousMode = useRef(isDetailedMode);
    final media = useState<TemporaryMedia?>(home.currentMedia);
    final page = useRef(1);
    final samples = useState<List<Sample>>(<Sample>[]);
    final facetCounts = useState(<FacetCount>[]);
    final showDropDown = useState(isDetailedMode);
    final colorScheme = Theme.of(context).colorScheme;
 
    final mediaQuery = MediaQuery.of(context);

    var crossAxisCount = 2;

    if (mediaQuery.size.width > 500) {
      crossAxisCount = 3;
    }

    if (mediaQuery.size.width > 800) {
      crossAxisCount = 4;
    }

    fetchData(
      String? searchText, {
      bool? init = false,
      TemporaryMedia? searchMedia,
      Map<String, dynamic>? overrideQuery,
    }) async {
      search.value = searchText;
      media.value = searchMedia;
      if (init == true) {
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        if (searchMedia != null) "image": searchMedia.id,
        "item_type": "all",
        "page": page.value,
        "pageSize": pageSize,
        "includes": 'supplyQuotes.supplier',
        ...(overrideQuery ?? query.value),
      }; 
      final resp = await getSamples(queryParameters: queryParameters);

      // 如果提供了 overrideQuery，在更新 samples 之前先更新 query.value
      // 这样 query 和 samples 的更新会在同一个同步代码块中，可能被批处理合并
      if (overrideQuery != null) {
        query.value = overrideQuery;
      }

      // 根据是否是精简模式来更新 showDropDown
      showDropDown.value = home.isDetailedMode; 
      if (init == true || page.value == 1) {
        samples.value = resp.data;
      } else {
        samples.value = [...samples.value, ...resp.data];
      }
      
      // 只在首次加载（page == 1 且 facetCounts 为空）时设置 facetCounts
      // 这样筛选条件选择后，筛选项按钮不会消失
      if (page.value == 1 && facetCounts.value.isEmpty) {
        facetCounts.value = resp.meta?.facetCounts ?? [];
      }
   
      if (resp.data.length >= 20) {
        page.value++;
      }

      return resp;
    }
 
    // 监听视图模式变化，切换到精简模式时重置筛选项并刷新
    useUpdateEffect(() {
      final wasDetailed = previousMode.value;
      previousMode.value = isDetailedMode;
         final resetQuery = <String, dynamic>{};  
      // 如果从详细模式切换到精简模式，重置筛选项（保留 warehouse_id）
      if (wasDetailed == true && !isDetailedMode) {
        if (currentHome.currentSelectedWarehouse != null && 
            currentHome.currentSelectedWarehouse!.id != 0) {
          resetQuery['warehouse_id'] = currentHome.currentSelectedWarehouse!.id.toString();
        }
      }     // 使用 Future.microtask 来延迟执行
        Future.microtask(() async {
          try {
            // 使用 overrideQuery 参数，fetchData 内部会更新 query.value
            await fetchData(
              search.value,
              searchMedia: media.value,
              init: true,
              overrideQuery: resetQuery,
            );
            refreshController.finishRefresh();
          } catch (e) {
            refreshController.finishRefresh(IndicatorResult.fail, false);
          } finally {
            refreshController.resetFooter();
          }
        });
      return null;
    }, [isDetailedMode]);

    useEffect(() {
      final searchEventSubscription = home.bus.on<SearchEvent>().listen(
        (SearchEvent event) {
          final currentHome = ref.read(homeProvider);
          if (currentHome.currentPage != 0) {
            return;
          }

          if (event.from == SearchEventFrom.tab) {
            if (search.value == event.search &&
                media.value?.id == event.media?.id) {
              return;
            }
          }

          search.value = event.search;
          media.value = event.media;

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
          borderRadius: home.currentMediaId != null
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
              await fetchData(
                search.value,
                searchMedia: media.value,
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
            final resp =
                await fetchData(search.value, searchMedia: media.value);

            refreshController.finishLoad(resp.data.length >= pageSize
                ? IndicatorResult.success
                : IndicatorResult.noMore);
          },
          child: CustomScrollView(
            slivers: [
              MultiSliver(
                children: [
                  // 解决 Header 下拉刷新时不会跟着移动的
                  Container(
                    height: 0,
                  ),
                  if (facetCounts.value.isNotEmpty && showDropDown.value)
                    SliverPinnedHeader(
                      child: ProductDropdownMenu(
                        facetCounts: facetCounts.value,
                        value: query.value,
                        onChange: (menuQuery) {
                          query.value = menuQuery;
                          refreshController.callRefresh(force: true);
                        },
                      ),
                    ),
                  if (samples.value.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          '暂无数据',
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
                      itemCount: samples.value.length,
                      padding: const EdgeInsets.all(5),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final sample = samples.value[index];
                        final cartItem = cartState.items.firstWhereOrNull(
                            (element) => element.sample.id == sample.id);

                        if (isDetailedMode) {
                          return ProductCardDetailed(
                            key: ValueKey(sample.id),
                            sample: sample,
                            cartCount: cartItem?.count,
                            onTapAddSample: () {
                              cart.addSample(sample, 1);
                            },
                          );
                        } else {
                          return ProductCard(
                            key: ValueKey(sample.id),
                            sample: sample,
                            cartCount: cartItem?.count,
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
