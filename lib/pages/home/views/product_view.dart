import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/build_quick_action.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/pages/home/widgets/product_dropdown_menu.dart';
import 'package:cloud/router/router.gr.dart';
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
    final search = useState(home.search);
    final query = useState<Map<String, dynamic>>({});
    final media = useState<TemporaryMedia?>(home.currentMedia);
    final page = useRef(1);
    final samples = useState<List<Sample>>(<Sample>[]);
    final facetCounts = useState(<FacetCount>[]);
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
    }) async {
      search.value = searchText;
      media.value = searchMedia;
      if (init == true) {
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        if (searchMedia != null) "image": searchMedia.id,
        "page": page.value,
        "pageSize": pageSize,
        "includes": 'supplyQuotes.supplier',
        ...query.value,
      };
      final resp = await getSamples(queryParameters: queryParameters);

      if (init == true || page.value == 1) {
        samples.value = resp.data;
      } else {
        samples.value = [...samples.value, ...resp.data];
      }
      if (page.value == 1 && query.value.isEmpty) {
        facetCounts.value = resp.meta?.facetCounts ?? [];
      }

      if (resp.data.length >= 20) {
        page.value++;
      }

      return resp;
    }

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
            await fetchData(
              search.value,
              searchMedia: media.value,
              init: true,
            );
            refreshController.finishRefresh();
            refreshController.resetFooter();
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
              if (search.value == null && media.value == null)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      // Card(
                      //   color: colorScheme.surface,
                      //   elevation: 0, // 去除阴影
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(8)),
                      //     side: BorderSide.none, // 移除边框线
                      //   ),
                      //   child: const Padding(
                      //     padding: EdgeInsets.all(12),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //             child: BuildQuickAction(
                      //                 icon: Icons.person,
                      //                 title: "客户",
                      //                 color: Colors.orange,
                      //                 route: CrmCompanyRoute())),
                      //         // Expanded(
                      //         //     child: BuildQuickAction(
                      //         //         icon: Icons.group,
                      //         //         title: "供应商管理",
                      //         //         color: Colors.red,
                      //         //         route: SupplySupplierRoute())),
                      //         Expanded(
                      //             child: BuildQuickAction(
                      //                 icon: Icons.receipt_long,
                      //                 title: "报价单", // 报价单列表页面
                      //                 color: Colors.green,
                      //                 route: QuoteRoute())),
                      //         Expanded(
                      //             child: BuildQuickAction(
                      //                 icon: Icons.inventory_2,
                      //                 title: "验货", //todo 新页面
                      //                 color: Colors.blue,
                      //                 route: QuoteRoute())),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Card(
                        color: colorScheme.primary,
                        elevation: 2, // 去除阴影
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          side: BorderSide.none, // 移除边框线
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                  height: 73, // 高度限制
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 8, 10, 8), // 所有方向的边距都是6
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    // topRight: Radius.circular(8),
                                  )),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("快",
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.2, // 行高倍数，默认大约 1.4
                                            color: colorScheme.onPrimary,
                                          )),
                                      Text("捷",
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.2,
                                            color: colorScheme.onPrimary,
                                          )),
                                      Text("入",
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.2,
                                            color: colorScheme.onPrimary,
                                          )),
                                      Text("口",
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.2,
                                            color: colorScheme.onPrimary,
                                          )),
                                    ],
                                  )),
                              Expanded(
                                child: Container(
                                  height: 72, // 高度限制
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 8, 10, 8), // 所有方向的边距都是6
                                  decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      )),
                                  margin: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly, // 平均分配空间
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch, // 关键：让子元素高度填满
                                    children: [
                                      BuildQuickAction(
                                        icon: Icons.add,
                                        title: "新增产品",
                                        color: colorScheme.secondary,
                                        needItemType: true,
                                        route: (itemType) =>
                                            ShowroomSampleCreateRoute(
                                                itemType: itemType),
                                      ),
                                      BuildQuickAction(
                                        icon: Icons.add,
                                        title: "新增供应商",
                                        color: colorScheme.error,
                                        route: (itemType) =>
                                            const SupplySupplierCreateRoute(),
                                      ),
                                      BuildQuickAction(
                                        icon: Icons.add,
                                        title: "新增客户",
                                        color: Colors.orange,
                                        route: (itemType) =>
                                            const CrmCompanyCreateRoute(),
                                      ),
                                      BuildQuickAction(
                                        icon: Icons.add,
                                        title: "新增报价单", // 报价单列表页面
                                        color: Colors.green,
                                        route: (itemType) =>
                                            const QuoteCreateRoute(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              MultiSliver(
                children: [
                  // 解决 Header 下拉刷新时不会跟着移动的
                  Container(
                    height: 0,
                  ),
                  if (facetCounts.value.isNotEmpty)
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

                        return ProductCard(
                          sample: sample,
                          cartCount: cartItem?.count,
                          onTapAddSample: () {
                            cart.addSample(sample, 1);
                          },
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ));
  }
}
