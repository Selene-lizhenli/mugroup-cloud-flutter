import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_new_add_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/quote_product_list_page.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class QuotePage extends HookConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    useAutomaticKeepAlive(wantKeepAlive: true);

    // --- 基础数据状态 ---
    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);

    // --- 选中与联动状态 (真理来源) ---
    final activeQuoteId = useState<int?>(null); // 当前展开预览的卡片 ID
    final selectedSupplierId = useState<int?>(null); // 当前选中的供应商 ID
    final activeProducts =
        useState<List<QuotationSample>>([]); // 存储卡片内点击请求回来的详细产品
    final isProductLoading = useState(false); // 预览产品的加载状态

    // --- 添加产品板块的独立状态 ---
    final currentQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    // --- 控制与搜索 ---
    final recordsDisplayCount = useState(2);
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final lastSearch = useRef('');

    const String quoteCacheKey = 'cache_current_quote';
    const String supplierCacheKey = 'cache_selected_supplier';

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
            .toList();

        activeProducts.value = filtered;
      } catch (e) {
        debugPrint("Fetch Active Products Error: $e");
      } finally {
        isProductLoading.value = false;
      }
    }

    // 搜索监听
    useEffect(() {
      fetchData();
      void onSearchChanged() {
        final current = searchController.text.trim();
        if (current == lastSearch.value) return;
        lastSearch.value = current;
        fetchData();
      }

      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("带客记录",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 1. 刷新主列表
          await fetchData();
          // 2. 如果当前有展开项，同步刷新明细产品
          if (activeQuoteId.value != null && selectedSupplierId.value != null) {
            await fetchActiveProducts();
          }
        },
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              QuoteSearchBar(controller: searchController),
              _buildSectionCard(
                context,
                title: "客户列表",
                icon: Icons.access_time_filled_rounded,
                iconColor: Colors.blueAccent,
                action: IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.blueAccent),
                    onPressed: () => context.router.push(QuoteCreateRoute())),
                content: _buildRecentRecordsContent(
                  context,
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
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "添加产品",
                icon: Icons.grid_view_rounded,
                iconColor: Colors.purpleAccent,
                content: _buildProductAddSection(
                    context, currentQuote, selectedSupplier, colorScheme),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 客户列表内容渲染
  Widget _buildRecentRecordsContent(
      BuildContext context,
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
                    // 点击后立即执行异步刷新
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
              _buildTextBtn("加载更多", Icons.keyboard_arrow_down,
                  () => displayCount.value += 5),
            if (canCollapse)
              _buildTextBtn("收起", Icons.keyboard_arrow_up, () {
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
                final imgUrl =
                    (sample?.image != null && sample!.image!.isNotEmpty)
                        ? sample.image![0].url
                        : null;

                return GestureDetector(
                  onTap: () {
                    if (sample?.id != null) {
                      context.router
                          .push(ShowroomSampleDetailRoute(id: sample!.id!));
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
                      child: imgUrl != null
                          ? Image.network(imgUrl, fit: BoxFit.cover)
                          : Image.asset(
                              'assets/noImage.png',
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
    final isReady = supplier.value != null;

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
                          if (quote.value != null) // 只有有值时才显示清除
                            GestureDetector(
                              onTap: () =>
                                  quote.value = null, // 直接置空，触发持久化和UI刷新
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.cancel,
                                    size: 14, color: Colors.grey[400]),
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
                              onTap: () => supplier.value = null,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.cancel,
                                    size: 14, color: Colors.grey[400]),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // 右侧箭头表示可点击进入编辑
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: Colors.grey[300]),
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 600,
            child: QuoteProductListPage(
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
      required Widget content,
      Widget? action}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
            child: Row(children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              title is Widget
                  ? title
                  : Text(title.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (action != null) action,
            ]),
          ),
          const Divider(height: 1),
          content,
        ],
      ),
    );
  }

  Widget _buildTextBtn(String label, IconData icon, VoidCallback onTap,
      {bool isGrey = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    color: isGrey ? Colors.grey : Colors.blueAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            Icon(icon,
                size: 18, color: isGrey ? Colors.grey : Colors.blueAccent),
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
  // 内部工具函数：安全解析名称，兼容 Map 和 Model 对象
  String getSafeName(dynamic data, List<String> keys) {
    if (data == null) return '';
    if (data is Map) {
      for (var key in keys) {
        if (data[key] != null) return data[key].toString();
      }
    }
    try {
      if (keys.contains('name')) return data.name ?? '';
      if (keys.contains('short_name')) return data.shortName ?? data.name ?? '';
    } catch (_) {}
    return '';
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => HookConsumer(builder: (context, ref, child) {
      final colorScheme = Theme.of(context).colorScheme;
      final currentQuote = useValueListenable(selectedQuote);
      final currentSupplier = useValueListenable(selectedSupplier);

      // 提取解析后的显示值
      final companyName = getSafeName(currentQuote?['company'], ['name']);
      final supplierName = getSafeName(currentSupplier, ['short_name', 'name']);

      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 20,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部横条指示器
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text("录入信息确认",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // 客户选择
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                    context: context, builder: (_) => const QuoteSelect());
                if (result != null) selectedQuote.value = result;
              },
              child: AbsorbPointer(
                  child: Input(
                label: '对应客户',
                value: companyName,
                hintText: '请选择客户',
                showClearButton: false,
              )),
            ),
            const SizedBox(height: 16),

            // 供应商选择
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<Map<String, dynamic>>(
                    context: context, builder: (_) => const SupplierSelect());
                if (result != null) selectedSupplier.value = result;
              },
              child: AbsorbPointer(
                  child: Input(
                label: '所属供应商',
                isRequired: true,
                value: supplierName,
                hintText: '请选择供应商',
                showClearButton: false,
              )),
            ),
            const SizedBox(height: 32),

            // 确定按钮
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                // 只有供应商是必填项，满足即可关闭
                if (selectedSupplier.value != null) {
                  Navigator.pop(context);
                } else {
                  EasyLoading.showInfo("请先选择供应商");
                }
              },
              child: const Text("确定",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }),
  );
}
