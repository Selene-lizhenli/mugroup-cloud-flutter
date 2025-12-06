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
import 'package:collection/collection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:cloud/router/router.gr.dart';

const pageSize = 20;

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final cart = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);
    final search = useState(home.search);
    final media = useState<TemporaryMedia?>(home.currentMedia);
    final page = useRef(1);
    final samples = useState<List<Sample>>(<Sample>[]);
    final bool isSearchMode =
        (search.value?.isNotEmpty ?? false) || home.currentMediaId != null;
    final colorScheme = Theme.of(context).colorScheme;

    final refreshController = useEasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);

    // 数据请求方法
    fetchData(String? searchText,
        {bool? init = false, TemporaryMedia? searchMedia}) async {
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
      };
      final resp = await getSamples(queryParameters: queryParameters);

      if (init == true) {
        samples.value = resp.data;
      } else {
        samples.value = [...samples.value, ...resp.data];
      }

      if (resp.data.length >= pageSize) {
        page.value++;
      }

      return resp;
    }

    // 监听搜索事件并直接调用 fetchData
    useEffect(() {
      final sub = home.bus.on<SearchEvent>().listen((event) async {
        search.value = event.search;
        media.value = event.media;
        // logger.d(media);
        logger.d(search);
        logger.i(event);

        // 触发数据刷新
        await fetchData(search.value, searchMedia: media.value, init: true);

        // 重置刷新状态
        refreshController.finishRefresh();
        refreshController.resetFooter();
      });
      return () => sub.cancel();
    }, []);

    return Scaffold(
      body: Container(
          color: colorScheme.secondary,
          child: Column(
            children: [
              // 固定顶部 HomeAppBar
              HomeAppBar(
                controller: home.searchTextController,
                onSearchText: (searchValue) {
                  homeNotifier.setSearch(searchValue);
                  home.bus.dispatch(SearchEvent(search: searchValue));
                },
                onSearchMedia: (temporaryMedia) {
                  homeNotifier.addMedia(temporaryMedia);
                  if (temporaryMedia.id == home.currentMediaId) return;
                  logger.d(temporaryMedia);
                  home.bus.dispatch(
                      SearchEvent(media: temporaryMedia, search: search.value));
                },
                onDeleteMedia: (temporaryMedia) {
                  final nextState = homeNotifier.deleteMedia(temporaryMedia);
                  home.bus.dispatch(SearchEvent(
                    media: nextState.currentMedia,
                    search: nextState.search,
                  ));
                },
              ),

              // 可滚动内容
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 0), // 所有方向的边距都是6
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 231, 232), // 背景色必须设置
                    borderRadius: home.currentMediaId != null
                        ? null // 搜索模式：取消圆角
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
                      await fetchData(search.value,
                          searchMedia: media.value, init: true);
                      refreshController.finishRefresh();
                      refreshController.resetFooter();
                    },
                    onLoad: () async {
                      final resp = await fetchData(search.value,
                          searchMedia: media.value);
                      refreshController.finishLoad(resp.data.length >= pageSize
                          ? IndicatorResult.success
                          : IndicatorResult.noMore);
                    },
                    child: CustomScrollView(
                      slivers: [
                        // 顶部两个 Card（只有未搜索时显示）
                        if (!isSearchMode)
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const SizedBox(height: 6),
                                const Card(
                                  // margin: EdgeInsets.zero, // 去除边距
                                  elevation: 0, // 去除阴影
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    side: BorderSide.none, // 移除边框线
                                  ),

                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: BuildQuickAction(
                                                icon: Icons.person,
                                                title: "客户管理",
                                                color: Colors.orange,
                                                route: CrmCompanyRoute())),
                                        Expanded(
                                            child: BuildQuickAction(
                                                icon: Icons.group,
                                                title: "供应商管理",
                                                color: Colors.red,
                                                route: SupplySupplierRoute())),
                                        Expanded(
                                            child: BuildQuickAction(
                                                icon: Icons.inventory_2,
                                                title: "市场产品管理", //todo 新页面
                                                color: Colors.blue,
                                                route: MarketRoute())),
                                        Expanded(
                                            child: BuildQuickAction(
                                                icon: Icons.receipt_long,
                                                title: "报价单管理", // 报价单列表页面
                                                color: Colors.green,
                                                route: QuoteListRoute())),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  color: colorScheme.secondary,
                                  elevation: 2, // 去除阴影
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    side: BorderSide.none, // 移除边框线
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                      height:
                                                          1.2, // 行高倍数，默认大约 1.4
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12,
                                                        8,
                                                        10,
                                                        8), // 所有方向的边距都是6
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFFFFFFFF),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                      // topRight: Radius.circular(8),
                                                    )),
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 1, 0),
                                                child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly, // 平均分配空间
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch, // 关键：让子元素高度填满
                                                    children: [
                                                      BuildQuickAction(
                                                          icon: Icons.add,
                                                          title: "新增客户",
                                                          color: Colors.orange,
                                                          route:
                                                              CrmCompanyCreateRoute()),
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
                                                              MarketCreateRoute()),
                                                      BuildQuickAction(
                                                          icon: Icons.add,
                                                          title: "新增报价单",
                                                          color: Colors.green,
                                                          route:
                                                              QuoteCreateRoute()),
                                                    ])))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // 产品 Grid
                        SliverPadding(
                          padding: const EdgeInsets.all(5),
                          sliver: SliverMasonryGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childCount: samples.value.length,
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
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
