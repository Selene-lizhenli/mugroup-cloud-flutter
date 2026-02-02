import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_new_add_page.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuotePage extends HookConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    useAutomaticKeepAlive(wantKeepAlive: true);

    // 基础数据状态
    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);
    final quoteSampleSupplierList = useState<List<QuotationSample>>([]);

    // --- 统一使用这个变量作为当前选中的客户上下文 ---
    final currentQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    // --- 分页与展开状态 ---
    final isRecordsExpanded = useState(false);
    final recordsPage = useState(0);
    final isSuppliersExpanded = useState(false);
    final suppliersPage = useState(0);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final lastSearch = useRef('');

    // 辅助方法：统一客户选择逻辑
    Future<void> pickQuote() async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const QuoteSelect());
      if (result != null) {
        currentQuote.value = result;
      }
    }

    // 获取带客记录列表
    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();
      final quoteParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "50",
        "type": "market",
        "includes": 'supplyQuotes.supplier'
      };

      try {
        final response = await getShowroomQuotation(quoteParams);
        if (context.mounted) {
          list.value = response.data;
          //默认关联第一个报价
          if (currentQuote.value == null && response.data.isNotEmpty) {
            final firstItem = response.data.first;

            currentQuote.value = firstItem.toJson();
          }
        }
      } catch (e) {
        debugPrint("Error fetching quotation data: $e");
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

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

    Future<void> fetchSupplierData() async {
      final boundQuote = currentQuote.value;
      if (boundQuote?['id'] == null) {
        quoteSampleSupplierList.value = [];
        return;
      }
      final params = {"page": '1', "pageSize": 1000};
      try {
        final resp =
            await getQuotationProductListByProductId(boundQuote?['id'], params);
        quoteSampleSupplierList.value = resp.data;
      } catch (e) {
        debugPrint("Fetch Supplier Error: $e");
      }
    }

    useEffect(() {
      fetchSupplierData();
      return null;
    }, [currentQuote.value]);

    // 分组逻辑
    final groupedData = useMemoized(() {
      Map<String, List<QuotationSample>> groups = {};
      for (var item in quoteSampleSupplierList.value) {
        final supplierName = item.supplyQuote?.supplier?.shortName ??
            item.supplyQuote?.supplier?.name ??
            '未知供应商';
        if (!groups.containsKey(supplierName)) groups[supplierName] = [];
        groups[supplierName]!.add(item);
      }
      return groups;
    }, [quoteSampleSupplierList.value]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
          fetchData();
          fetchSupplierData();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
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
                content: _buildRecentRecordsContent(context, isLoading.value,
                    list.value, isRecordsExpanded, recordsPage),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "供应商列表",
                icon: Icons.list_alt_rounded,
                iconColor: Colors.orangeAccent,
                action: Row(
                  children: [
                    ActionPillButton(
                      label: '新增供应商',
                      backgroundColor: colorScheme.primary,
                      textColor: Colors.white,
                      onTap: () async {
                        if (currentQuote.value == null) {
                          await pickQuote();
                        }

                        if (currentQuote.value != null) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => AddSupplierSheet(
                                  quotationId: currentQuote.value?['id']));
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionPillButton(
                      label: '导入供应商',
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onSecondary,
                      onTap: () async {
                        if (currentQuote.value == null) {
                          await pickQuote();
                        }

                        if (currentQuote.value != null) {
                          context.router.push(
                            ProductBatchImportRoute(
                              quotationId: currentQuote.value?['id'],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    _buildBoundQuoteBar(context, currentQuote, () {
                      currentQuote.value = null;
                      quoteSampleSupplierList.value = [];
                    }),
                    _buildDetailList(context, isLoading.value, groupedData,
                        currentQuote.value, isSuppliersExpanded, suppliersPage),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '添加产品',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '请完善相关信息',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
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

  Widget _buildSectionCard(BuildContext context,
      {required dynamic title,
      required IconData icon,
      required Color iconColor,
      required Widget content,
      Widget? action}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
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

  Widget _buildBoundQuoteBar(BuildContext context,
      ValueNotifier<Map<String, dynamic>?> boundState, VoidCallback onClear) {
    final isBound = boundState.value != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBound
            ? colorScheme.primary.withOpacity(0.05)
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isBound
                ? colorScheme.primary.withOpacity(0.2)
                : Colors.transparent),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(isBound ? Icons.link : Icons.link_off,
            color: isBound ? colorScheme.primary : Colors.grey),
        title: Text(
            isBound
                ? (boundState.value?['company']?.name ?? '已关联客户')
                : "点击选择关联客户",
            style: TextStyle(
                fontWeight: isBound ? FontWeight.bold : FontWeight.normal)),
        onTap: () async {
          final result = await showModalBottomSheet<Map<String, dynamic>>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const QuoteSelect());
          if (result != null) boundState.value = result;
        },
        trailing: isBound
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onClear)
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildRecentRecordsContent(
      BuildContext context,
      bool isLoading,
      List<QuotationList> data,
      ValueNotifier<bool> isExpanded,
      ValueNotifier<int> page) {
    if (isLoading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: CupertinoActivityIndicator()));
    }
    if (data.isEmpty) return _buildEmpty("暂无记录");

    final itemsPerPage = isExpanded.value ? 5 : 2;
    final totalPages = (data.length / itemsPerPage).ceil();
    final displayList =
        data.skip(page.value * itemsPerPage).take(itemsPerPage).toList();

    return Column(
      children: [
        ...displayList.map((item) => QuoteCard(
            item: item,
            tabIndex: 0,
            onTap: () => context.router.push(QuoteDetailRoute(id: item.id!)))),
        if (isExpanded.value && totalPages > 1) _buildPager(page, totalPages),
        if (data.length > 2) _buildToggleBtn(isExpanded, page, "记录"),
      ],
    );
  }

  Widget _buildDetailList(
      BuildContext context,
      bool isLoading,
      Map<String, List<QuotationSample>> grouped,
      dynamic boundQuote,
      ValueNotifier<bool> isExpanded,
      ValueNotifier<int> page) {
    if (isLoading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: CupertinoActivityIndicator()));
    }
    if (grouped.isEmpty) return _buildEmpty("暂无供应商");

    final names = grouped.keys.toList();
    final itemsPerPage = isExpanded.value ? 5 : 2;
    final totalPages = (names.length / itemsPerPage).ceil();
    final displayNames =
        names.skip(page.value * itemsPerPage).take(itemsPerPage).toList();

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayNames.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final name = displayNames[index];
            final prods = grouped[name]!;
            final supplier = prods.first.supplyQuote?.supplier;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          final quoteId = boundQuote?['id'];
                          final supplierId = supplier?.id;

                          if (quoteId != null && supplierId != null) {
                            context.router.push(
                              SupplierProductsRoute(
                                quotationId: quoteId,
                                supplierId: supplierId,
                                supplierNo: supplier?.supplierNo ?? '',
                                supplierName: supplier?.name ?? '',
                                companyName: boundQuote?['company']?.name ?? '',
                              ),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supplier?.name ?? name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              supplier?.supplierNo ?? '-',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: prods.length + 1,
                      itemBuilder: (context, pIdx) {
                        if (pIdx == 0) {
                          return GestureDetector(
                            onTap: () {
                              context.router.push(QuoteProductNewAddRoute(
                                  quoteId: boundQuote?['id'],
                                  supplierId: supplier?.id?.toString()));
                            },
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2)),
                              ),
                              child: Icon(Icons.add,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 28),
                            ),
                          );
                        }

                        final dataIdx = pIdx - 1;
                        final img =
                            (prods[dataIdx].showroomSample?.image?.isNotEmpty ??
                                    false)
                                ? prods[dataIdx].showroomSample!.image![0].url
                                : null;

                        return Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8)),
                          child: img != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(img, fit: BoxFit.cover))
                              : const Icon(Icons.image_outlined,
                                  color: Colors.grey),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
        if (isExpanded.value && totalPages > 1) _buildPager(page, totalPages),
        if (names.length > 2) _buildToggleBtn(isExpanded, page, "供应商"),
      ],
    );
  }

  Widget _buildProductAddSection(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>?> quote,
      ValueNotifier<Map<String, dynamic>?> supplier,
      ColorScheme colors) {
    final isReady = supplier.value != null;
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
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                          children: [
                            const TextSpan(text: "当前录入："),
                            TextSpan(
                              text:
                                  "${quote.value?['company']?.name ?? '未选择'} / ${supplier.value?['short_name'] ?? supplier.value?['name'] ?? '未选择'}",
                              style: TextStyle(
                                color: colors.primary.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: Colors.grey[300]),
                  ],
                ),
              ),
            ),
          SizedBox(
              height: 500,
              child: QuoteProductNewAddPage(
                  isEmbedded: true,
                  quoteId: quote.value?['id'],
                  supplierId: supplier.value?['id']?.toString())),
        ]),
        if (!isReady)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showPreSelectionSheet(context, quote, supplier),
              child: const SizedBox.expand(),
            ),
          )
      ],
    );
  }

  Widget _buildToggleBtn(
      ValueNotifier<bool> isExpanded, ValueNotifier<int> page, String label) {
    return InkWell(
      onTap: () {
        isExpanded.value = !isExpanded.value;
        page.value = 0;
      },
      child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(isExpanded.value ? "收起$label" : "查看更多$label",
                style: const TextStyle(color: Colors.blueAccent, fontSize: 13)),
            Icon(
                isExpanded.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.blueAccent)
          ])),
    );
  }

  Widget _buildPager(ValueNotifier<int> page, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 上翻按钮
        TextButton.icon(
          onPressed: page.value > 0 ? () => page.value-- : null,
          label: const Text("上翻", style: TextStyle(fontSize: 13)),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),

        // 页码显示
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${page.value + 1} / $total",
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),

        // 下翻按钮
        TextButton.icon(
          onPressed: page.value < total - 1 ? () => page.value++ : null,
          label: const Text("下翻", style: TextStyle(fontSize: 13)),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(String txt) => Center(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(txt, style: const TextStyle(color: Colors.grey))));
}

Future<void> _showPreSelectionSheet(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>?> selectedQuote,
    ValueNotifier<Map<String, dynamic>?> selectedSupplier) async {
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

      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 16,
            right: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text("完善相关信息",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context, builder: (_) => const QuoteSelect());
              if (result != null) {
                selectedQuote.value = result;
              }
            },
            child: AbsorbPointer(
                child: Input(
                    label: '客户',
                    value: currentQuote?['company']?.name ?? '',
                    hintText: '请选择客户')),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                  context: context, builder: (_) => const SupplierSelect());
              if (result != null) {
                selectedSupplier.value = result;
              }
            },
            child: AbsorbPointer(
                child: Input(
                    label: '供应商',
                    isRequired: true,
                    value: currentSupplier?['short_name'] ??
                        currentSupplier?['name'] ??
                        '',
                    hintText: '请选择供应商')),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              if (currentSupplier != null) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
      );
    }),
  );
}
