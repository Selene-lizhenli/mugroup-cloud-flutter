import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
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
  ColumnConfig('out_carton', '外装箱量', width: 70),
  ColumnConfig('inner_pack', '内装箱量', width: 70),
  ColumnConfig('size', '尺寸', width: 90),
  ColumnConfig('weight', '重量(g)', width: 60),
  ColumnConfig('packaging_type', '包装方式', width: 70),
  ColumnConfig('unit', '单位', width: 50),
  ColumnConfig('volume', '体积', width: 60),
  ColumnConfig('moq', '起订量', width: 60),
  ColumnConfig('capacity', '容量', width: 60),
  ColumnConfig('description', '描述', width: 120),
];

class ProductDraftItem {
  final Map<String, String> data;
  final TemporaryMedia media;
  final bool isRecognizing;

  ProductDraftItem({
    required this.data,
    required this.media,
    this.isRecognizing = false,
  });

  // 用于更新特定字段
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

  // 获取显示用的值
  String getValue(String key) => data[key] ?? '-';

  @override
  String toString() => 'ProductDraftItem(data: $data)';
}

class ProductAiAddState {
  final List<ProductDraftItem> items;
  final bool isGlobalLoading;

  ProductAiAddState({this.items = const [], this.isGlobalLoading = false});

  ProductAiAddState copyWith({
    List<ProductDraftItem>? items,
    bool? isGlobalLoading,
  }) {
    return ProductAiAddState(
      items: items ?? this.items,
      isGlobalLoading: isGlobalLoading ?? this.isGlobalLoading,
    );
  }
}

class ProductAiAddController extends AutoDisposeNotifier<ProductAiAddState> {
  @override
  ProductAiAddState build() {
    return ProductAiAddState();
  }

  // 图片列表变化时的入口方法
  Future<void> onImagesChanged(
      List<TemporaryMedia>? newImages, WidgetRef ref) async {
    final images = newImages ?? [];
    final currentItems = state.items;

    // 1. 如果图片减少了，直接截取对应的数据
    if (images.length < currentItems.length) {
      state = state.copyWith(items: currentItems.sublist(0, images.length));
      return;
    }

    // 2. 如果图片增加了，保留旧数据，追加新数据占位符
    if (images.length > currentItems.length) {
      final List<ProductDraftItem> newItems = List.from(currentItems);

      // 找出新增的图片索引
      final int startIndex = currentItems.length;

      // 先添加占位数据
      for (int i = startIndex; i < images.length; i++) {
        newItems.add(ProductDraftItem(
          data: {}, // 空数据
          media: images[i],
          isRecognizing: true, // 标记正在识别
        ));
      }

      // 更新UI显示Loading占位
      state = state.copyWith(items: newItems, isGlobalLoading: true);

      // 开始处理新增图片的 OCR
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

      final result = await identifyOcr('ExtractQtnBasic', {
        "department": user?.department?.name,
        "employee_name": user?.name,
        "employee_number": user?.jobNumber,
        "image": imageUrl,
      });

      if (result != null &&
          result['success'] == true &&
          (result['data'] as List).isNotEmpty) {
        final item = result['data'].first;
        for (var col in _kTableColumns) {
          String rawVal = (item[col.key] ?? '').toString().trim();
          rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
        }
      } else {
        for (var col in _kTableColumns) {
          rowMap[col.key] = '-';
        }
        rowMap['price'] = '未识别';
      }

      // 更新单条数据状态
      if (i < tempItems.length) {
        tempItems[i] = tempItems[i].copyWith(
          data: rowMap,
          isRecognizing: false,
        );
        // 实时更新状态，让用户看到进度
        state = state.copyWith(items: List.from(tempItems));
      }
    }

    state = state.copyWith(isGlobalLoading: false);
  }

  // 更新单个单元格数据
  void updateCell(int index, String key, String value) {
    if (index >= state.items.length) return;

    final item = state.items[index];
    final newData = Map<String, String>.from(item.data);
    newData[key] = value.isEmpty ? '-' : value;

    final newItems = List<ProductDraftItem>.from(state.items);
    newItems[index] = item.copyWith(data: newData);

    state = state.copyWith(items: newItems);
  }
}

final productAiAddProvider =
    NotifierProvider.autoDispose<ProductAiAddController, ProductAiAddState>(
  ProductAiAddController.new,
);

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final providerState = ref.watch(productAiAddProvider);
    final controller = ref.read(productAiAddProvider.notifier);

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
                  // 图片上传区域
                  _buildUploadArea(currentMediaList, (newImages) {
                    controller.onImagesChanged(newImages, ref);
                  }),

                  // 提示栏
                  _buildInfoBar(colorScheme),

                  // 列表区域
                  if (providerState.items.isNotEmpty) ...[
                    // 这里去掉了原本的表头 Header
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
                          (key, val) => controller.updateCell(index, key, val),
                        );
                      },
                    ),
                  ]
                ],
              ),
            ),
          ),
          _buildBottomAction(context, colorScheme, providerState.items),
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
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploader(
                    customIcon: Icons.camera_alt,
                    value: value,
                    onChanged: onChanged,
                  ),
                ],
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
              'AI自动识别中，双击数据可直接修改',
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
      Function(String key, String val) onUpdate) {
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
                children: _kTableColumns.map((col) {
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
                        onDoubleTap: () {
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

  Widget _buildBottomAction(BuildContext context, ColorScheme colorScheme,
      List<ProductDraftItem> items) {
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
          onPressed: items.isEmpty
              ? null
              : () async {
                  final List<Map<String, dynamic>> submitList = [];

                  for (var item in items) {
                    if (item.isRecognizing) continue;

                    final row = item.data;

                    String? val(String key) =>
                        (row[key] == null || row[key] == '-') ? null : row[key];

                    submitList.add({
                      'supply_quotes': [
                        {
                          "supplier_id": '67545',
                          'supplier_price': val('price'),
                          'outer_capacity': val('out_carton'),
                          'inner_capacity': val('inner_pack'),
                          'weight': val('weight'),
                          'packaging': val('packaging_type'),
                          'unit': val('unit'),
                          'outer_volume': val('volume'),
                          'supplier_moq': val('moq'),
                        }
                      ],
                      'spec': val('size'),
                      'description_cn': val('description'),
                      'image': [item.media],
                      'item_type': 'market_product'
                    });
                  }

                  if (submitList.isEmpty) return;

                  await batchStoreShowroomSample({'products': submitList});
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          child: Text('保存产品 (${items.length})'),
        ),
      ),
    );
  }
}
