import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColumnConfig {
  final String key;
  final String label;
  final double width;
  const ColumnConfig(this.key, this.label, {this.width = 80.0});
}

const List<ColumnConfig> _kTableColumns = [
  ColumnConfig('price', '供应商报价', width: 80),
  ColumnConfig('out_carton', '外装箱量', width: 80),
  ColumnConfig('item_no', '供应商货号', width: 80),
  // ColumnConfig('inner_pack', '内装箱量', width: 60),
  ColumnConfig('size', '尺寸', width: 80),
  // ColumnConfig('weight', '重量(克)', width: 60),
  // ColumnConfig('packaging_type', '包装方式', width: 70),
  // ColumnConfig('unit', '单位', width: 50),
  // ColumnConfig('volume', '体积', width: 60),
  // ColumnConfig('moq', '起订量', width: 70),
  // ColumnConfig('capacity', '容量', width: 60),
  ColumnConfig('description', '描述', width: 120), // 描述通常宽一点
];

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

  ProductAiAddState({this.groups = const [], this.isGlobalLoading = false});

  ProductAiAddState copyWith({
    List<ImageProductGroup>? groups,
    bool? isGlobalLoading,
  }) {
    return ProductAiAddState(
      groups: groups ?? this.groups,
      isGlobalLoading: isGlobalLoading ?? this.isGlobalLoading,
    );
  }
}

class ProductAiAddController extends AutoDisposeNotifier<ProductAiAddState> {
  @override
  ProductAiAddState build() {
    return ProductAiAddState();
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
    List<ImageProductGroup> tempGroups = List.from(state.groups);

    for (int i = startIndex; i < images.length; i++) {
      final imageUrl = images[i].url;
      List<ProductDraftItem> recognizedProducts = [];

      final result = await identifyOcr('ExtractQtnNbBasic', {
        "department": user?.department?.name,
        "employee_name": user?.name,
        "employee_number": user?.jobNumber,
        "image": imageUrl,
      });

      if (result != null &&
          result['success'] == true &&
          result['data'] is List) {
        final dataList = result['data'] as List;

        if (dataList.isNotEmpty) {
          for (var itemData in dataList) {
            Map<String, String> rowMap = {};
            for (var col in _kTableColumns) {
              String rawVal = (itemData[col.key] ?? '').toString().trim();
              rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
            }
            recognizedProducts.add(ProductDraftItem(data: rowMap));
          }
        }
      }

      if (recognizedProducts.isEmpty) {
        Map<String, String> errorMap = {};
        for (var col in _kTableColumns) {
          errorMap[col.key] = '-';
        }

        recognizedProducts.add(ProductDraftItem(data: errorMap));
      }

      if (i < tempGroups.length) {
        tempGroups[i] = tempGroups[i].copyWith(
          products: recognizedProducts,
          isRecognizing: false,
        );
        state = state.copyWith(groups: List.from(tempGroups));
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

    final currentMediaList = providerState.groups.map((e) => e.media).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // 1. 顶部图片上传
                  _buildUploadArea(currentMediaList, (newImages) {
                    controller.onImagesChanged(newImages, ref);
                  }),

                  // 2. 提示栏
                  _buildInfoBar(colorScheme),

                  // 3. 列表区域
                  // 如果有正在全局加载的状态(虽然现在是逐个加载，保留此逻辑防止闪烁)
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
                            controller, colorScheme);
                      },
                    ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context, colorScheme, providerState.groups),
        ],
      ),
    );
  }

  Widget _buildUploadArea(List<TemporaryMedia>? value,
      ValueChanged<List<TemporaryMedia>?> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2))
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: ImageUploader(
                customIcon: Icons.camera_alt,
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
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
              'AI自动识别中，双击表格文字可进行修改，支持一图多品。',
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

  Widget _buildProductRow(BuildContext context, ProductDraftItem product,
      bool isLastRow, Function(String key, String val) onUpdate) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: _kTableColumns.asMap().entries.map((colEntry) {
              final int colIndex = colEntry.key;
              final colConfig = colEntry.value;
              final text = product.getValue(colConfig.key);
              final isLastCol = colIndex == _kTableColumns.length - 1;

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
                          onDoubleTap: () {
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

  Widget _buildBottomAction(BuildContext context, ColorScheme colorScheme,
      List<ImageProductGroup> groups) {
    final int totalProducts =
        groups.fold(0, (sum, g) => sum + g.products.length);

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
          onPressed: totalProducts == 0
              ? null
              : () async {
                  final List<Map<String, dynamic>> submitList = [];

                  for (var group in groups) {
                    if (group.isRecognizing) continue;

                    for (var product in group.products) {
                      final row = product.data;

                      String? val(String key) =>
                          (row[key] == null || row[key] == '-')
                              ? null
                              : row[key];

                      submitList.add({
                        'supply_quotes': [
                          {
                            "supplier_id": supplierId,
                            'supplier_price': val('price'),
                            'outer_capacity': val('out_carton'),
                            'supplier_sku': val('item_no'),
                            // 'inner_capacity': val('inner_pack'),
                            // 'weight': val('weight'),
                            // 'packaging': val('packaging_type'),
                            // 'unit': val('unit'),
                            // 'outer_volume': val('volume'),
                            // 'supplier_moq': val('moq'),
                          }
                        ],
                        'spec': val('size'),
                        'description_cn': val('description'),
                        // 'image': [item.media],
                        'item_type': 'market_product'
                      });
                    }
                  }

                  if (submitList.isEmpty) return;

                  await batchStoreShowroomSample({'products': submitList});
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('保存全部产品 ($totalProducts)'),
        ),
      ),
    );
  }
}
