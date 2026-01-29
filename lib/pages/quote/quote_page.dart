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

    final isLoading = useState(true);
    final list = useState<List<QuotationList>>([]);

    final quoteSampleSupplierList = useState<List<QuotationSample>>([]);

    final selectedQuote = useState<Map<String, dynamic>?>(null);
    final selectedSupplier = useState<Map<String, dynamic>?>(null);

    final boundQuoteForSupplier = useState<Map<String, dynamic>?>(null);

    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    final lastSearch = useRef('');

    Future<void> fetchData() async {
      isLoading.value = true;
      final searchText = searchController.text.trim();

      final quoteParams = {
        "search": searchText,
        "page": "1",
        "pageSize": "20",
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

    useEffect(() {
      void fetchData() async {
        final boundQuote = boundQuoteForSupplier.value;
        if (boundQuote?['id'] == null) return;
        final params = {
          "page": '1',
          "pageSize": 100000000,
        };
        final resp =
            await getQuotationProductListByProductId(boundQuote?['id'], params);
        quoteSampleSupplierList.value = resp.data;
      }

      fetchData();
    }, [boundQuoteForSupplier.value]);

    // 将列表按供应商名称分组
    final groupedData = useMemoized(() {
      Map<String, List<QuotationSample>> groups = {};

      for (var item in quoteSampleSupplierList.value) {
        final supplierName = item.supplyQuote?.supplier?.shortName ??
            item.supplyQuote?.supplier?.name ??
            '未知供应商';

        if (!groups.containsKey(supplierName)) {
          groups[supplierName] = [];
        }
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
                action: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActionPillButton(
                      label: '新增店铺',
                      // icon: Icons.add,
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
                    const SizedBox(width: 10),
                    ActionPillButton(
                      label: '关联店铺',
                      // icon: Icons.add,
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

                        context.router.push(
                          ProductBatchImportRoute(
                            quotationId: boundQuote['id'],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    _buildBoundQuoteBar(context, boundQuoteForSupplier),
                    _buildDetailList(context, isLoading.value, groupedData,
                        boundQuoteForSupplier.value),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                context,
                title: "添加产品",
                icon: Icons.grid_view_rounded,
                iconColor: Colors.purpleAccent,
                content: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedQuote.value != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                                "当前录入：${selectedQuote.value?['company']?.name} - ${selectedSupplier.value?['name']}",
                                style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold)),
                          ),
                        const Divider(
                            height: 1,
                            thickness: 0.5,
                            indent: 16,
                            endIndent: 16),
                        SizedBox(
                          height: 600,
                          child: QuoteProductNewAddPage(
                            isEmbedded: true,
                            quoteId: selectedQuote.value?['id'],
                            supplierId:
                                selectedSupplier.value?['id'].toString(),
                          ),
                        ),
                      ],
                    ),

                    // --- 关键拦截层 ---
                    // 如果还没选好，盖一层透明层在上面，点击即弹出刚才定义的选择框
                    if (selectedQuote.value == null ||
                        selectedSupplier.value == null)
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showPreSelectionSheet(
                              context, selectedQuote, selectedSupplier),
                          child: Container(
                            color: Colors.white.withOpacity(0.5), // 稍微变灰，提示不可用
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app,
                                      size: 40, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text("点击完善关联信息后开始录入",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
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

  Widget _buildDetailList(BuildContext context, bool isLoading,
      Map<String, List<QuotationSample>> groupedSuppliers, dynamic boundQuote) {
    if (isLoading) {
      return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CupertinoActivityIndicator()));
    }
    if (groupedSuppliers.isEmpty) {
      return const Center(
          child: Padding(padding: EdgeInsets.all(20), child: Text("暂无供应商数据")));
    }

    final colorScheme = Theme.of(context).colorScheme;
    final supplierNames = groupedSuppliers.keys.toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: supplierNames.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final name = supplierNames[index];
        final List<QuotationSample> products = groupedSuppliers[name]!;

        final supplier = products.first.supplyQuote?.supplier;
        if (supplier == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (boundQuote == null) {
                              _showError(context, "请先选择关联的带客记录");
                              return;
                            }
                            context.router.push(SupplierProductsRoute(
                              quotationId: boundQuote['id'],
                              supplierId: supplier.id!,
                              supplierNo: supplier.supplierNo ?? '',
                              supplierName: supplier.name ?? '',
                              companyName: boundQuote['company'].name ?? '',
                            ));
                          },
                          child: Text(
                            supplier.name ?? '无店铺名称',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(supplier.supplierNo ?? '暂无',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ActionPillButton(
                    label: '产品',
                    icon: Icons.add,
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    onTap: () async {
                      if (boundQuote == null) {
                        _showError(context, "请先选择关联的带客记录");
                        return;
                      }
                      await context.router.push(QuoteProductNewAddRoute(
                        quoteId: boundQuote['id'],
                        supplierId: supplier.id?.toString(),
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, pIndex) {
                    final prod = products[pIndex];
                    final imageUrl =
                        (prod.showroomSample?.image?.isNotEmpty ?? false)
                            ? prod.showroomSample!.image![0].url
                            : null;

                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null
                            ? Image.network(imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image,
                                        size: 20, color: Colors.grey))
                            : const Icon(Icons.image_outlined,
                                size: 20, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// 提取的错误提示辅助方法
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }
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
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      // 使用 HookConsumer 局部刷新弹窗内的 UI
      return HookConsumer(builder: (context, ref, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("完善录入信息",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // --- 带客记录选择 ---
              GestureDetector(
                onTap: () async {
                  final result =
                      await showModalBottomSheet<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => const QuoteSelect(),
                  );
                  if (result != null) selectedQuote.value = result;
                },
                child: AbsorbPointer(
                  child: Input(
                    label: '带客记录',
                    isRequired: true,
                    value: selectedQuote.value?['company']?.name ?? '',
                    hintText: '请选择带客记录',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // --- 供应商选择 ---
              GestureDetector(
                onTap: () async {
                  final result =
                      await showModalBottomSheet<Map<String, dynamic>>(
                    context: context,
                    builder: (_) => const SupplierSelect(),
                  );
                  if (result != null) selectedSupplier.value = result;
                },
                child: AbsorbPointer(
                  child: Input(
                    label: '供应商',
                    isRequired: true,
                    value: selectedSupplier.value?['short_name'] ??
                        selectedSupplier.value?['name'] ??
                        '',
                    hintText: '请选择供应商',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (selectedQuote.value != null &&
                      selectedSupplier.value != null) {
                    Navigator.pop(context); // 选好了，关闭弹窗
                  }
                },
                child: const Text("确定"),
              ),
            ],
          ),
        );
      });
    },
  );
}
