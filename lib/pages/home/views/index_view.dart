import 'package:cloud/helper/helper.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/pages/home/widgets/build_quick_action.dart';
import 'package:cloud/services/sample.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/models/response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:cloud/pages/home/widgets/product_dropdown_menu.dart';
import 'package:collection/collection.dart';

const pageSize = 20;

class HomeProductPage extends HookConsumerWidget {
  // final ValueNotifier<List<FacetCount>> facetCounts;
  final ValueNotifier<dynamic> query;
  final Future<void> Function()? onSearch;
  final Future<ApiResponse<List<Sample>>> Function(String?,
      {bool init, num? pageValue, TemporaryMedia? searchMedia}) fetchData;
  final EasyRefreshController refreshController;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onProductLoad;
  final bool isSearchMode;

  const HomeProductPage({
    super.key,
    // required this.facetCounts,
    required this.query,
    required this.onSearch,
    required this.fetchData,
    required this.refreshController,
    required this.onRefresh,
    required this.onProductLoad,
    required this.isSearchMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final colorScheme = Theme.of(context).colorScheme;
    final home = ref.watch(homeProvider);
    final cart = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);

    final productTabIndex = useState<int>(0); // 0=集团样品，1=市场产品，2=日本产品

    final facetCounts = home.facetCounts;
    final samples = home.samples;

    final mediaQuery = MediaQuery.of(context);
    var crossAxisCount = 2;
    if (mediaQuery.size.width > 500) {
      crossAxisCount = 3;
    }
    if (mediaQuery.size.width > 800) {
      crossAxisCount = 4;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
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
        onRefresh: onRefresh,
        onLoad: onProductLoad,
        child: CustomScrollView(
          slivers: [
            // 顶部两个 Card（只有未搜索时显示）
            if (!isSearchMode)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    // Card(
                    //   color: colorScheme.surface,
                    //   elevation: 0, // 去除阴影
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.all(Radius.circular(8)),
                    //     side: BorderSide.none, // 移除边框线
                    //   ),
                    //   child: const Padding(
                    //     padding: EdgeInsets.all(12),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //             child: BuildQuickAction(
                    //                 icon: Icons.person,
                    //                 title: "客户管理",
                    //                 color: Colors.orange,
                    //                 route: CrmCompanyRoute())),
                    //         Expanded(
                    //             child: BuildQuickAction(
                    //                 icon: Icons.group,
                    //                 title: "供应商管理",
                    //                 color: Colors.red,
                    //                 route: SupplySupplierRoute())),
                    //         // Expanded(
                    //         //     child: BuildQuickAction(
                    //         //         icon: Icons.inventory_2,
                    //         //         title: "市场产品管理", //todo 新页面
                    //         //         color: Colors.blue,
                    //         //         route: MarketRoute())),
                    //         Expanded(
                    //             child: BuildQuickAction(
                    //                 icon: Icons.receipt_long,
                    //                 title: "报价单管理", // 报价单列表页面
                    //                 color: Colors.green,
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
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("快",
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.2, // 行高倍数，默认大约 1.4
                                          color: Color(
                                              0xFFFFFFFF), // 使用 Flutter 预设的蓝色
                                        )),
                                    Text("捷",
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.2,
                                          color: Color(
                                              0xFFFFFFFF), // 使用 Flutter 预设的蓝色
                                        )),
                                    Text("入",
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.2,
                                          color: Color(
                                              0xFFFFFFFF), // 使用 Flutter 预设的蓝色
                                        )),
                                    Text("口",
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.2,
                                          color: Color(
                                              0xFFFFFFFF), // 使用 Flutter 预设的蓝色
                                        )),
                                  ],
                                )),
                            Expanded(
                                child: Container(
                                    height: 72, // 高度限制
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 8, 10, 8), // 所有方向的边距都是6
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                          // topRight: Radius.circular(8),
                                        )),
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 1, 0),
                                    child: const Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly, // 平均分配空间
                                        crossAxisAlignment: CrossAxisAlignment
                                            .stretch, // 关键：让子元素高度填满
                                        children: [
                                          BuildQuickAction(
                                              icon: Icons.add,
                                              title: "新增客户",
                                              color: Colors.orange,
                                              route: CrmCompanyCreateRoute()),
                                          BuildQuickAction(
                                              icon: Icons.add,
                                              title: "新增供应商",
                                              color: Colors.red,
                                              route:
                                                  SupplySupplierCreateRoute()),
                                          BuildQuickAction(
                                              icon: Icons.add,
                                              title: "新增市场产品",
                                              color: Colors.blue,
                                              route:
                                                  ShowroomSampleCreateRoute()),
                                          BuildQuickAction(
                                              icon: Icons.add,
                                              title: "新增报价单",
                                              color: Colors.green,
                                              route: QuoteCreateRoute()),
                                        ])))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (facetCounts.isNotEmpty)
              SliverPinnedHeader(
                child: ProductDropdownMenu(
                  facetCounts: facetCounts,
                  value: query.value,
                  onChange: (menuQuery) {
                    query.value = menuQuery;
                    refreshController.callRefresh(force: true);
                  },
                ),
              ),
            // feeds流
            SliverPadding(
              padding: const EdgeInsets.all(5),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childCount: samples.length,
                itemBuilder: (context, index) {
                  final sample = samples[index];
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
            ),
          ],
        ),
      ),
    );
  }
}
