import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/crm/views/company_view.dart';
import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/list/widgets/home_app_bar.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyPage extends HookConsumerWidget {
  const CrmCompanyPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final currentPageIndex = useState<int>(0);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('客户列表'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            TextButton(
              onPressed: () async {
                context.router.push(const CrmCompanyCreateRoute());
              },
              child: Text(
                "新增",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 8,
            ),
            HomeAppBar(
              enableImageSearch: false,
              controller: home.searchTextController,
              onSearchText: (search) {
                homeNotifier.setSearch(search);
                home.bus.dispatch(
                    SearchEvent(search: search, media: home.currentMedia));
              },
            ),
            Expanded(
              child: PageView(
                controller: home.pageController,
                onPageChanged: (page) {
                  homeNotifier.setCurrentPage(page);
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
                children: const [CompanyView()],
              ),
            ),
          ],
        ));
  }
}
