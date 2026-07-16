import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/quote_product_list_page.dart';
import 'package:cloud/pages/quote/widgets/customerAndSupplier.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 使用 AutoDispose 保证页面销毁时重置，使用自增数字触发逻辑
final quotePageRefreshTrigger = StateProvider.autoDispose<int>((ref) => 0);

@RoutePage()
class QuotePage extends HookConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    useAutomaticKeepAlive(wantKeepAlive: true);
    final isPinkTheme = ref.watch(appThemeProvider) == ThemeType.pink;
    // --- 基础数据状态 ---
    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);

    // --- 选中与联动状态 (真理来源) ---
    final activeQuoteId = useState<int?>(null); // 当前展开预览的卡片 ID
    final selectedSupplierId = useState<int?>(null); // 当前选中的供应商 ID
    final activeProducts =
        useState<List<QuotationSample>>([]); // 存储卡片内点击请求回来的详细产品
    final isProductLoading = useState(false); // 预览产品的加载状态
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度

    // --- 添加产品板块的独立状态 ---
    final currentQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    // --- 控制与搜索 ---
    final recordsDisplayCount = useState(2);
    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    const String quoteCacheKey = 'cache_current_quote';
    const String supplierCacheKey = 'cache_selected_supplier';
    final l10n = context.l10n;
// 1. 初始化加载：从本地恢复数据
    useEffect(() {
      Future<void> restoreData() async {
        final prefs = await SharedPreferences.getInstance();
        final qStr = prefs.getString(quoteCacheKey);
        final sStr = prefs.getString(supplierCacheKey);

        // 注意：存进去的是 Map，读出来也是 Map，这会解决类型冲突
        if (qStr != null) currentQuote.value = jsonDecode(qStr);
        if (sStr != null) selectedSupplier.value = jsonDecode(sStr);
      }

      restoreData();
      return null;
    }, []);

    // --- 自动保存与清除逻辑 ---
    useEffect(() {
      Future<void> persistData() async {
        final prefs = await SharedPreferences.getInstance();

        // 处理客户数据
        if (currentQuote.value != null) {
          await prefs.setString(quoteCacheKey, jsonEncode(currentQuote.value));
        } else {
          await prefs.remove(quoteCacheKey); // 关键：如果是 null，从本地物理删除
        }

        // 处理供应商数据
        if (selectedSupplier.value != null) {
          await prefs.setString(
              supplierCacheKey, jsonEncode(selectedSupplier.value));
        } else {
          await prefs.remove(supplierCacheKey); // 关键：如果是 null，从本地物理删除
        }
      }

      persistData();
      return null;
    }, [currentQuote.value, selectedSupplier.value]);

