import 'package:auto_route/auto_route.dart';
import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/pages/crm/crm_company/widgets/crm_company_card.dart';
import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/crm.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

const pageSize = 20;

class CompanyView extends HookConsumerWidget {
  const CompanyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useEasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    final home = ref.watch(homeProvider);
    final search = useState<String?>(null);
    final page = useRef(1);
    final companies = useState<List<Company>>(<Company>[]);

    final hasSearched = useState(false);
    final colorScheme = Theme.of(context).colorScheme;

    fetchData(
      String? searchText, {
      bool? init = false,
    }) async {
      search.value = searchText;

      if (init == true) {
        hasSearched.value = true;
      }

      if (init == true) {
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        "page": page.value,
        "pageSize": pageSize,
      };
      final resp = await getCrmCompanies(queryParameters: queryParameters);

      companies.value = resp.data;

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
            if (search.value == event.search) {
              return;
            }
          }

          search.value = event.search;

          refreshController.callRefresh(force: true);
        },
      );

      return () {
        searchEventSubscription.cancel();
      };
    }, []);

    return Container( 
        margin: const EdgeInsets.fromLTRB(12, 2, 12, 0),
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
            final resp = await fetchData(search.value);

            refreshController.finishLoad(resp.data.length >= pageSize
                ? IndicatorResult.success
                : IndicatorResult.noMore);
          },
          child: CustomScrollView(
            slivers: [
              MultiSliver(
                children: [
                  if (companies.value.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          hasSearched.value ? '暂无数据' : '请输入关键词搜索',
                          style: TextStyle(
                            color: colorScheme.surfaceContainerHighest,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 0,
                        childCount: companies.value.length,
                        itemBuilder: (context, index) {
                          final company = companies.value[index];
                          return CrmCompanyCard(
                            company: company,
                            onTap: () {
                              context.router
                                  .push(CrmCompanyDetailRoute(id: company.id!));
                            },
                            onEdit: () async {
                              final shouldRefresh = await context.router
                                  .push(CrmCompanyEditRoute(id: company.id!));

                              if (shouldRefresh == true) {
                                await fetchData(
                                  search.value,
                                  init: true,
                                );

                                refreshController.finishRefresh();
                                refreshController.resetFooter();
                              }
                            },
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
