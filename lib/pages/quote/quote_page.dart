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

    final currentQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    // --- 展示数量控制 ---
    final recordsDisplayCount = useState(2);
    final suppliersDisplayCount = useState(2);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final lastSearch = useRef('');

    Future<void> pickQuote() async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const QuoteSelect());
      if (result != null) currentQuote.value = result;
    }

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
          if (currentQuote.value == null && response.data.isNotEmpty) {
            currentQuote.value = response.data.first.toJson();
          }
        }
      } catch (e) {
        debugPrint("Error: $e");
      } finally {
        if (context.mounted) isLoading.value = false;
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
      try {
        final resp = await getQuotationProductListByProductId(
            boundQuote?['id'], {"page": '1', "pageSize": 1000});
        quoteSampleSupplierList.value = resp.data;
      } catch (e) {
        debugPrint("Error: $e");
      }
    }

    useEffect(() {
      fetchSupplierData();
      return null;
    }, [currentQuote.value]);

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
                    context, isLoading.value, list.value, recordsDisplayCount),
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
                          if (currentQuote.value == null) await pickQuote();
                          if (context.mounted) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => AddSupplierSheet(
                                    quotationId: currentQuote.value?['id']));
                          }
                        }),
                    const SizedBox(width: 10),
                    ActionPillButton(
                        label: '导入供应商',
                        backgroundColor: colorScheme.primary,
                        textColor: Colors.white,
                        onTap: () async {
                          if (currentQuote.value == null) {
                            await pickQuote();
                          }
                          if (context.mounted) {
                            context.router.push(ProductBatchImportRoute(
                                quotationId: currentQuote.value?['id']));
                          }
                        }),
                  ],
                ),
                content: Column(
                  children: [
                    _buildBoundQuoteBar(context, currentQuote, () {
                      currentQuote.value = null;
                      quoteSampleSupplierList.value = [];
                    }),
                    _buildDetailList(context, isLoading.value, groupedData,
                        currentQuote.value, suppliersDisplayCount),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: const Text('添加产品',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 1),
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
          Divider(height: 1, color: Colors.black.withOpacity(0.05)),
          content,
        ],
      ),
    );
  }

  Widget _buildRecentRecordsContent(BuildContext context, bool isLoading,
      List<QuotationList> data, ValueNotifier<int> displayCount) {
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
        ...displayList.map((item) => QuoteCard(
            item: item,
            tabIndex: 0,
            onTap: () => context.router.push(QuoteDetailRoute(id: item.id!)))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasMore)
              _buildTextBtn("加载更多", Icons.keyboard_arrow_down,
                  () => displayCount.value += 5),
            if (canCollapse)
              _buildTextBtn(
                  "收起", Icons.keyboard_arrow_up, () => displayCount.value = 2,
                  isGrey: true),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailList(
      BuildContext context,
      bool isLoading,
      Map<String, List<QuotationSample>> grouped,
      dynamic boundQuote,
      ValueNotifier<int> displayCount) {
    if (isLoading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: CupertinoActivityIndicator()));
    }
    if (grouped.isEmpty) return _buildEmpty("暂无供应商");

    final names = grouped.keys.toList();
    final displayNames = names.take(displayCount.value).toList();
    final hasMore = names.length > displayCount.value;
    final canCollapse = displayCount.value > 2;

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
                  Text(supplier?.name ?? name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildSupplierHorizontalImages(
                      context, prods, boundQuote, supplier),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasMore)
              _buildTextBtn("加载更多", Icons.keyboard_arrow_down,
                  () => displayCount.value += 5),
            if (canCollapse)
              _buildTextBtn("收起", Icons.keyboard_arrow_up,
                  () => displayCount.value = 2,
                  isGrey: true),
          ],
        ),
      ],
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
                : Colors.black12),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(isBound ? Icons.link : Icons.link_off,
            color: isBound ? colorScheme.primary : Colors.grey),
        title: Text(isBound
            ? (boundState.value?['company']?.name ?? '已关联客户')
            : "点击选择关联客户"),
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

  Widget _buildSupplierHorizontalImages(BuildContext context,
      List<QuotationSample> prods, dynamic boundQuote, dynamic supplier) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: prods.length + 1,
        itemBuilder: (context, pIdx) {
          if (pIdx == 0) {
            return GestureDetector(
              onTap: () => context.router.push(QuoteProductNewAddRoute(
                  quoteId: boundQuote?['id'],
                  supplierId: supplier?.id?.toString())),
              child: Container(
                width: 72,
                height: 72,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1))),
                child: Icon(Icons.add,
                    color: Theme.of(context).colorScheme.primary, size: 24),
              ),
            );
          }
          final sample = prods[pIdx - 1].showroomSample;
          final img = (sample?.image?.isNotEmpty ?? false)
              ? sample!.image![0].url
              : null;
          return Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.05))),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: img != null
                    ? Image.network(img, fit: BoxFit.cover)
                    : const Icon(Icons.image_outlined,
                        color: Colors.grey, size: 20)),
          );
        },
      ),
    );
  }

  // --- 修正后的添加产品遮罩层逻辑 ---
  Widget _buildProductAddSection(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>?> quote,
      ValueNotifier<Map<String, dynamic>?> supplier,
      ColorScheme colors) {
    final isReady = supplier.value != null;
    return Stack(
      children: [
        Column(children: [
          // 如果已选择供应商，显示信息条
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
          // 实际的录入页面
          SizedBox(
              height: 500,
              child: QuoteProductNewAddPage(
                  isEmbedded: true,
                  quoteId: quote.value?['id'],
                  supplierId: supplier.value?['id']?.toString())),
        ]),
        // --- 遮罩层核心逻辑 ---
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

  Widget _buildEmpty(String txt) => Center(
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(txt, style: const TextStyle(color: Colors.grey))));
}

// 预选信息弹窗
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
              if (result != null) selectedQuote.value = result;
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
              if (result != null) selectedSupplier.value = result;
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
              if (selectedSupplier.value != null) Navigator.pop(context);
            },
            child: const Text("确定", style: TextStyle(color: Colors.white)),
          ),
        ]),
      );
    }),
  );
}
