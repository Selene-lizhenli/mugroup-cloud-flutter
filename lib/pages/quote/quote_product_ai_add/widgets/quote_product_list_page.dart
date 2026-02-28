import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/supply.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud/helper/helper.dart';

final quotePageProductRefresh = StateProvider.autoDispose<int>((ref) => 0);

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

    // 1. 基础状态：通过 initialValue 初始化，并通过 useEffect 同步
    final selectedQuote = useState<Map<String, dynamic>?>(initialQuote);
    final selectedSupplier = useState<Map<String, dynamic>?>(initialSupplier);
    final isExpandedFloor = useState<bool>(true);
    final currentTemplate = useState<TemplateOption>(kQuoteAiTemplates[0]);

    // 实时同步父组件的变化
    useEffect(() {
      selectedQuote.value = initialQuote;
      return null;
    }, [initialQuote]);

    useEffect(() {
      selectedSupplier.value = initialSupplier;
      return null;
    }, [initialSupplier]);

    // 2. 产品列表分页状态
    final products = useState<List<ProductDraftItem>>(<ProductDraftItem>[]);
    final isLoading = useState<bool>(false);
    final hasMore = useState<bool>(true);
    final scrollController = useScrollController();

    Future<void> fetchProducts({bool isRefresh = false}) async {
      final quoteId = selectedQuote.value?['id'];

      if (quoteId == null) {
        products.value = <ProductDraftItem>[];
        isLoading.value = false;
        hasMore.value = false;
        return;
      }

      if (isLoading.value && !isRefresh) return;
      isLoading.value = true;

      try {
        final resp = await getQuotationProductListByProductId(
          quoteId,
          {"page": '1', "pageSize": 1000},
        );

        if (!context.mounted) return;

        final List<dynamic> dataList = resp.data ?? [];

        final List<ProductDraftItem> mappedItems =
            dataList.map<ProductDraftItem>((e) {
          final item = e is QuotationSample ? e : QuotationSample.fromJson(e);
          final sample = item.showroomSample;
          final quote = item.supplyQuote;

          return ProductDraftItem(
            data: {
              'product_id': sample?.id,
              'supply_quote_id': quote?.id,
              'product_no': sample?.productNo ?? item.customerProductNo,
              'purchase_cost':
                  item.price ?? quote?.purchaseCost ?? sample?.purchaseCost,
              'outer_capacity': quote?.outerCapacity,
              'description_cn': sample?.descriptionCn,
              'spec': sample?.spec,
              'unit': sample?.unit,
              'product_weight': quote?.productWeight,
              'packing': sample?.packing,
              'outer_volume': quote?.outerVolume,
              'supplier_id': quote?.supplierId?.toString(),
            },
            media: Media(
              url: sample?.image?.elementAtOrNull(0)?.url ?? '',
              thumbUrl: sample?.cover ?? '',
            ),
            isRecognizing: false,
          );
        }).where((item) {
          if (selectedSupplier.value != null) {
            final selectedId = selectedSupplier.value!['id']?.toString();
            return item.data['supplier_id'] == selectedId;
          }
          return true;
        }).toList();

        products.value = mappedItems;
        hasMore.value = false;
      } catch (e) {
        logger.e("加载列表失败: $e");
        if (context.mounted) EasyLoading.showError("数据加载失败");
      } finally {
        if (context.mounted) isLoading.value = false;
      }
    }

    // 3. 监听关键 ID 变化触发数据加载
    useEffect(() {
      fetchProducts(isRefresh: true);
      return null;
    }, [selectedQuote.value?['id'], selectedSupplier.value?['id']]);

    // 滚动监听
    useEffect(() {
      void listener() {
        if (scrollController.hasClients &&
            scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200) {
          fetchProducts();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, []);

    // 4. 统一跳转与弹窗逻辑
    Future<void> handleNavigation() async {
      final currentTabIndex = tabController.index;

      if (selectedSupplier.value == null) {
        await _showPreSelectionSheet(
          context,
          selectedQuote,
          selectedSupplier,
          currentTabIndex: currentTabIndex,
          onChanged: (quote, supplier) {
            onChanged?.call(quote, supplier);
          },
        );
      }
      if (!context.mounted) return;
      if (selectedSupplier.value != null) {
        final sId = selectedSupplier.value?['id']?.toString();
        final qId = selectedQuote.value?['id'];
        context.router.push(QuoteProductNewAddRoute(
          quoteId: qId,
          supplierId: sId,
          initialTabIndex: currentTabIndex,
        ));
      }
    }

    ref.listen(quotePageProductRefresh, (previous, next) async {
      if (next > 0) {
        debugPrint("模拟重新进入页面2222...");

        // 1. 执行主列表刷新
        await fetchProducts(isRefresh: true);
      }
    });

    // 5. UI 构建逻辑
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => fetchProducts(isRefresh: true),
                child: ListView.separated(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
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
                          final newList = [...products.value];
                          newList[index].data[key] = val;
                          products.value = newList;
                        },
                        () {
                          final newList = [...products.value];
                          newList.removeAt(index);
                          products.value = newList;
                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: hasMore.value && isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
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
      tabs: const [Tab(text: "手动录入"), Tab(text: "白板识别"), Tab(text: "记录本识别")],
    );

    return Column(
      children: [
        Container(color: Colors.white, child: tabBar),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
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
              buildRecognizeTab(kQuoteAiTemplates),
              buildRecognizeTab(kQuoteAiNotePadTemplates),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(
      BuildContext context,
      int index,
      ProductDraftItem item,
      TemplateOption template,
      Function(String key, String val) onUpdate,
      VoidCallback onDelete) {
    const double rowHeight = 72.0;

    int? parseId(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      final s = v.toString().trim();
      return int.tryParse(s);
    }

    const Set<String> showroomFields = {'product_no', 'spec', 'description_cn'};

    Future<bool> updateRemoteField(
        {required String fieldKey, required dynamic value}) async {
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
              ]),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    showFlanImagePreview(context, images: [item.media.url]),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[300]!)),
                    clipBehavior: Clip.antiAlias,
                    child: item.isRecognizing
                        ? const Center(
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)))
                        : Image.network(item.media.thumbUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(
                                Icons.broken_image,
                                color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                              'outer_volume',
                              'inner_capacity', // 建议把相关的都加上
                              'weight',
                              'moq',
                            };

                            final bool isNumberField =
                                numberKeys.contains(col.key);

                            EditDialog.show(context,
                                title: col.label,
                                initialText: isEmpty ? '' : text,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return '${col.label}不能为空';
                                  }

                                  if (isNumberField) {
                                    // 使用正则匹配数字（支持整数和小数）
                                    final reg = RegExp(r'^\d+(\.\d+)?$');
                                    if (!reg.hasMatch(value)) {
                                      return '请输入正确的数字格式'; // 这里返回错误提示语
                                    }
                                  }
                                  return null; // 返回 null 表示校验通过
                                },
                                keyboardType: isNumberField
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true)
                                    : TextInputType.text,
                                onConfirm: (v) async {
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
                                    overflow: TextOverflow.ellipsis)
                              ]),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _showPreSelectionSheet(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>?> externalQuote,
    ValueNotifier<Map<String, dynamic>?> externalSupplier,
    {required int currentTabIndex,
    required Function(
            Map<String, dynamic>? quote, Map<String, dynamic>? supplier)
        onChanged}) async {
  String getSafeName(dynamic data, List<String> keys) {
    if (data == null) return '';
    if (data is Map) {
      for (var key in keys) {
        if (data[key] != null) return data[key].toString();
      }
    }
    try {
      final mapData = data.toJson();
      for (var key in keys) {
        if (mapData[key] != null) return mapData[key].toString();
      }
    } catch (e) {
      if (keys.contains('name')) {
        try {
          return data.name.toString();
        } catch (_) {}
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
      // 【核心】：在弹窗内部维护临时选中的状态，不直接改外部
      final tempQuote = useState<Map<String, dynamic>?>(externalQuote.value);
      final tempSupplier =
          useState<Map<String, dynamic>?>(externalSupplier.value);

      final companyName = getSafeName(tempQuote.value?['company'], ['name']);
      final supplierName =
          getSafeName(tempSupplier.value, ['short_name', 'name']);

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
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: const QuoteSelect(),
                    );
                  },
                );

                if (result != null && context.mounted) {
                  tempQuote.value = result; // 仅修改弹窗内预览
                }
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
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: const SupplierSelect(),
                    );
                  },
                );

                if (result != null && context.mounted) {
                  tempSupplier.value = result; // 仅修改弹窗内预览
                }
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
                if (tempSupplier.value != null) {
                  onChanged(tempQuote.value, tempSupplier.value);

                  if (tempSupplier.value != null) {
                    final sId = tempSupplier.value?['id']?.toString();
                    final qId = tempQuote.value?['id'];
                    context.router.push(
                        QuoteProductNewAddRoute(quoteId: qId, supplierId: sId));
                  }
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
                Expanded(
                  child: Text(
                    '识别模板 (点击卡片内眼睛图标查看示例模板)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var config in t.columns)
                            if (config.key == 'product_no')
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
                                    child: Icon(
                                      Icons.visibility_outlined,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  config.label,
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        ],
                      ),
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
                      borderRadius: BorderRadius.circular(6)),
                  child: const Center(
                      child: Icon(Icons.camera_alt_rounded,
                          color: Color(0xFF999999), size: 28)),
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
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      children: [
        Icon(Icons.auto_awesome, color: colorScheme.secondary, size: 16),
        const SizedBox(width: 8),
        Expanded(
            child: Text('AI识别结果点击下方单元格可手动修正',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.secondary, fontSize: 12))),
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
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              padding: const EdgeInsets.all(8),
              child: Image.asset(imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.broken_image, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('暂无预览图',
                            style: TextStyle(color: Colors.grey, fontSize: 12))
                      ])))),
            ),
          ),
        ),
      );
    },
  );
}
