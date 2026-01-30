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

  // 图片列表变化时，同步 Groups
  Future<void> onImagesChanged(
      List<TemporaryMedia>? newImages, WidgetRef ref) async {
    final images = newImages ?? [];
    final currentGroups = state.groups;

    // 1. 如果图片减少，直接截取对应数量的组
    if (images.length < currentGroups.length) {
      state = state.copyWith(groups: currentGroups.sublist(0, images.length));
      return;
    }

    // 2. 如果图片增加，处理新增的图片
    if (images.length > currentGroups.length) {
      final List<ImageProductGroup> newGroups = List.from(currentGroups);
      final int startIndex = currentGroups.length;

      // 先为新图片添加“加载中”的占位组
      for (int i = startIndex; i < images.length; i++) {
        newGroups.add(ImageProductGroup(
          media: images[i],
          products: [], // 此时还没有产品
          isRecognizing: true,
        ));
      }

      state = state.copyWith(groups: newGroups, isGlobalLoading: true);

      // 异步处理OCR
      await _processOcrQueue(startIndex, images, ref);
    }
  }

  Future<void> _processOcrQueue(
      int startIndex, List<TemporaryMedia> images, WidgetRef ref) async {
    final user = ref.read(userProvider).user;

    // 1. 获取当前选中的模板配置
    final currentTemplate = kQuoteAiNotePadTemplates.firstWhere(
      (t) => t.id == state.currentTemplateId,
      orElse: () => kQuoteAiNotePadTemplates.first,
    );

    for (int i = startIndex; i < images.length; i++) {
      final imageUrl = images[i].url;
      List<ProductDraftItem> recognizedProducts = [];

      try {
        final result = await identifyOcr('ExtractQtnNbBasic', {
          "template_id": state.currentTemplateId, // 传递模板 ID 给后端
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
            // 2. 关键：根据当前模板定义的 columns 动态提取 key
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

      // 3. 如果识别为空，生成带当前模板所有 key 的空行
      if (recognizedProducts.isEmpty) {
        Map<String, String> emptyMap = {};
        for (var col in currentTemplate.columns) {
          emptyMap[col.key] = '-';
        }
        recognizedProducts.add(ProductDraftItem(data: emptyMap));
      }

      // 更新状态逻辑保持不变...
      if (i < state.groups.length) {
        final tempGroups = List<ImageProductGroup>.from(state.groups);
        tempGroups[i] = tempGroups[i].copyWith(
          products: recognizedProducts,
          isRecognizing: false,
        );
        state = state.copyWith(groups: tempGroups);
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

    // 构建新的产品列表
    final newProducts = List<ProductDraftItem>.from(group.products);
    newProducts[productIndex] = product.copyWith(data: newData);

    // 构建新的组列表
    final newGroups = List<ImageProductGroup>.from(state.groups);
    newGroups[groupIndex] = group.copyWith(products: newProducts);

    state = state.copyWith(groups: newGroups);
  }

  Future<bool> submitProducts(int? quoteId, String? supplierId) async {
    // 1. 状态检查
    if (state.isSubmitting) return false;

    // 2. 检查是否有正在识别的组
    if (state.groups.any((g) => g.isRecognizing)) {
      EasyLoading.showToast('请等待所有图片识别完成');
      return false;
    }

    if (state.groups.isEmpty) {
      EasyLoading.showToast('请先上传图片');
      return false;
    }

    // 3. 开始提交
    state = state.copyWith(isSubmitting: true);
    EasyLoading.show(status: '保存中...');

    try {
      final List<Map<String, dynamic>> submitList = [];

      for (var group in state.groups) {
        if (group.isRecognizing) continue;

        for (var product in group.products) {
          final row = product.data;

          String? val(String key) =>
              (row[key] == null || row[key] == '-') ? null : row[key];

          submitList.add({
            'quotation_id': quoteId,
            "quotation": {},
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
            // 修复：这里使用 group.media，因为是一图多品，产品共享图片的
            // 'image': [group.media],
            'item_type': 'market_product'
          });
        }
      }

      if (submitList.isEmpty) {
        EasyLoading.showInfo('没有有效数据可提交');
        return false;
      }

      await batchStoreShowroomSample({'products': submitList});

      EasyLoading.showSuccess('保存成功');
      clear(); // 清空
      return true;
    } catch (e) {
      EasyLoading.showError('保存失败: $e');
      return false;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  // 清空数据
  void clear() {
    state = ProductAiAddState();
  }
}

final productAiAddProvider =
    NotifierProvider.autoDispose<ProductAiAddController, ProductAiAddState>(
  ProductAiAddController.new,
);

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
      orElse: () => kQuoteAiNotePadTemplates.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  _buildCollapsibleTemplateSelector(
                    context,
                    currentTemplate,
                    isExpanded: isTemplateExpanded,
                    colorScheme: colorScheme,
                    onSelect: (id) => controller.changeTemplate(id),
                    currentMediaList: currentMediaList,
                    onImagesChanged: (newImages) {
                      controller.onImagesChanged(newImages, ref);
                    },
                  ),

                  // 2. 提示栏
                  _buildInfoBar(colorScheme),

                  // 3. 列表区域
                  // 全局 Loading (备用)
                  if (providerState.groups.isEmpty &&
                      providerState.isGlobalLoading)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),

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
    BuildContext context,
    TemplateOption currentTemplate, {
    required ValueNotifier<bool> isExpanded,
    required ColorScheme colorScheme,
    required Function(String id) onSelect,
    required List<TemporaryMedia> currentMediaList,
    required Function(List<TemporaryMedia>?) onImagesChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              isExpanded.value = !isExpanded.value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize_outlined,
                      size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '识别模板 (点击卡片内相机直接上传文件识别)',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey[500]),
                  ),
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
                    onImagesChanged: onImagesChanged,
                  ),
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
    required String currentId,
    required ColorScheme colorScheme,
    required Function(String id) onSelect,
    required List<TemporaryMedia> currentMediaList,
    required Function(List<TemporaryMedia>?) onImagesChanged,
  }) {
    const double kItemHeight = 82.0;

    return SizedBox(
      height: kItemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: kQuoteAiNotePadTemplates.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final t = kQuoteAiNotePadTemplates[index];
          final bool isSelected = t.id == currentId;

          final primaryColor = colorScheme.primary;
          final borderColor =
              isSelected ? primaryColor : Colors.grey.withOpacity(0.2);
          final bgColor =
              isSelected ? primaryColor.withOpacity(0.04) : Colors.white;

          return Container(
            width: 160,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onSelect(t.id),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var config in t.columns) ...[
                            if (config.key == 'item_no') ...[
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

                // 分割线
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.withOpacity(0.1),
                ),

                Listener(
                  onPointerDown: (_) {
                    if (!isSelected) {
                      onSelect(t.id);
                    }
                  },
                  child: SizedBox(
                    width: 80,
                    child: ImageUploader(
                      customIcon: Icons.camera_alt_rounded,
                      onChanged: (newImages) {
                        onImagesChanged(newImages);
                      },
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: colorScheme.primary, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI自动识别中，点击表格文字可进行修改，支持一图多品。',
              style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
      BuildContext context,
      int groupIndex,
      ImageProductGroup group,
      TemplateOption currentTemplate,
      ProductAiAddController controller,
      ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleGroupExpand(groupIndex),
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[50],
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showFlanImagePreview(
                        context,
                        images: [group.media.url],
                        loop: false,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage(group.media.url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "图片 ${groupIndex + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        if (group.isRecognizing)
                          Row(
                            children: [
                              SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary)),
                              const SizedBox(width: 6),
                              Text("AI 识别中...",
                                  style: TextStyle(
                                      color: colorScheme.primary,
                                      fontSize: 12)),
                            ],
                          )
                        else
                          Text(
                            "识别出 ${group.products.length} 项产品",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    group.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
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
                        style: TextStyle(color: Colors.grey))),
              )
            else
              Column(
                children: group.products.asMap().entries.map((entry) {
                  final int productIndex = entry.key;
                  final product = entry.value;
                  final isLastRow = productIndex == group.products.length - 1;

                  return _buildProductRow(
                    context,
                    product,
                    currentTemplate,
                    isLastRow,
                    (key, val) => controller.updateCell(
                        groupIndex, productIndex, key, val),
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductRow(
    BuildContext context,
    ProductDraftItem product,
    TemplateOption template, // 传入当前模板
    bool isLastRow,
    Function(String key, String val) onUpdate,
  ) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            // 使用传入模板的 columns 动态生成列
            children: template.columns.asMap().entries.map((colEntry) {
              final int colIndex = colEntry.key;
              final colConfig = colEntry.value;
              final text = product.getValue(colConfig.key);
              final isLastCol = colIndex == template.columns.length - 1;

              return Row(
                children: [
                  SizedBox(
                    width: colConfig.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          colConfig.label,
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            EditDialog.show(
                              context,
                              initialText: text == '-' ? '' : text,
                              onConfirm: (newText) =>
                                  onUpdate(colConfig.key, newText),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 24),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: text == '-'
                                    ? Colors.grey[400]
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLastCol)
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        if (!isLastRow)
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    ColorScheme colorScheme,
    ProductAiAddState state,
    ProductAiAddController controller,
  ) {
    // 1. 计算总产品数
    final int totalProducts =
        state.groups.fold(0, (sum, g) => sum + g.products.length);

    // 2. 检查是否有组在识别中
    final bool hasRecognizing = state.groups.any((g) => g.isRecognizing);

    // 3. 按钮是否可用 (有产品 且 无识别中 且 非提交中)
    final bool canSubmit =
        totalProducts > 0 && !hasRecognizing && !state.isSubmitting;

    // 4. 按钮文案
    String buttonText = '保存产品 ($totalProducts)';
    if (hasRecognizing) {
      buttonText = 'AI识别中...';
    } else if (state.isSubmitting) {
      buttonText = '提交中...';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
        ],
      ),
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: canSubmit
              ? () async {
                  await controller.submitProducts(quoteId, supplierId);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colorScheme.primary.withOpacity(0.5),
            disabledForegroundColor: Colors.white.withOpacity(0.8),
            elevation: canSubmit ? 0 : 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasRecognizing || state.isSubmitting) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(buttonText),
            ],
          ),
        ),
      ),
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
              child: Image.network(
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
