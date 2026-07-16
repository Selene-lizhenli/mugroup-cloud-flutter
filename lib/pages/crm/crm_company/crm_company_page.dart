import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/crm/views/company_view.dart';
import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:cloud/providers/app_provider.dart';
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
    final user = ref.watch(userProvider).user;
    final permissions = user?.permissions ?? [];
    final homeNotifier = ref.read(homeProvider.notifier);
    final currentPageIndex = useState<int>(0);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardCustomer),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          if (permissions.contains('crm.company.store'))
            TextButton(
              onPressed: () async {
                context.router.push(const MarketProductCompanyCreateRoute());
              },
              child: Text(
                "新增",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: MuSearchBar(
              controller: home.searchTextController,
              hintText: '搜索客户名称',
              buttonText: '搜索',
              onSearch: (search) {
                homeNotifier.setSearch(search ?? '');
                home.bus.dispatch(SearchEvent(search: search));
              },
            ),
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
      ),
    );
  }
}
