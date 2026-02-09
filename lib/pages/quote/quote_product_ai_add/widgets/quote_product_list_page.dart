import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/supply.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud/helper/helper.dart';

class ProductDraftItem {
  final Map<String, dynamic> data;
  final dynamic media;
  final bool isRecognizing;

  ProductDraftItem(
      {required this.data, this.media, this.isRecognizing = false});

  String getValue(String key) => data[key]?.toString() ?? '-';
}

class QuoteProductListPage extends HookConsumerWidget {
  final Map<String, dynamic>? initialQuote;
  final Map<String, dynamic>? initialSupplier;
  final Function(Map<String, dynamic>? quote, Map<String, dynamic>? supplier)?
      onChanged;

  const QuoteProductListPage(
      {super.key, this.initialQuote, this.initialSupplier, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabController = useTabController(initialLength: 3, initialIndex: 1);

    // 1. 基础状态
    final selectedQuote = useState<Map<String, dynamic>?>(initialQuote);
    final selectedSupplier = useState<Map<String, dynamic>?>(initialSupplier);
    final isExpandedFloor = useState<bool>(true);
    final currentTemplate = useState<TemplateOption>(kQuoteAiTemplates[0]);

    // 2. 产品列表分页状态
    final products = useState<List<ProductDraftItem>>([]);
    final page = useState<int>(1);
    const pageSize = 5; // 初始步长
    final isLoading = useState<bool>(false);
    final hasMore = useState<bool>(true);
    final scrollController = useScrollController();

    // 3. 加载数据逻辑
    Future<void> fetchProducts({bool isRefresh = false}) async {
      if (isLoading.value || (!isRefresh && !hasMore.value)) return;
      isLoading.value = true;
      if (isRefresh) {
        page.value = 1;
        hasMore.value = true;
      }

      try {
        final queryParameters = {
          "page": page.value,
          "pageSize": pageSize,
          "includes": 'supplyQuotes.supplier',
          "item_type": "market_product",
        };

        // 调用你的 API
        final resp = await getSamples(queryParameters: queryParameters);

        // 将 Sample 转换为 ProductDraftItem
        final List<ProductDraftItem> newItems = (resp.data ?? []).map((sample) {
          // 提取供应商报价 ID，假设取第一个
          final firstQuote = sample.supplyQuotes?.elementAtOrNull(0);

          logger.d(firstQuote);

          return ProductDraftItem(
            data: {
              'product_id': sample.id,
              'supply_quote_id': firstQuote?.id,
              'product_no': sample.productNo,
              'outer_capacity': firstQuote?.outerCapacity,
              'description_cn': sample.descriptionCn,
              'purchase_cost':
                  firstQuote?.purchaseCost ?? sample.purchaseCost, // 优先取报价单价格
              'inner_capacity': firstQuote?.outerCapacity,
              "packing": sample.packing,
              "outer_volume": firstQuote?.outerVolume,
            },
            // 映射媒体文件，使用 Sample 里的 cover 逻辑
            media: Media(
              url: sample.image?.elementAtOrNull(0)?.url ?? '',
              thumbUrl: sample.cover ?? '',
            ),
            isRecognizing: false,
          );
        }).toList();

        if (isRefresh) {
          products.value = newItems;
        } else {
          products.value = [...products.value, ...newItems];
        }

        // 根据返回长度判断是否还有下一页
        hasMore.value = newItems.length == pageSize;
        page.value++;
      } catch (e) {
        EasyLoading.showError("加载数据失败: $e");
      } finally {
        isLoading.value = false;
      }
    }

    // 4. 初始化加载及滚动监听
    useEffect(() {
      fetchProducts(isRefresh: true);
      void listener() {
        // 滑动到距离底部 200 像素时加载更多
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          fetchProducts();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, []);

    useEffect(() {
      selectedQuote.value = initialQuote;
    }, [initialQuote]);

    useEffect(() {
      selectedSupplier.value = initialSupplier;
    }, [initialSupplier]);

    // 5. 统一跳转逻辑
    Future<void> handleNavigation() async {
      if (selectedSupplier.value == null) {
        await _showPreSelectionSheet(
          context,
          selectedQuote,
          selectedSupplier,
          onChanged: (quote, supplier) {
            selectedQuote.value = quote;
            selectedSupplier.value = supplier;
            onChanged?.call(quote, supplier);
          },
        );
      }
      if (!context.mounted) return;
      if (selectedSupplier.value != null) {
        final sId = selectedSupplier.value?['id']?.toString();
        final qId = selectedQuote.value?['id'];
        context.router
            .push(QuoteProductNewAddRoute(quoteId: qId, supplierId: sId));
      }
    }

    // 6. 构建识别列表页（白板/记录本通用）
    Widget buildRecognizeTab(List<TemplateOption> templates) {
      return Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            _buildCollapsibleTemplateSelector(
              context,
              currentTemplate.value,
              kQuoteTemplates: templates,
              isExpanded: isExpandedFloor,
              colorScheme: colorScheme,
              onSelect: (newId) {
                final next = templates.firstWhere((e) => e.id == newId);
                currentTemplate.value = next;
              },
              selectedQuote: selectedQuote,
              selectedSupplier: selectedSupplier,
              onChanged: onChanged,
              ref: ref,
              handleNavigation: handleNavigation,
            ),
            _buildInfoBar(colorScheme),
            // 产品列表区域
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => fetchProducts(isRefresh: true),
                child: ListView.separated(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: products.value.length + 1,
                  separatorBuilder: (c, i) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index < products.value.length) {
                      final item = products.value[index];
                      return _buildDataRow(
                        context,
                        index,
                        item,
                        currentTemplate.value,
                        (key, val) {
                          // 更新本地数据状态
                          final newList = [...products.value];
                          newList[index].data[key] = val;
                          products.value = newList;
                        },
                        () {
                          // 删除本地数据状态
                          final newList = [...products.value];
                          newList.removeAt(index);
                          products.value = newList;
                        },
                      );
                    } else {
                      // 底部加载更多提示
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: hasMore.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("没有更多数据了",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    final tabBar = TabBar(
      controller: tabController,
      labelColor: colorScheme.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(text: "手动录入"),
        Tab(text: "白板识别"),
        Tab(text: "记录本识别"),
      ],
    );

    return Column(
      children: [
        Container(color: Colors.white, child: tabBar),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              // Tab 1: 手动录入
              Stack(
                children: [
                  QuoteProductAddAdaptivePage(
                    initialMode: 0,
                    quoteId: selectedQuote.value?['id'],
                    supplierId: selectedSupplier.value?['id']?.toString(),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: handleNavigation,
                    ),
                  ),
                ],
              ),
              // Tab 2: 白板
              buildRecognizeTab(kQuoteAiTemplates),
              // Tab 3: 记录本
              buildRecognizeTab(kQuoteAiNotePadTemplates),
            ],
          ),
        ),
      ],
    );
  }

  // --- 您提供的数据展示行 (整合左右滚动和编辑) ---
  Widget _buildDataRow(
    BuildContext context,
    int index,
    ProductDraftItem item,
    TemplateOption template,
    Function(String key, String val) onUpdate,
    VoidCallback onDelete,
  ) {
    const double rowHeight = 72.0;

    int? parseId(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      final s = v.toString().trim();
      if (s.isEmpty || s == 'null') return null;
      return int.tryParse(s);
    }

    const Set<String> showroomFields = {'product_no', 'spec', 'description_cn'};

    Future<bool> updateRemoteField({
      required String fieldKey,
      required dynamic value,
    }) async {
      final int? productId = parseId(item.getValue('product_id'));
      final int? supplyQuoteId = parseId(item.getValue('supply_quote_id'));
      try {
        if (showroomFields.contains(fieldKey)) {
          if (productId == null) return false;
          await updateShowroomSample(productId, {fieldKey: value});
          return true;
        } else {
          if (supplyQuoteId == null) return false;
          await updateSupplyQuote(supplyQuoteId, {fieldKey: value});
          return true;
        }
      } catch (_) {
        return false;
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: rowHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1))
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // 图片预览
              GestureDetector(
                onTap: () {
                  showFlanImagePreview(context, images: [item.media.url]);
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: item.isRecognizing
                        ? const Center(
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)))
                        : (item.media?.thumbUrl != null)
                            ? Image.network(item.media.thumbUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey))
                            : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 数据列表 - 支持左右滚动
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: template.columns.map((col) {
                      final text = item.getValue(col.key);
                      final bool isEmpty = text == '-' || text.isEmpty;
                      return Container(
                        width: col.width,
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            const numberKeys = {
                              'purchase_cost',
                              'outer_capacity',
                              'inner_capacity',
                              'weight',
                              'outer_volume',
                              'moq'
                            };
                            final bool isNumberField =
                                numberKeys.contains(col.key);

                            EditDialog.show(context,
                                title: col.label,
                                initialText: isEmpty ? '' : text,
                                keyboardType: isNumberField
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true)
                                    : TextInputType.text, onConfirm: (v) async {
                              final success = await updateRemoteField(
                                  fieldKey: col.key, value: v);
                              if (!success) {
                                EasyLoading.showError('编辑失败');
                                return;
                              }
                              EasyLoading.showSuccess('编辑成功');
                              onUpdate(col.key, v);
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(col.label,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[500])),
                              Text(text,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isEmpty
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                      color: isEmpty
                                          ? Colors.grey[300]
                                          : const Color(0xFF333333)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 删除按钮
        Positioned(
          top: -5,
          left: -5,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// --- 弹窗逻辑 ---
Future<void> _showPreSelectionSheet(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>?> selectedQuote,
    ValueNotifier<Map<String, dynamic>?> selectedSupplier,
    {required Function(
            Map<String, dynamic>? quote, Map<String, dynamic>? supplier)
        onChanged}) async {
  String getSafeName(dynamic data, List<String> keys) {
    if (data == null) return '';
    if (data is Map) {
      for (var key in keys) {
        if (data[key] != null) return data[key].toString();
      }
    }
    return '';
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => HookConsumer(builder: (context, ref, child) {
      final currentQuote = useValueListenable(selectedQuote);
      final currentSupplier = useValueListenable(selectedSupplier);
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
            Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const Text("录入信息确认",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
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
                      showClearButton: false)),
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
                      label: '所属供应商',
                      isRequired: true,
                      value: supplierName,
                      hintText: '请选择供应商',
                      showClearButton: false)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                if (selectedSupplier.value != null) {
                  onChanged(selectedQuote.value, selectedSupplier.value);
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

Widget _buildCollapsibleTemplateSelector(
  BuildContext context,
  TemplateOption currentTemplate, {
  required List<TemplateOption> kQuoteTemplates,
  required ValueNotifier<bool> isExpanded,
  required ColorScheme colorScheme,
  required Function(String id) onSelect,
  required ValueNotifier<Map<String, dynamic>?> selectedQuote,
  required ValueNotifier<Map<String, dynamic>?> selectedSupplier,
  required Function(
          Map<String, dynamic>? quote, Map<String, dynamic>? supplier)?
      onChanged,
  required WidgetRef ref,
  required Function() handleNavigation,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.03),
          offset: const Offset(0, 2),
          blurRadius: 4)
    ]),
    child: Column(
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.dashboard_customize_outlined,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text('识别模板',
                        style: TextStyle(fontSize: 13, color: Colors.grey))),
                AnimatedRotation(
                    turns: isExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down)),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: isExpanded.value
              ? _buildTemplateListContent(
                  context: context,
                  kQuoteTemplates: kQuoteTemplates,
                  currentId: currentTemplate.id,
                  colorScheme: colorScheme,
                  onSelect: onSelect,
                  handleNavigation: handleNavigation,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

Widget _buildTemplateListContent({
  required BuildContext context,
  required List<TemplateOption> kQuoteTemplates,
  required String currentId,
  required ColorScheme colorScheme,
  required Function(String id) onSelect,
  required Function() handleNavigation,
}) {
  return SizedBox(
    height: 92,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: kQuoteTemplates.length,
      separatorBuilder: (c, i) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final t = kQuoteTemplates[index];
        final bool isSelected = t.id == currentId;
        return Container(
          width: 160,
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withOpacity(0.04)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(t.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var config in t.columns) ...[
                          if (config.key == 'product_no') ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    config.label,
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showPreviewDialog(
                                      context, t.previewImageUrl),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Icon(
                                      Icons.visibility_outlined,
                                      size: 20, // 大眼睛
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Text(
                              config.label,
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  width: 1, height: 40, color: Colors.grey.withOpacity(0.1)),
              GestureDetector(
                onTap: handleNavigation,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded,
                          color: Color(0xFF999999), size: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildInfoBar(ColorScheme colorScheme) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    decoration: BoxDecoration(
      color: colorScheme.primaryContainer.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.auto_awesome, color: colorScheme.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'AI识别结果点击下方单元格可手动修正',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showPreviewDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: InteractiveViewer(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('暂无预览图',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
