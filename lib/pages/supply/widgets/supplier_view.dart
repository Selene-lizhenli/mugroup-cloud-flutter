import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/supply/widgets/supplier_card.dart';
import 'package:cloud/services/supply.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

const pageSize = 20;

class SupplierView extends HookConsumerWidget {
  const SupplierView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final home = ref.watch(homeProvider);
    final search = useState(home.search);
    final media = useState<TemporaryMedia?>(home.currentMedia);

    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    final colorScheme = Theme.of(context).colorScheme;

    final page = useRef(1);
    final suppliers = useState<List<Supplier>>(<Supplier>[]);

    final hasSearched = useState(false);

    fetchData(
      String? searchText, {
      bool? init = false,
      TemporaryMedia? searchMedia,
    }) async {
      search.value = searchText;
      media.value = searchMedia;

      // 如果搜索内容为空，清空列表并返回空响应
      if (searchText == null || searchText.trim().isEmpty) {
        if (init == true) {
          suppliers.value = [];
          hasSearched.value = false;
          page.value = 1;
        }
        return ApiResponse<List<Supplier>>.data([], null);
      }

      if (init == true) {
        hasSearched.value = true;
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        if (searchMedia != null) "image": searchMedia.id,
        "page": page.value,
        "pageSize": pageSize,
      };
      final resp = await getSupplySuppliers(queryParameters: queryParameters);

      if (init == true) {
        suppliers.value = resp.data;
      } else {
        suppliers.value = [...suppliers.value, ...resp.data];
      }

      if (resp.data.length >= pageSize) {
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
          refreshOnStart: false,
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

            refreshController.finishLoad((resp.data.length) >= pageSize
                ? IndicatorResult.success
                : IndicatorResult.noMore);
          },
          child: CustomScrollView(
            slivers: [
              MultiSliver(
                children: [
                  // 如果搜索内容为空，不展示列表
                  if (search.value == null || search.value!.trim().isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          '请输入关键词搜索',
                          style: TextStyle(
                            color: colorScheme.surfaceContainerHighest,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  // 如果搜索内容不为空，但列表为空，显示"暂无数据"
                  else if (suppliers.value.isEmpty)
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
                  // 如果搜索内容不为空且有数据，展示列表
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(0),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 5,
                        childCount: suppliers.value.length,
                        itemBuilder: (context, index) {
                          final supplier = suppliers.value[index];

                          return SupplierCard(
                            supplier: supplier,
                            onClick: () {},
                          );
                        },
                      ),
                    ),
                ],
              )
            ],
          ),
        ));
  }
}