// 3. 辅助函数：安全地从 Map 或 Model 获取名称 (解决之前的报错)

    // 获取主列表数据
    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();
      final quoteParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "50",
        "type": "market",
        "includes": 'supplyQuotes.supplier.media'
      };
      try {
        final response = await getShowroomQuotation(quoteParams);
        if (context.mounted) {
          list.value = response.data;
        }
      } catch (e) {
        debugPrint("Error: $e");
      } finally {
        if (context.mounted) isLoading.value = false;
      }
    }

    // 专门刷新当前卡片下选中的供应商产品 (支持 await)
    Future<void> fetchActiveProducts() async {
      if (activeQuoteId.value == null || selectedSupplierId.value == null) {
        activeProducts.value = [];
        return;
      }

      isProductLoading.value = true;
      try {
        final resp = await getQuotationProductListByProductId(
            activeQuoteId.value!, {"page": '1', "pageSize": 1000});

        final filtered = (resp.data)
            .where(
                (s) => s.supplyQuote?.supplier?.id == selectedSupplierId.value)
            .toList()
          ..sort((a, b) {
            final aTime =
                DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
            final bTime =
                DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });

        activeProducts.value = filtered;
      } catch (e) {
        debugPrint("Fetch Active Products Error: $e");
      } finally {
        isProductLoading.value = false;
      }
    }

    useEffect(() {
      fetchData();
      return null;
    }, []);

    ref.listen(quotePageRefreshTrigger, (previous, next) async {
      if (next > 0) {
        // 1. 执行主列表刷新
        await fetchData();

        // 2. 如果有展开项，也刷新产品明细
        if (activeQuoteId.value != null && selectedSupplierId.value != null) {
          await fetchActiveProducts();
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    isPinkTheme ? lightPink : lightBlue,
                    const Color.fromARGB(255, 241, 241, 241),
                    const Color.fromARGB(255, 241, 241, 241),
                    const Color.fromARGB(255, 241, 241, 241),
                    const Color.fromARGB(255, 241, 241, 241),
                    const Color.fromARGB(255, 241, 241, 241),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingTop),
            child: RefreshIndicator(
              onRefresh: () async {
                await fetchData(); // 1. 刷新主列表
                // 2. 如果当前有展开项，同步刷新明细产品
                if (activeQuoteId.value != null &&
                    selectedSupplierId.value != null) {
                  await fetchActiveProducts();
                }
              },
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 7),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 18),
                              SizedBox(
                                width: 20,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => context.router.maybePop(),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 21,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.dashboardMarketPurchase,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          QuoteSearchBar(
                            controller: searchController,
                            onSearch: (_) => fetchData(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                      child: _buildSectionCard(
                        context,
                        title: "带客记录",
                        icon: Icons.access_time_filled_rounded,
                        iconColor: colorScheme.secondary,
                        iconSize: 26,
                        action: IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          icon: Icon(Icons.add_circle_outline,
                              size: 26, color: colorScheme.secondary),
                          onPressed: () =>
                              context.router.push(QuoteCreateRoute()),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 188, 186, 166),
                        colorScheme: colorScheme,
                        content: _buildRecentRecordsContent(
                          context,
                          currentQuote,
                          selectedSupplier,
                          isLoading.value,
                          list.value,
                          recordsDisplayCount,
                          scrollController,
                          activeProducts,
                          activeQuoteId,
                          selectedSupplierId,
                          isProductLoading,
                          fetchActiveProducts,
                          () async {
                            await fetchData();
                            if (activeQuoteId.value != null &&
                                selectedSupplierId.value != null) {
                              await fetchActiveProducts();
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                      child: _buildSectionCard(
                        context,
                        title: "添加产品",
                        icon: Icons.grid_view_rounded,
                        iconColor: Colors.purpleAccent,
                        iconSize: 24.0,
                        backgroundColor:
                            const Color.fromARGB(255, 135, 135, 135),
                        colorScheme: colorScheme,
                        content: _buildProductAddSection(context, currentQuote,
                            selectedSupplier, colorScheme),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 客户列表内容渲染
  Widget _buildRecentRecordsContent(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>?> currentQuote,
      ValueNotifier<Map<String, dynamic>?> selectedSupplier,
      bool isLoading,
      List<QuotationList> data,
      ValueNotifier<int> displayCount,
      ScrollController scrollController,
      ValueNotifier<List<QuotationSample>> activeProducts,
      ValueNotifier<int?> activeQuoteId,
      ValueNotifier<int?> selectedSupplierId,
      ValueNotifier<bool> isProductLoading,
      Future<void> Function() fetchActiveProducts,
      Future<void> Function() refreshAll) {
    if (isLoading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: CupertinoActivityIndicator()));
    }
    if (data.isEmpty) return _buildEmpty("暂无记录");

    final displayList = data.take(displayCount.value).toList();
    final hasMore = data.length > displayCount.value;
    final canCollapse = displayCount.value > 2;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ...displayList.map((item) {
          // 判断当前卡片是否为激活展开状态
          final isCurrentExpanded = activeQuoteId.value == item.id;

          return Column(
            children: [
              QuoteCard(
                item: item,
                // 【核心】将页面级状态传给卡片，实现刷新后的状态找回
                selectedSupplierId:
                    isCurrentExpanded ? selectedSupplierId.value : null,
                onSupplierSelected: (supplierId) async {
                  if (supplierId == null) {
                    activeQuoteId.value = null;
                    selectedSupplierId.value = null;
                    activeProducts.value = [];
                  } else {
                    activeQuoteId.value = item.id;
                    selectedSupplierId.value = supplierId;

                    currentQuote.value = item.toJson();

                    final matchedSupply = item.supplyQuotes
                        ?.firstWhere((s) => s.supplier?.id == supplierId);
                    if (matchedSupply?.supplier != null) {
                      selectedSupplier.value =
                          matchedSupply!.supplier!.toJson();
                    }

                    await fetchActiveProducts();
                  }
                },
                onTap: () async {
                  final needRefresh =
                      await context.router.push<bool>(QuoteDetailRoute(
                    id: item.id!,
                  ));
                  if (needRefresh == true) {
                    // 删除成功后，执行与下拉刷新相同的逻辑
                    await refreshAll();
                  }
                },
              ),
              if (isCurrentExpanded)
                _buildExpandableProductStrip(context, isProductLoading.value,
                    activeProducts.value, item.id, selectedSupplierId.value),
              const SizedBox(height: 4),
            ],
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasMore)
              _buildTextBtn(
                "加载更多",
                colorScheme,
                Icons.keyboard_arrow_down,
                () => displayCount.value += 5,
              ),
            if (canCollapse)
              _buildTextBtn("收起", colorScheme, Icons.keyboard_arrow_up, () {
                displayCount.value = 2;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn);
                  }
                });
              }, isGrey: true),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // 展开的产品预览横条
  Widget _buildExpandableProductStrip(BuildContext context, bool loading,
      List<QuotationSample> products, int? quoteId, int? supplierId) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.03))),
      child: loading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () => context.router.push(QuoteProductNewAddRoute(
                        quoteId: quoteId, supplierId: supplierId?.toString())),
                    child: Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1)),
                      ),
                      child: Icon(Icons.add_rounded,
                          color: Theme.of(context).primaryColor, size: 28),
                    ),
                  );
                }

                final sample = products[index - 1].showroomSample;
                final thubImgUrl =
                    (sample?.image != null && sample!.image!.isNotEmpty)
                        ? sample.image![0].thumbUrl
                        : null;

                return GestureDetector(
                  onTap: () {
                    if (sample?.id != null) {
                      final allSampleIds = products
                          .map((p) => p.showroomSample?.id)
                          .whereType<int>()
                          .toList();

                      final initialIndex = allSampleIds.indexOf(sample!.id!);

                      context.router.push(ShowroomSampleViewerRoute(
                        initialIds: allSampleIds,
                        initialIndex: initialIndex >= 0 ? initialIndex : 0,
                      ));
                    }
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.05))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: thubImgUrl != null
                          ? Image.network(thubImgUrl, fit: BoxFit.cover)
                          : Image.asset(
                              'assets/icons/no_image.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // 添加产品板块
  Widget _buildProductAddSection(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>?> quote,
      ValueNotifier<Map<String, dynamic>?> supplier,
      ColorScheme colors) {
    final isReady = supplier.value != null || quote.value != null;

    String getName(dynamic data, List<String> keys) {
      if (data == null) return '';
      if (data is Map) {
        for (var key in keys) {
          if (data[key] != null) return data[key].toString();
        }
      }
      // 如果是强类型对象，尝试通过反射/动态访问属性（针对 _$CompanyImpl）
      try {
        if (keys.contains('name')) return data.name;
        if (keys.contains('short_name')) return data.shortName ?? data.name;
      } catch (_) {}
      return '';
    }

    return Stack(
      children: [
        Column(children: [
          if (isReady)
            GestureDetector(
              onTap: () => _showPreSelectionSheet(context, quote, supplier),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.primary.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note_rounded,
                        size: 16, color: colors.primary.withOpacity(0.7)),
                    const SizedBox(width: 6),

                    // --- 客户展示 + 清除 ---
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              getName(quote.value?['company'], ['name']),
                              style: TextStyle(
                                color: colors.primary.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (quote.value != null)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => quote.value = null,
                              child: Icon(
                                Icons.cancel,
                                size: 22,
                                color: Colors.grey[400],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // 分隔符
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text("|",
                          style: TextStyle(
                              color: colors.primary.withOpacity(0.2),
                              fontSize: 12)),
                    ),

                    // --- 供应商名称 + 清除 ---
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              getName(supplier.value, ['short_name', 'name']),
                              style: TextStyle(
                                color: colors.primary.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (supplier.value != null)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => supplier.value = null,
                              child: Icon(Icons.cancel,
                                  size: 22, color: Colors.grey[400]),
                            ),
                        ],
                      ),
                    ),

                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: Colors.grey[300]),
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 600,
            child: QuoteProductListPage(
                key: ValueKey("${quote.value?['id']}_${supplier.value?['id']}"),
                initialQuote: quote.value,
                initialSupplier: supplier.value,
                onChanged: (quoted, suppliered) {
                  quote.value = quoted;
                  supplier.value = suppliered;
                }),
          ),
        ]),
      ],
    );
  }

  // 通用卡片外壳
  Widget _buildSectionCard(BuildContext context,
      {required dynamic title,
      required IconData icon,
      required Color iconColor,
      double? iconSize,
      required Widget content,
      required Color backgroundColor,
      required colorScheme,
      Widget? action}) {
    const borderRadius = 16.0;
    const borderWidth = 1.52;
    const innerRadius = borderRadius - borderWidth;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colorScheme.outline.withOpacity(0.16)),
      ),
      padding: const EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(innerRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 62,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(innerRadius),
                  topRight: Radius.circular(innerRadius),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
              child: Row(
                children: [
                  Icon(icon, size: iconSize ?? 20, color: iconColor),
                  const SizedBox(width: 8),
                  title is Widget
                      ? title
                      : Text(title.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (action != null) action,
                ],
              ),
            ),
            const Divider(height: 1),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTextBtn(
      String label, colorScheme, IconData icon, VoidCallback onTap,
      {bool isGrey = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                  color: isGrey ? Colors.grey : colorScheme.outline,
                  fontSize: 13,
                )),
            Icon(
              icon,
              size: 18,
              color: isGrey ? Colors.grey : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String txt) => Center(
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(txt, style: const TextStyle(color: Colors.grey))));
}

// 辅助：弹窗完善信息
Future<void> _showPreSelectionSheet(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>?> selectedQuote,
    ValueNotifier<Map<String, dynamic>?> selectedSupplier) async {
  await showCustomerAndSupplierSheet(
    context: context,
    initialQuote: selectedQuote.value,
    initialSupplier: selectedSupplier.value,
    onConfirm: (quote, supplier) {
      selectedQuote.value = quote;
      selectedSupplier.value = supplier;
    },
  );
}
