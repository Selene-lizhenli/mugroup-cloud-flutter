import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_new_add_page.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class QuotePage extends HookConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    useAutomaticKeepAlive(wantKeepAlive: true);

    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);
    final selectedQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    final lastSearch = useRef('');

    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();

      final paramsData = {
        "search": searchText,
        "page": "1",
        "pageSize": "20",
        "type": "market",
        // 如果有 quoteAt 逻辑，可以在这里加
      };

      try {
        final newData = await getShowroomQuotation(paramsData);

        if (context.mounted) {
          list.value = newData.data;
          isLoading.value = false;
        }
      } catch (e) {
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
                title: "近期记录",
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
                title: "带客记录详情",
                icon: Icons.list_alt_rounded,
                iconColor: Colors.orangeAccent,
                content: _buildDetailList(context, isLoading.value, list.value),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "创建产品",
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
              const SizedBox(height: 40),
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

    final displayList = list.take(3).toList();

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
      BuildContext context, bool isLoading, List<QuotationList> list) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          "暂无数据详情",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      );
    }

    final detailList = list.take(3).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: detailList.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final item = detailList[index];
        return _buildDetailRowItem(context, item);
      },
    );
  }

  Widget _buildDetailRowItem(BuildContext context, QuotationList item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.company?.name ?? '无客户名称',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 80),
                      child: Text(
                        "外销员: ${item.creator?.name ?? '暂无'}",
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
                        item.createdAt != null
                            ? DateFormat('yyyy-MM-dd').format(item.createdAt!)
                            : '--',
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
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: () {
                    // 逻辑
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "添加供应商",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: FilledButton(
                  onPressed: () {
                    // 逻辑
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "从供应商导入",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
