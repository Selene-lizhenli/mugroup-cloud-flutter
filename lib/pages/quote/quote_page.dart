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

    // 关联状态
    final selectedQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);
    final boundQuoteForSupplier = useState<Map<String, dynamic>?>(null);

    // --- 分页与展开状态 ---
    final isRecordsExpanded = useState(false);
    final recordsPage = useState(0);
    final isSuppliersExpanded = useState(false);
    final suppliersPage = useState(0);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final lastSearch = useRef('');

    // 获取带客记录列表
    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();
      final quoteParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "50",
        "type": "market",
      };

      try {
        final response = await getShowroomQuotation(quoteParams);
        if (context.mounted) {
          list.value = response.data;
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
      final boundQuote = boundQuoteForSupplier.value;
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
    }, [boundQuoteForSupplier.value]);

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
                        if (boundQuoteForSupplier.value == null) {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => const QuoteSelect());
                          if (result != null) {
                            boundQuoteForSupplier.value = result;
                          }
                        }

                        showModalBottomSheet(
                            context: context,
                            builder: (context) => AddSupplierSheet(
                                quotationId:
                                    boundQuoteForSupplier.value?['id']));
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionPillButton(
                      label: '导入供应商',
                      // icon: Icons.add,
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onSecondary,
                      onTap: () async {
                        final boundQuote = boundQuoteForSupplier.value;

                        if (boundQuoteForSupplier.value == null) {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => const QuoteSelect());
                          if (result != null) {
                            boundQuoteForSupplier.value = result;
                          }
                        }

                        context.router.push(
                          ProductBatchImportRoute(
                            quotationId: boundQuote?['id'],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    _buildBoundQuoteBar(context, boundQuoteForSupplier, () {
                      boundQuoteForSupplier.value = null;
                      quoteSampleSupplierList.value = [];
                    }),
                    _buildDetailList(
                        context,
                        isLoading.value,
                        groupedData,
                        boundQuoteForSupplier.value,
                        isSuppliersExpanded,
                        suppliersPage),
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
                    context, selectedQuote, selectedSupplier, colorScheme),
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
                        behavior: HitTestBehavior.opaque, // 确保空白处也能点击
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
                    ActionPillButton(
                        label: '产品',
                        icon: Icons.add,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onTap: () {
                          context.router.push(QuoteProductNewAddRoute(
                              quoteId: boundQuote?['id'],
                              supplierId: supplier?.id?.toString()));
                        }),
                  ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: prods.length,
                      itemBuilder: (context, pIdx) {
                        final img =
                            (prods[pIdx].showroomSample?.image?.isNotEmpty ??
                                    false)
                                ? prods[pIdx].showroomSample!.image![0].url
                                : null;
                        return Container(
                          width: 70,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4)),
                          child: img != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
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
    final isReady = quote.value != null && supplier.value != null;
    return Stack(
      children: [
        Column(children: [
          if (isReady)
            GestureDetector(
              onTap: () => _showPreSelectionSheet(context, quote, supplier),
              child: Container(
                margin: const EdgeInsets.all(12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note_rounded,
                        size: 20, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14),
                          children: [
                            const TextSpan(
                                text: "当前录入：",
                                style: TextStyle(color: Colors.grey)),
                            TextSpan(
                              text:
                                  "${quote.value?['company']?.name} / ${supplier.value?['short_name'] ?? supplier.value?['name']}",
                              style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 20, color: Colors.grey[400]),
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
            onTap: () => _showPreSelectionSheet(context, quote, supplier),
            child: Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.touch_app, size: 40, color: Colors.grey),
                  Text("点击完善相关信息后开始录入")
                ]))),
          ))
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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: page.value > 0 ? () => page.value-- : null),
      Text("${page.value + 1} / $total"),
      IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: page.value < total - 1 ? () => page.value++ : null),
    ]);
  }

  Widget _buildEmpty(String txt) => Center(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(txt, style: const TextStyle(color: Colors.grey))));

  void _showError(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
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
                    isRequired: true,
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
              if (currentQuote != null && currentSupplier != null) {
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
