import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/views/product_view.dart';
import 'package:cloud/pages/samples/views/showroom_view.dart';
import 'package:cloud/pages/samples/widgets/home_app_bar.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/widgets/quotation_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SamplesListPage extends HookConsumerWidget {
  const SamplesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    // 本地保存当前 PageView 索引，初始值来自全局状态
    final currentPageIndex = useState<int>(home.currentPage);
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final currentWarehouse = home.currentSelectedWarehouse;
    final cloud = ref.watch(coreProvider).value;
    final currentTenant = cloud?.currentTenant;
    final cartState = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final cartTotalQty =
        cartState.items.fold<int>(0, (sum, item) => sum + item.count);
    final quotationInfo = cartState.quotationInfo;

    useEffect(() {
      if (currentTenant != null) {
        Future.microtask(() => homeNotifier.fetchWarehouses(currentTenant));
      }
      return null;
    }, [currentTenant]);

    final bool showShowroom =
        home.isLoadingWarehouses || home.warehouses.isNotEmpty;

    // 2. 动态生成页面列表
    final List<Widget> pages = [
      if (showShowroom) const SamplesPageView(),
      const ProductView(),
    ];

    // 3. 计算当前的逻辑索引
    // 如果没有样品间页，ProductView 就是第 0 页；如果有，它是第 1 页
    final int productViewIndex = showShowroom ? 1 : 0;

    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new);

    final appBarTitle = currentPageIndex.value == productViewIndex
        ? (currentWarehouse?.name ?? l10n.samplesShowroom)
        : l10n.samplesShowroom;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorScheme.surfaceTint,
      endDrawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 252, 249, 243),
        surfaceTintColor: Colors.transparent,
        width: MediaQuery.sizeOf(context).width * 0.5,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 27,
                      color: colorScheme.secondary,
                    ),
                    if (cartTotalQty > 0)
                      Positioned(
                        right: -15,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          constraints: const BoxConstraints(minWidth: 18),
                          child: Text(
                            cartTotalQty > 99 ? '99+' : '$cartTotalQty',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  l10n.samplesCart,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.router.push(const CartRoute());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.request_quote_outlined,
                  size: 27,
                  color: Color(0xFFF5A824),
                ),
                title: Text(
                  l10n.samplesQuotation,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  context.router.push(const SampleQuoteListRoute());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  size: 27,
                  color: colorScheme.onSurface.withOpacity(0.72),
                ),
                title: Text(
                  l10n.settings,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  final next = await QuotationInfoDialog.show(
                    context,
                    initialValue: quotationInfo,
                  );
                  if (next == null) return;
                  cart.quotationInfo = next;
                  EasyLoading.showSuccess(
                    l10n.samplesSettingsSuccess,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
              if (currentPageIndex.value == productViewIndex)
                ListTile(
                  leading: const Icon(
                    Icons.swap_horiz_outlined,
                    size: 27,
                    color: Color(0xFF50BF50),
                  ),
                  title: Text(
                    home.isDetailedMode
                        ? l10n.samplesQuickBrowseMode
                        : l10n.samplesCardDetailMode,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (home.isDetailedMode) {
                      homeNotifier.setViewMode(false);
                    } else {
                      homeNotifier.setViewMode(true);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: colorScheme.surfaceTint,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 42,
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: kToolbarHeight,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (currentPageIndex.value == productViewIndex) {
                            home.searchTextController.clear();
                            homeNotifier.setSearch('');
                            homeNotifier.clearMedia();
                            home.bus.dispatch(
                              SearchEvent(search: '', media: null),
                            );
                            homeNotifier.switchToPage(0);
                            homeNotifier.setCurrentSelectedWarehouse(null);
                          } else {
                            context.router.maybePop();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        appBarTitle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    if (currentPageIndex.value == productViewIndex)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              context.router.push(const CartRoute());
                            },
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: colorScheme.secondary,
                            ),
                          ),
                          if (cartTotalQty > 0)
                            Positioned(
                              right: -18,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                constraints: const BoxConstraints(minWidth: 18),
                                child: Text(
                                  cartTotalQty > 99 ? '99+' : '$cartTotalQty',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (currentPageIndex.value == productViewIndex)
                      const SizedBox(width: 7),
                    SizedBox(
                      width: 40,
                      height: 42,
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          size: 23,
                          color: colorScheme.primary,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: colorScheme.secondary,
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeAppBar(
                    controller: home.searchTextController,
                    onSearchText: (search) {
                      final text = search.trim();
                      // 文本为空时，使用样品间列表页（SamplesPageView）
                      if (text.isNotEmpty && home.currentPage == 0) {
                        homeNotifier.switchToProductView();
                      }
                      homeNotifier.setSearch(search);
                      homeNotifier.fetchSamples(
                        searchText: search,
                        searchMedia: home.currentMedia,
                        init: true,
                      );
                    },
                    onSearchMedia: (temporaryMedia) {
                      homeNotifier.switchToProductView();
                      homeNotifier.addMedia(temporaryMedia);
                      if (temporaryMedia.idEquals(home.currentMediaId)) {
                        return;
                      }
                      // 图片搜索后切换到商品列表页（ProductView）
                      homeNotifier.fetchSamples(
                        searchText: home.search,
                        searchMedia: temporaryMedia,
                        init: true,
                      );
                    },
                    onDeleteMedia: (temporaryMedia) {
                      final nextState =
                          homeNotifier.deleteMedia(temporaryMedia);
                      if (nextState.currentMediaId == home.currentMediaId) {
                        return;
                      }
                      homeNotifier.fetchSamples(
                        searchText: nextState.search,
                        searchMedia: nextState.currentMediaId == null
                            ? null
                            : nextState.currentMedia,
                        init: true,
                      );
                    },
                  ),
                  Expanded(
                    child: PageView(
                      controller: home.pageController,
                      onPageChanged: (page) {
                        homeNotifier.switchToPage(page);
                        currentPageIndex.value = page;
                        if (showShowroom && page == 0) {
                          homeNotifier.setCurrentSelectedWarehouse(null);
                        }
                      },
                      allowImplicitScrolling: false,
                      children: pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
