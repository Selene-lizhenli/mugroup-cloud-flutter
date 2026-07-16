import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/market_product/events/search_event.dart';
import 'package:cloud/pages/market_product/list/widgets/product_view.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/market_product/list/widgets/home_app_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/widgets/quotation_info_dialog.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductListPage extends HookConsumerWidget {
  const MarketProductListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final homeNotifier = ref.read(homeProvider.notifier);
    final currentPageIndex = useState<int>(0);
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final quotationInfo = state.quotationInfo;

    final currencies = [
      const FlanActionSheetAction(name: "CNY"),
      const FlanActionSheetAction(name: "USD"),
      const FlanActionSheetAction(name: "EUR"),
      const FlanActionSheetAction(name: "GBP")
    ];

    Future<void> quotationInfoDialog(BuildContext context) async {
      final next = await QuotationInfoDialog.show(
        context,
        initialValue: quotationInfo,
        currencies: currencies.map((e) => e.name).toList(growable: false),
      );
      if (next == null) return;
      cart.quotationInfo = next;
    }

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('市场产品'),
          elevation: 0,
          backgroundColor: colorScheme.surface,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  quotationInfoDialog(context);
                },
                icon: const Icon(Icons.settings_outlined)),
            TextButton(
              onPressed: () async {
                context.router.push(QuoteProductNewAddRoute());
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: HomeAppBar(
                controller: home.searchTextController,
                onSearchText: (search) {
                  homeNotifier.setSearch(search);
                  home.bus.dispatch(
                      SearchEvent(search: search, media: home.currentMedia));
                },
                onSearchMedia: (temporaryMedia) {
                  homeNotifier.addMedia(temporaryMedia);
                  if (temporaryMedia.idEquals(home.currentMediaId)) {
                    return;
                  }
                  home.bus.dispatch(
                      SearchEvent(search: home.search, media: temporaryMedia));
                },
                onDeleteMedia: (temporaryMedia) {
                  final nextState = homeNotifier.deleteMedia(temporaryMedia);
                  if (nextState.currentMediaId == home.currentMediaId) {
                    return;
                  }

                  home.bus.dispatch(SearchEvent(
                    media: nextState.currentMedia,
                    search: nextState.search,
                  ));
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
                children: const [MarketProductView()],
              ),
            ),
          ],
        ));
  }
}
