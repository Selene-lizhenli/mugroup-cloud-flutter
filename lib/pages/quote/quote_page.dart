import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_new_add_page.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/supply.dart';
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

    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);
    final supplierList = useState<List<Supplier>>([]);

    final selectedQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    final boundQuoteForSupplier = useState<Map<String, dynamic>?>(null);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    final lastSearch = useRef('');

    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();

      // 1. 准备带客记录参数
      final quoteParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "20",
        "type": "market",
      };

      // 2. 准备供应商参数
      final supplierParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "20",
      };

      try {
        // 并行请求两个接口，提高效率
        final results = await Future.wait([
          getShowroomQuotation(quoteParams),
          getSupplySuppliers(queryParameters: supplierParams),
        ]);

        if (context.mounted) {
          // 更新带客记录
          final quoteData = results[0] as dynamic; // 根据实际返回类型强转
          list.value = quoteData.data;

          // 更新供应商列表
          final supplierData = results[1] as dynamic; // 根据实际返回类型强转
          supplierList.value = supplierData.data;
        }
      } catch (e) {
        debugPrint("Error fetching data: $e");
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "带客记录",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              QuoteSearchBar(controller: searchController),
              _buildSectionCard(
                context,
                title: "带客记录",
                icon: Icons.access_time_filled_rounded,
                iconColor: Colors.blueAccent,
                action: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.refresh,
                          color: Colors.grey[600], size: 22),
                      tooltip: "刷新",
                      onPressed: fetchData,
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.add_circle_outline,
                          color: colorScheme.primary, size: 22),
                      tooltip: "新增",
                      onPressed: () => context.router.push(QuoteCreateRoute()),
                    ),
                  ],
                ),
                content: _buildRecentRecordsContent(
                    context, isLoading.value, list.value),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "店铺列表",
                icon: Icons.list_alt_rounded,
                iconColor: Colors.orangeAccent,
                action: ActionPillButton(
                  label: '供应商',
                  icon: Icons.add,
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onSecondary,
                  onTap: () {
                    final boundQuote = boundQuoteForSupplier.value;

                    if (boundQuote == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("请先在下方选择关联的带客记录"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AddSupplierSheet(
                        quotationId: boundQuote['id'],
                      ),
                    );
                  },
                ),
                content: Column(
                  children: [
                    _buildBoundQuoteBar(context, boundQuoteForSupplier),
                    _buildDetailList(context, isLoading.value,
                        supplierList.value, boundQuoteForSupplier.value),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "添加产品",
                icon: Icons.grid_view_rounded,
                iconColor: Colors.purpleAccent,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const QuoteSelect(),
                        );
                        if (result != null) {
                          selectedQuote.value = result;
                        }
                      },
                      child: AbsorbPointer(
                        child: Input(
                          label: '带客记录',
                          showClearButton: false,
                          isRequired: true,
                          value: selectedQuote.value == null
                              ? ''
                              : (selectedQuote.value?['company']?.name ?? ''),
                          hintText: '请选择带客记录',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await showModalBottomSheet<Map<String, dynamic>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SupplierSelect(),
                        );
                        if (result != null) {
                          selectedSupplier.value = result;
                        }
                      },
                      child: AbsorbPointer(
                        child: Input(
                          label: '供应商',
                          showClearButton: false,
                          isRequired: true,
                          value: selectedSupplier.value == null
                              ? ''
                              : (selectedSupplier.value?['short_name'] ??
                                  selectedSupplier.value?['name'] ??
                                  ''),
                          hintText: '请选择供应商',
                        ),
                      ),
                    ),
                    const Divider(
                        height: 24, thickness: 0.5, indent: 16, endIndent: 16),
                    SizedBox(
                      height: 600,
                      child: QuoteProductNewAddPage(
                        isEmbedded: true,
                        quoteId: selectedQuote.value?['id'],
                        supplierId: selectedSupplier.value?['id'].toString(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (action != null) action,
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildBoundQuoteBar(
      BuildContext context, ValueNotifier<Map<String, dynamic>?> boundState) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBound = boundState.value != null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        // 未绑定显示浅灰，绑定显示主题色背景
        color: isBound
            ? colorScheme.primary.withOpacity(0.08)
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          // 绑定后显示边框
          color: isBound
              ? colorScheme.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final result = await showModalBottomSheet<Map<String, dynamic>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const QuoteSelect(),
            );
            if (result != null) {
              boundState.value = result;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isBound ? Icons.link_rounded : Icons.link_off_rounded,
                  size: 20,
                  color: isBound ? colorScheme.primary : Colors.grey[500],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBound ? "当前关联记录" : "未关联带客记录",
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isBound ? colorScheme.primary : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBound
                            ? (boundState.value?['company']?.name ?? '未知客户')
                            : "点击选择以添加带客记录",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isBound ? FontWeight.bold : FontWeight.normal,
                          color: isBound ? Colors.black87 : Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 20,
                  color: isBound ? colorScheme.primary : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRecordsContent(
      BuildContext context, bool isLoading, List<QuotationList> list) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text("暂无近期记录",
                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }

    final displayList = list.take(2).toList();

    return Column(
      children: [
        ...displayList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: QuoteCard(
              item: item,
              tabIndex: 0,
              onTap: () {
                final tempId = item.id;
                if (tempId == null) return;
                context.router.push(QuoteDetailRoute(id: tempId));
              },
            ),
          );
        }),
        if (displayList.isNotEmpty) ...[
          Divider(height: 1, thickness: 0.5, color: Colors.grey[100]),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("跳转全部记录页面")),
              );
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "查看全部",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_right_rounded,
                      size: 18, color: Colors.grey[500]),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailList(
      BuildContext context,
      bool isLoading,
      List<Supplier> supplierList,
      Map<String, dynamic>? boundQuoteForSupplier) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (supplierList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          "暂无数据详情",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      );
    }

    final detailList = supplierList.take(2).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: detailList.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final item = detailList[index];
        return _buildDetailRowItem(context, item, boundQuoteForSupplier);
      },
    );
  }

  Widget _buildDetailRowItem(BuildContext context, Supplier item,
      Map<String, dynamic>? boundQuoteForSupplier) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    final boundQuote = boundQuoteForSupplier;

                    if (boundQuote == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("请先在下方选择关联的带客记录"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final quoteId = boundQuote['id'];
                    final supplierId = item.id;
                    if (quoteId != null && supplierId != null) {
                      context.router.push(
                        SupplierProductsRoute(
                          quotationId: boundQuote['id'],
                          supplierId: supplierId,
                          supplierNo: item.supplierNo ?? '',
                          supplierName: item.name ?? '',
                          companyName: boundQuote['company'].name ?? '',
                        ),
                      );
                    }
                  },
                  child: Text(
                    item.name ?? '无店铺名称',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 80),
                      child: Text(
                        item.supplierNo ?? '暂无',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 1,
                        height: 10,
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${item.address}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionPillButton(
                label: '产品',
                icon: Icons.add,
                backgroundColor: colorScheme.primary,
                textColor: Colors.white,
                onTap: () async {
                  final boundQuote = boundQuoteForSupplier;

                  if (boundQuote == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("请先在下方选择关联的带客记录"),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  final supplierId = item.id;
                  await context.router.push(
                    QuoteProductNewAddRoute(
                      quoteId: boundQuote['id'],
                      supplierId: supplierId?.toString(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
