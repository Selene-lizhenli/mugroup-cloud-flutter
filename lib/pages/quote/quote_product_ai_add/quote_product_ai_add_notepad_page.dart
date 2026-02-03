import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 单个产品条目（一行数据）
class ProductDraftItem {
  final Map<String, String> data;

  ProductDraftItem({required this.data});

  ProductDraftItem copyWith({Map<String, String>? data}) {
    return ProductDraftItem(data: data ?? this.data);
  }

  String getValue(String key) => data[key] ?? '-';
}

class ImageProductGroup {
  final TemporaryMedia media;
  final List<ProductDraftItem> products;
  final bool isRecognizing;
  final bool isExpanded;

  ImageProductGroup({
    required this.media,
    required this.products,
    this.isRecognizing = false,
    this.isExpanded = true,
  });

  ImageProductGroup copyWith({
    TemporaryMedia? media,
    List<ProductDraftItem>? products,
    bool? isRecognizing,
    bool? isExpanded,
  }) {
    return ImageProductGroup(
      media: media ?? this.media,
      products: products ?? this.products,
      isRecognizing: isRecognizing ?? this.isRecognizing,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class ProductAiAddState {
  final List<ImageProductGroup> groups;
  final bool isGlobalLoading;
  final bool isSubmitting;
  final String currentTemplateId;

  ProductAiAddState({
    this.groups = const [],
    this.isGlobalLoading = false,
    this.isSubmitting = false,
    String? currentTemplateId,
  }) : currentTemplateId = currentTemplateId ?? kDefaultNotePadTemplateId;

  ProductAiAddState copyWith({
    List<ImageProductGroup>? groups,
    bool? isGlobalLoading,
    bool? isSubmitting,
    String? currentTemplateId,
  }) {
    return ProductAiAddState(
      groups: groups ?? this.groups,
      isGlobalLoading: isGlobalLoading ?? this.isGlobalLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      currentTemplateId: currentTemplateId ?? this.currentTemplateId,
    );
  }
}

class ProductAiAddController extends AutoDisposeNotifier<ProductAiAddState> {
  @override
  ProductAiAddState build() {
    return ProductAiAddState();
  }

  void changeTemplate(String templateId) {
    if (state.currentTemplateId == templateId) return;
    state = state.copyWith(currentTemplateId: templateId);
  }

  // --- 新增：删除整个组 ---
  void removeGroup(int index) {
    if (index >= state.groups.length) return;
    final newList = List<ImageProductGroup>.from(state.groups);
    newList.removeAt(index);
    state = state.copyWith(groups: newList);
  }

  // --- 新增：删除组内单个产品行 ---
  void removeProduct(int groupIndex, int productIndex) {
    if (groupIndex >= state.groups.length) return;
    final groups = List<ImageProductGroup>.from(state.groups);
    final group = groups[groupIndex];
    if (productIndex >= group.products.length) return;

    final newProducts = List<ProductDraftItem>.from(group.products);
    newProducts.removeAt(productIndex);

    groups[groupIndex] = group.copyWith(products: newProducts);
    state = state.copyWith(groups: groups);
  }

  // --- 修改：追加逻辑 ---
  Future<void> onImagesChanged(
      List<TemporaryMedia>? newImages, WidgetRef ref) async {
    final images = newImages ?? [];
    if (images.isEmpty) return;

    final currentGroups = state.groups;
    final int startIndex = currentGroups.length;

    // 创建新增的占位组
    final List<ImageProductGroup> addedGroups = images
        .map((img) => ImageProductGroup(
              media: img,
              products: [],
              isRecognizing: true,
            ))
        .toList();

    // 追加到末尾，不覆盖旧组
    state = state.copyWith(
      groups: [...currentGroups, ...addedGroups],
      isGlobalLoading: true,
    );

    // 异步处理OCR
    await _processOcrQueue(startIndex, images, ref);
  }

  Future<void> _processOcrQueue(
      int startIndex, List<TemporaryMedia> newImages, WidgetRef ref) async {
    final user = ref.read(userProvider).user;
    final currentTemplate = kQuoteAiNotePadTemplates.firstWhere(
      (t) => t.id == state.currentTemplateId,
      orElse: () => kQuoteAiNotePadTemplates.first,
    );

    for (var media in newImages) {
      final imageUrl = media.thumbUrl;
      List<ProductDraftItem> recognizedProducts = [];

      try {
        final result = await identifyOcr('ExtractQtnNbBasic', {
          "template_id": state.currentTemplateId,
          "department": user?.department?.name,
          "employee_name": user?.name,
          "employee_number": user?.jobNumber,
          "image": imageUrl,
        });

        if (result != null &&
            result['success'] == true &&
            result['data'] is List) {
          final dataList = result['data'] as List;
          for (var itemData in dataList) {
            Map<String, String> rowMap = {};
            for (var col in currentTemplate.columns) {
              String rawVal = (itemData[col.key] ?? '').toString().trim();
              rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
            }
            recognizedProducts.add(ProductDraftItem(data: rowMap));
          }
        }
      } catch (e) {
        debugPrint('OCR Error: $e');
      }

      if (recognizedProducts.isEmpty) {
        Map<String, String> emptyMap = {
          for (var col in currentTemplate.columns) col.key: '-'
        };
        recognizedProducts.add(ProductDraftItem(data: emptyMap));
      }

      // --- 安全更新逻辑 ---
      final latestGroups = List<ImageProductGroup>.from(state.groups);
      final targetIndex = latestGroups.indexWhere((g) => g.media == media);

      if (targetIndex != -1) {
        latestGroups[targetIndex] = latestGroups[targetIndex].copyWith(
          products: recognizedProducts,
          isRecognizing: false,
        );
        state = state.copyWith(groups: latestGroups);
      }
    }
    state = state.copyWith(isGlobalLoading: false);
  }

  void toggleGroupExpand(int groupIndex) {
    if (groupIndex >= state.groups.length) return;
    final newGroups = List<ImageProductGroup>.from(state.groups);
    final group = newGroups[groupIndex];
    newGroups[groupIndex] = group.copyWith(isExpanded: !group.isExpanded);
    state = state.copyWith(groups: newGroups);
  }

  void updateCell(int groupIndex, int productIndex, String key, String value) {
    if (groupIndex >= state.groups.length) return;
    final group = state.groups[groupIndex];
    if (productIndex >= group.products.length) return;
    final product = group.products[productIndex];
    final newData = Map<String, String>.from(product.data);
    newData[key] = value.isEmpty ? '-' : value;
    final newProducts = List<ProductDraftItem>.from(group.products);
    newProducts[productIndex] = product.copyWith(data: newData);
    final newGroups = List<ImageProductGroup>.from(state.groups);
    newGroups[groupIndex] = group.copyWith(products: newProducts);
    state = state.copyWith(groups: newGroups);
  }

  Future<bool> submitProducts(int? quoteId, String? supplierId) async {
    if (state.isSubmitting) return false;
    if (state.groups.any((g) => g.isRecognizing)) {
      EasyLoading.showToast('请等待所有图片识别完成');
      return false;
    }
    if (state.groups.isEmpty) {
      EasyLoading.showToast('请先上传图片');
      return false;
    }
    state = state.copyWith(isSubmitting: true);
    EasyLoading.show(status: '保存中...');
    try {
      final List<Map<String, dynamic>> submitList = [];
      for (var group in state.groups) {
        for (var product in group.products) {
          final row = product.data;
          String? val(String key) =>
              (row[key] == null || row[key] == '-') ? null : row[key];
          submitList.add({
            if (quoteId != null) "quotation_id": quoteId,
            if (quoteId != null) "quotation": {},
            'supply_quotes': [
              {
                "supplier_id": supplierId,
                'supplier_price': val('price'),
                'outer_capacity': val('out_carton'),
                'supplier_sku': val('item_no'),
              }
            ],
            'spec': val('size'),
            'description_cn': val('description'),
            'image': [group.media],
            'item_type': 'market_product'
          });
        }
      }
      await batchStoreShowroomSample({'products': submitList});
      EasyLoading.showSuccess('保存成功');
      clear();
      return true;
    } catch (e) {
      EasyLoading.showError('保存失败: $e');
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  void clear() {
    state = ProductAiAddState();
  }
}

final productAiAddProvider =
    NotifierProvider.autoDispose<ProductAiAddController, ProductAiAddState>(
        ProductAiAddController.new);

@RoutePage()
class QuoteProductAiAddNotepadPage extends HookConsumerWidget {
  final int? quoteId;
  final String? supplierId;
  const QuoteProductAiAddNotepadPage(
      {super.key, this.quoteId, this.supplierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final providerState = ref.watch(productAiAddProvider);
    final controller = ref.read(productAiAddProvider.notifier);
    final isTemplateExpanded = useState(true);
    final currentMediaList = providerState.groups.map((e) => e.media).toList();
    final currentTemplate = kQuoteAiNotePadTemplates.firstWhere(
        (t) => t.id == providerState.currentTemplateId,
        orElse: () => kQuoteAiNotePadTemplates.first);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  _buildCollapsibleTemplateSelector(context, currentTemplate,
                      isExpanded: isTemplateExpanded,
                      colorScheme: colorScheme,
                      onSelect: (id) => controller.changeTemplate(id),
                      currentMediaList: currentMediaList,
                      onImagesChanged: (newImages) =>
                          controller.onImagesChanged(newImages, ref)),
                  _buildInfoBar(colorScheme),
                  if (providerState.groups.isEmpty &&
                      providerState.isGlobalLoading)
                    const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator()),
                  if (providerState.groups.isNotEmpty)
                    ListView.separated(
                      padding: const EdgeInsets.all(10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: providerState.groups.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, groupIndex) {
                        final group = providerState.groups[groupIndex];
                        return _buildGroupCard(context, groupIndex, group,
                            currentTemplate, controller, colorScheme);
                      },
                    ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context, colorScheme, providerState, controller),
        ],
      ),
    );
  }

  Widget _buildCollapsibleTemplateSelector(
      BuildContext context, TemplateOption currentTemplate,
      {required ValueNotifier<bool> isExpanded,
      required ColorScheme colorScheme,
      required Function(String id) onSelect,
      required List<TemporaryMedia> currentMediaList,
      required Function(List<TemporaryMedia>?) onImagesChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 4)
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('识别模板 (点击卡片内相机直接上传文件识别)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const Spacer(),
                  AnimatedRotation(
                      turns: isExpanded.value ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey[500])),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: isExpanded.value ? null : 0,
              child: Column(
                children: [
                  _buildTemplateListContent(
                      context: context,
                      currentId: currentTemplate.id,
                      colorScheme: colorScheme,
                      onSelect: onSelect,
                      currentMediaList: currentMediaList,
                      onImagesChanged: onImagesChanged),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateListContent(
      {required BuildContext context,
      required String currentId,
      required ColorScheme colorScheme,
      required Function(String id) onSelect,
      required List<TemporaryMedia> currentMediaList,
      required Function(List<TemporaryMedia>?) onImagesChanged}) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: kQuoteAiNotePadTemplates.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final t = kQuoteAiNotePadTemplates[index];
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
                        : Colors.grey.withOpacity(0.2))),
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () => onSelect(t.id),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var config in t.columns)
                                    config.key == 'item_no'
                                        ? Row(children: [
                                            Expanded(
                                                child: Text(config.label,
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.grey[600]),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            GestureDetector(
                                                onTap: () => _showPreviewDialog(
                                                    context, t.previewImageUrl),
                                                child: Icon(
                                                    Icons.visibility_outlined,
                                                    size: 20,
                                                    color: Colors.grey[600]))
                                          ])
                                        : Text(config.label,
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis)
                                ])))),
                Container(
                    width: 1, height: 40, color: Colors.grey.withOpacity(0.1)),
                Listener(
                    onPointerDown: (_) {
                      if (!isSelected) onSelect(t.id);
                    },
                    child: SizedBox(
                        width: 80,
                        child: ImageUploader(
                            customIcon: Icons.camera_alt_rounded,
                            onChanged: onImagesChanged))),
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorScheme.primary.withOpacity(0.1))),
      child: Row(children: [
        Icon(Icons.auto_awesome, color: colorScheme.primary, size: 14),
        const SizedBox(width: 8),
        Expanded(
            child: Text('AI自动识别中，点击表格文字可进行修改，支持一图多品。',
                style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)))
      ]),
    );
  }

  Widget _buildGroupCard(
      BuildContext context,
      int groupIndex,
      ImageProductGroup group,
      TemplateOption currentTemplate,
      ProductAiAddController controller,
      ColorScheme colorScheme) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            InkWell(
              onTap: () => controller.toggleGroupExpand(groupIndex),
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.grey[50],
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => showFlanImagePreview(context,
                            images: [group.media.url], loop: false),
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                    image: NetworkImage(group.media.url),
                                    fit: BoxFit.cover)))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text("图片 ${groupIndex + 1}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          if (group.isRecognizing)
                            Row(children: [
                              SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary)),
                              const SizedBox(width: 6),
                              Text("AI 识别中...",
                                  style: TextStyle(
                                      color: colorScheme.primary, fontSize: 12))
                            ])
                          else
                            Text("识别出 ${group.products.length} 项产品",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12))
                        ])),
                    Icon(
                        group.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey),
                  ],
                ),
              ),
            ),
            if (group.isExpanded) ...[
              if (group.isRecognizing)
                const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Text("正在分析图片内容...",
                            style: TextStyle(color: Colors.grey))))
              else
                Column(
                    children: group.products
                        .asMap()
                        .entries
                        .map((entry) => _buildProductRow(
                            context,
                            groupIndex,
                            entry.key,
                            entry.value,
                            currentTemplate,
                            entry.key == group.products.length - 1,
                            controller))
                        .toList()),
            ],
          ],
        ),
        Positioned(
          top: -5,
          left: -5,
          child: GestureDetector(
            onTap: () {
              controller.removeGroup(groupIndex);
            },
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

  Widget _buildProductRow(
      BuildContext context,
      int groupIndex,
      int productIndex,
      ProductDraftItem product,
      TemplateOption template,
      bool isLastRow,
      ProductAiAddController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: template.columns.asMap().entries.map((colEntry) {
                    final colConfig = colEntry.value;
                    final text = product.getValue(colConfig.key);
                    return Row(
                      children: [
                        SizedBox(
                          width: colConfig.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(colConfig.label,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                  maxLines: 1),
                              const SizedBox(height: 4),
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    const numberKeys = {
                                      'price',
                                      'out_carton',
                                      'inner_pack',
                                      'weight',
                                      'volume',
                                      'moq',
                                      'capacity'
                                    };

                                    final bool isNumberField =
                                        numberKeys.contains(colConfig.key);
                                    EditDialog.show(context,
                                        title: colConfig.label,
                                        initialText: text == '-' ? '' : text,
                                        keyboardType: isNumberField
                                            ? const TextInputType
                                                .numberWithOptions(
                                                decimal: true)
                                            : TextInputType.text,
                                        // 3. 传入校验函数
                                        validator: (value) {
                                          if (isNumberField &&
                                              value.isNotEmpty) {
                                            // 正则校验：支持整数或小数
                                            final reg =
                                                RegExp(r'^\d+(\.\d+)?$');
                                            if (!reg.hasMatch(value)) {
                                              return '请输入有效的数字';
                                            }
                                          }
                                          return null; // 返回 null 表示校验通过
                                        },
                                        onConfirm: (newText) =>
                                            controller.updateCell(
                                                groupIndex,
                                                productIndex,
                                                colConfig.key,
                                                newText));
                                  },
                                  child: Container(
                                      constraints:
                                          const BoxConstraints(minHeight: 24),
                                      alignment: Alignment.centerLeft,
                                      child: Text(text,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: text == '-'
                                                  ? Colors.grey[400]
                                                  : Colors.black87),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis))),
                            ],
                          ),
                        ),
                        if (colEntry.key != template.columns.length - 1)
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey[200],
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            // --- 新增：单行产品删除按钮 ---
            IconButton(
              icon: const Icon(Icons.remove_circle_outline,
                  color: Colors.grey, size: 18),
              onPressed: () =>
                  controller.removeProduct(groupIndex, productIndex),
            )
          ],
        ),
        if (!isLastRow)
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, ColorScheme colorScheme,
      ProductAiAddState state, ProductAiAddController controller) {
    final int totalProducts =
        state.groups.fold(0, (sum, g) => sum + g.products.length);
    final bool hasRecognizing = state.groups.any((g) => g.isRecognizing);
    final bool canSubmit =
        totalProducts > 0 && !hasRecognizing && !state.isSubmitting;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      child: ElevatedButton(
          onPressed: canSubmit
              ? () async {
                  await controller.submitProducts(quoteId, supplierId);
                }
              : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              minimumSize: const Size(double.infinity, 44)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (hasRecognizing || state.isSubmitting) ...[
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white))),
              const SizedBox(width: 8)
            ],
            Text(
              hasRecognizing
                  ? 'AI识别中...'
                  : state.isSubmitting
                      ? '提交中...'
                      : '保存产品 ($totalProducts)',
              style: const TextStyle(color: Colors.white),
            )
          ])),
    );
  }
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
