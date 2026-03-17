import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/samples/events/search_event.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/views/product_view.dart';
import 'package:cloud/pages/samples/views/showroom_view.dart';
import 'package:cloud/pages/samples/widgets/home_app_bar.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final currentWarehouse = home.currentSelectedWarehouse;
    final cloud = ref.watch(coreProvider).value;
    final currentTenant = cloud?.currentTenant;

    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final quotationInfo = state.quotationInfo;

    final exchangeFieldKey = GlobalKey();
    final commissionRateFieldKey = GlobalKey();

    final currencies = [
      const FlanActionSheetAction(name: "CNY"),
      const FlanActionSheetAction(name: "USD"),
      const FlanActionSheetAction(name: "EUR"),
      const FlanActionSheetAction(name: "GBP")
    ];

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

    void scrollToField(GlobalKey key) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final context = key.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.8, // 越小越靠上
          );
        }
      });
    }

    // 3. 计算当前的逻辑索引
    // 如果没有样品间页，ProductView 就是第 0 页；如果有，它是第 1 页
    final int productViewIndex = showShowroom ? 1 : 0;

    void quotationInfoDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          bool? showPrice = quotationInfo?.showPrice;
          bool? showTaxRatePrice = quotationInfo?.showTaxRatePrice;
          String? currency = quotationInfo?.curreny;
          final exchangeController = TextEditingController();
          final commissionRateController = TextEditingController();

          exchangeController.text = quotationInfo?.exchange?.toString() ?? "";
          commissionRateController.text =
              quotationInfo?.commissionRate?.toString() ?? "";

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "报价单设置",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "以下设置将对选样车中的所有样品生效",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "是否显示价格",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Radio<bool>(
                                  value: true,
                                  groupValue: showPrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showPrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '是',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Radio<bool>(
                                  value: false,
                                  groupValue: showPrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showPrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '否',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '采购价是否含税',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Radio<bool>(
                                  value: true,
                                  groupValue: showTaxRatePrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showTaxRatePrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '是',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Radio<bool>(
                                  value: false,
                                  groupValue: showTaxRatePrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showTaxRatePrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '否',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "报价币种",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showFlanActionSheet(
                                  context,
                                  description: "请选择报价币种",
                                  cancelText: "我再想想",
                                  actions: currencies,
                                  closeOnClickAction: true,
                                  onSelect: (action, index) {
                                    currency = currencies[index].name;
                                    setState(() {});
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        colorScheme.outline.withOpacity(0.30),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorScheme.surfaceContainer,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currency ?? "请选择报价币种",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: currency == null
                                              ? colorScheme.onSurface
                                                  .withOpacity(0.5)
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "汇率",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              key: exchangeFieldKey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceContainer,
                              ),
                              child: TextField(
                                controller: exchangeController,
                                cursorColor: colorScheme.secondary,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入汇率",
                                  hintStyle: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                onTap: () {
                                  scrollToField(exchangeFieldKey);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "佣金比率(%)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              key: commissionRateFieldKey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceContainer,
                              ),
                              child: TextField(
                                controller: commissionRateController,
                                cursorColor: colorScheme.secondary,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入佣金比率",
                                  hintStyle: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                onTap: () {
                                  scrollToField(commissionRateFieldKey);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 固定底部按钮区域
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              "取消",
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              cart.quotationInfo = null;
                              double? exchange =
                                  double.tryParse(exchangeController.text);
                              double? commissionRate = double.tryParse(
                                  commissionRateController.text);
                              cart.quotationInfo = QuotationInfo(
                                  showPrice,
                                  showTaxRatePrice,
                                  currency,
                                  exchange,
                                  commissionRate);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "提交",
                              style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: colorScheme.surfaceTint,
        appBar: AppBar(
          title: Text(currentPageIndex.value == 1
              ? currentWarehouse?.name ?? '样品间'
              : '样品间'),
          backgroundColor: colorScheme.surfaceTint,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (home.isDetailedMode)
              IconButton(
                  onPressed: () {
                    quotationInfoDialog(context);
                  },
                  icon: const Icon(Icons.settings_outlined)),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 25,
                  color: colorScheme.primary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.router.push(const CartRoute());
                },
              ),
            ),
            if (currentPageIndex.value == productViewIndex) ...[
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                offset: const Offset(-8, 38),
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (String value) {
                  if (value == 'detailed') {
                    homeNotifier.setViewMode(true);
                  } else if (value == 'simple') {
                    homeNotifier.setViewMode(false);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: home.isDetailedMode ? 'simple' : 'detailed',
                      child: Text(home.isDetailedMode ? '精简模式' : '详细模式'),
                    ),
                  ];
                },
              )
            ],
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (currentPageIndex.value == 1) {
                //清空搜索内容
                home.searchTextController.clear();
                homeNotifier.setSearch('');
                homeNotifier.clearMedia(); //清空图片媒体内容
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
        body: Container(
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
                  if (temporaryMedia.id == home.currentMediaId) {
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
                  final nextState = homeNotifier.deleteMedia(temporaryMedia);
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
        ));
  }
}
