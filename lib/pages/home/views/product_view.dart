import 'package:cloud/helper/helper.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/pages/home/widgets/product_dropdown_menu.dart';
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
                          logger.d(menuQuery);
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
