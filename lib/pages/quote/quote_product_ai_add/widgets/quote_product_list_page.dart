import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    // 定义内部状态，用于存储选择的结果
    final selectedQuote = useState<Map<String, dynamic>?>(initialQuote);
    final selectedSupplier = useState<Map<String, dynamic>?>(initialSupplier);

    final isExpandedFloor = useState<bool>(true);

    final currentTemplate = useState<TemplateOption>(kQuoteAiTemplates[0]);

    useEffect(() {
      selectedQuote.value = initialQuote;
    }, [initialQuote]);

    useEffect(() {
      selectedSupplier.value = initialSupplier;
    }, [initialSupplier]);

    Future<void> handleNavigation() async {
      // 1. 判断是否已选供应商，未选则弹窗
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

      // 2. 检查是否挂载并执行跳转
      if (!context.mounted) return;
      if (selectedSupplier.value != null) {
        final sId = selectedSupplier.value?['id']?.toString();
        final qId = selectedQuote.value?['id'];

        // 路由跳转
        context.router
            .push(QuoteProductNewAddRoute(quoteId: qId, supplierId: sId));
      }
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

    final tabBarView = TabBarView(
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
        //白板
        Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              _buildCollapsibleTemplateSelector(
                context,
                currentTemplate.value,
                kQuoteTemplates: kQuoteAiTemplates,
                isExpanded: isExpandedFloor,
                colorScheme: colorScheme,
                onSelect: (newId) {
                  final next =
                      kQuoteAiTemplates.firstWhere((e) => e.id == newId);
                  currentTemplate.value = next;
                },
                selectedQuote: selectedQuote,
                selectedSupplier: selectedSupplier,
                onChanged: onChanged,
                ref: ref,
                handleNavigation: handleNavigation,
              ),
              _buildInfoBar(colorScheme),

              //产品列表
            ],
          ),
        ),
        //记录本
        Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              _buildCollapsibleTemplateSelector(
                context,
                currentTemplate.value,
                kQuoteTemplates: kQuoteAiNotePadTemplates,
                isExpanded: isExpandedFloor,
                colorScheme: colorScheme,
                onSelect: (newId) {
                  final next =
                      kQuoteAiNotePadTemplates.firstWhere((e) => e.id == newId);
                  currentTemplate.value = next;
                },
                selectedQuote: selectedQuote,
                selectedSupplier: selectedSupplier,
                onChanged: onChanged,
                ref: ref,
                handleNavigation: handleNavigation,
              ),
              _buildInfoBar(colorScheme),

              //产品列表
            ],
          ),
        ),
      ],
    );

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: tabBar,
        ),
        Expanded(child: tabBarView),
      ],
    );
  }
}

Future<void> _showPreSelectionSheet(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>?> selectedQuote,
    ValueNotifier<Map<String, dynamic>?> selectedSupplier,
    {required Function(
            Map<String, dynamic>? quote, Map<String, dynamic>? supplier)
        onChanged}) async {
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
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 4),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.dashboard_customize_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
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
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: isExpanded.value ? null : 0,
            child: Column(
              children: [
                _buildTemplateListContent(
                    context: context,
                    kQuoteTemplates: kQuoteTemplates,
                    currentId: currentTemplate.id,
                    colorScheme: colorScheme,
                    onSelect: onSelect,
                    selectedQuote: selectedQuote,
                    selectedSupplier: selectedSupplier,
                    onChanged: onChanged,
                    ref: ref,
                    handleNavigation: handleNavigation),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
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
  required ValueNotifier<Map<String, dynamic>?> selectedQuote,
  required ValueNotifier<Map<String, dynamic>?> selectedSupplier,
  required Function(
          Map<String, dynamic>? quote, Map<String, dynamic>? supplier)?
      onChanged,
  required WidgetRef ref,
  required Function() handleNavigation,
}) {
  const double kItemHeight = 92.0;
  return SizedBox(
    height: kItemHeight,
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
