import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDraftItem {
  final Map<String, String> data;
  final TemporaryMedia media;
  final bool isRecognizing;

  ProductDraftItem({
    required this.data,
    required this.media,
    this.isRecognizing = false,
  });

  ProductDraftItem copyWith({
    Map<String, String>? data,
    TemporaryMedia? media,
    bool? isRecognizing,
  }) {
    return ProductDraftItem(
      data: data ?? this.data,
      media: media ?? this.media,
      isRecognizing: isRecognizing ?? this.isRecognizing,
    );
  }

  String getValue(String key) => data[key] ?? '-';
}

class ProductAiAddState {
  final List<ProductDraftItem> items;
  final bool isGlobalLoading;
  final bool isSubmitting;
  final String currentTemplateId;

  ProductAiAddState({
    this.items = const [],
    this.isGlobalLoading = false,
    this.isSubmitting = false,
    String? currentTemplateId,
  }) : currentTemplateId = currentTemplateId ?? kDefaultTemplateId;

  ProductAiAddState copyWith({
    List<ProductDraftItem>? items,
    bool? isGlobalLoading,
    bool? isSubmitting,
    String? currentTemplateId,
  }) {
    return ProductAiAddState(
      items: items ?? this.items,
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

  Future<void> onImagesChanged(
      List<TemporaryMedia>? newImages, WidgetRef ref) async {
    final images = newImages ?? [];
    final currentItems = state.items;

    if (images.length < currentItems.length) {
      state = state.copyWith(items: currentItems.sublist(0, images.length));
      return;
    }

    if (images.length > currentItems.length) {
      final List<ProductDraftItem> newItems = List.from(currentItems);
      final int startIndex = currentItems.length;

      for (int i = startIndex; i < images.length; i++) {
        newItems.add(ProductDraftItem(
          data: {},
          media: images[i],
          isRecognizing: true,
        ));
      }

      state = state.copyWith(items: newItems, isGlobalLoading: true);
      await _processOcrQueue(startIndex, images, ref);
    }
  }

  Future<void> _processOcrQueue(
      int startIndex, List<TemporaryMedia> images, WidgetRef ref) async {
    final user = ref.read(userProvider).user;
    List<ProductDraftItem> tempItems = List.from(state.items);

    for (int i = startIndex; i < images.length; i++) {
      final imageUrl = images[i].url;
      Map<String, String> rowMap = {};

      try {
        final result = await identifyOcr('{*}Basic', {
          "tempalte_id": state.currentTemplateId,
          "department": user?.department?.name,
          "employee_name": user?.name,
          "employee_number": user?.jobNumber,
          "image": imageUrl,
        });

        if (result != null &&
            result['success'] == true &&
            (result['data'] as List).isNotEmpty) {
          final item = result['data'].first;
          for (var col in AppColumns.all) {
            String rawVal = (item[col.key] ?? '').toString().trim();
            rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
          }
        } else {
          for (var col in AppColumns.all) {
            rowMap[col.key] = '-';
          }
          rowMap['price'] = '未识别';
        }
      } catch (e) {
        for (var col in AppColumns.all) {
          rowMap[col.key] = '-';
        }
        rowMap['price'] = '识别错误';
      }

      if (i < state.items.length) {
        tempItems = List.from(state.items);
        tempItems[i] = tempItems[i].copyWith(
          data: rowMap,
          isRecognizing: false,
        );
        state = state.copyWith(items: tempItems);
      }
    }
    state = state.copyWith(isGlobalLoading: false);
  }

  void updateCell(int index, String key, String value) {
    if (index >= state.items.length) return;
    final item = state.items[index];
    final newData = Map<String, String>.from(item.data);
    newData[key] = value.isEmpty ? '-' : value;
    final newItems = List<ProductDraftItem>.from(state.items);
    newItems[index] = item.copyWith(data: newData);
    state = state.copyWith(items: newItems);
  }

  Future<bool> submitProducts(int? quoteId, String? supplierId) async {
    if (state.isSubmitting) return false;
    if (state.items.any((element) => element.isRecognizing)) {
      EasyLoading.showToast('请等待所有图片识别完成');
      return false;
    }
    if (state.items.isEmpty) {
      EasyLoading.showToast('请先上传图片');
      return false;
    }

    state = state.copyWith(isSubmitting: true);
    EasyLoading.show(status: '保存中...');

    try {
      final List<Map<String, dynamic>> submitList = [];
      for (var item in state.items) {
        if (item.isRecognizing) continue;
        final row = item.data;
        String? val(String key) =>
            (row[key] == null || row[key] == '-') ? null : row[key];

        submitList.add({
          'quotation_id': quoteId,
          "quotation": {},
          'supply_quotes': [
            {
              "supplier_id": supplierId,
              'supplier_price': val(AppColumns.price.key),
              'outer_capacity': val(AppColumns.outCarton.key),
              'inner_capacity': val(AppColumns.innerPack.key),
              'weight': val(AppColumns.weight.key),
              'packaging': val(AppColumns.packagingType.key),
              'unit': val(AppColumns.unit.key),
              'outer_volume': val(AppColumns.volume.key),
              'supplier_moq': val(AppColumns.moq.key),
            }
          ],
          'spec': val(AppColumns.size.key),
          'description_cn': val(AppColumns.description.key),
          'image': [item.media],
          'item_type': 'market_product',
        });
      }

      if (submitList.isEmpty) {
        EasyLoading.showInfo('没有有效数据可提交');
        return false;
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
  ProductAiAddController.new,
);

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;
  final String? supplierId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId, this.supplierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final providerState = ref.watch(productAiAddProvider);
    final controller = ref.read(productAiAddProvider.notifier);

    final isTemplateExpanded = useState(true);

    final currentTemplate = getTemplateById(providerState.currentTemplateId);
    final currentMediaList = providerState.items.map((e) => e.media).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                    currentMediaList: currentMediaList,
                    onSelect: (newId) {
                      controller.changeTemplate(newId);
                    },
                    onImagesChanged: (newImages) {
                      controller.onImagesChanged(newImages, ref);
                    },
                  ),

                  // 提示栏
                  _buildInfoBar(colorScheme),

                  // 数据列表
                  if (providerState.items.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: providerState.items.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = providerState.items[index];
                        return _buildDataRow(
                          context,
                          index,
                          item,
                          currentTemplate,
                          (key, val) => controller.updateCell(index, key, val),
                        );
                      },
                    ),
                  ]
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
        itemCount: kQuoteAiTemplates.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final t = kQuoteAiTemplates[index];
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: colorScheme.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI自动识别中，点击数据可直接修改',
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

  Widget _buildDataRow(BuildContext context, int index, ProductDraftItem item,
      TemplateOption template, Function(String key, String val) onUpdate) {
    const double rowHeight = 72.0;

    if (item.isRecognizing) {
      return Container(
        height: rowHeight,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
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
          GestureDetector(
            onTap: () {
              showFlanImagePreview(context,
                  images: [item.media.url], loop: false);
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  item.media.url,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Center(
                      child: Icon(Icons.broken_image_outlined,
                          color: Colors.grey, size: 20)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: template.columns.map((col) {
                  final text = item.getValue(col.key);
                  final bool isEmpty = text == '-' || text.isEmpty;

                  return Container(
                    width: col.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          EditDialog.show(
                            context,
                            initialText: isEmpty ? '' : text,
                            onConfirm: (newText) => onUpdate(col.key, newText),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              col.label,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              text,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isEmpty
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                                color: isEmpty
                                    ? Colors.grey[300]
                                    : const Color(0xFF333333),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    ColorScheme colorScheme,
    ProductAiAddState state,
    ProductAiAddController controller,
  ) {
    // 1. 判断是否还有正在识别的项目
    final bool hasRecognizingItems =
        state.items.any((item) => item.isRecognizing);

    // 2. 列表是否为空
    final bool isEmpty = state.items.isEmpty;

    // 3. 计算按钮是否可用 (非空 且 无识别中 且 非提交中)
    final bool canSubmit =
        !isEmpty && !hasRecognizingItems && !state.isSubmitting;

    // 4. 计算按钮文案
    String buttonText = '保存产品 (${state.items.length})';
    if (hasRecognizingItems) {
      buttonText = 'AI识别中...';
    } else if (state.isSubmitting) {
      buttonText = '提交中...';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
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
            elevation: canSubmit ? 1 : 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasRecognizingItems || state.isSubmitting) ...[
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
