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
  ColumnConfig('out_carton', '外装箱量', width: 80),
  ColumnConfig('inner_pack', '内装箱量', width: 60),
  ColumnConfig('size', '尺寸', width: 80),
  ColumnConfig('weight', '重量(克)', width: 60),
  ColumnConfig('packaging_type', '包装方式', width: 70),
  ColumnConfig('unit', '单位', width: 50),
  ColumnConfig('volume', '体积', width: 60),
  ColumnConfig('moq', '起订量', width: 70),
  ColumnConfig('capacity', '容量', width: 60),
  ColumnConfig('description', '描述', width: 80),
];

/// 更好的数据模型，包含 helper 方法
class ProductDraftItem {
  final Map<String, String> data;
  final TemporaryMedia media;
  final bool isRecognizing; // 增加单个条目的识别状态

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

// --- 2. Riverpod Controller (业务逻辑层) ---

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

    // 这里的策略是并发还是串行？这里演示串行处理，也可以改为 Future.wait 并发
    List<ProductDraftItem> tempItems = List.from(state.items);

    for (int i = startIndex; i < images.length; i++) {
      final imageUrl = images[i].url;
      Map<String, String> rowMap = {};

      try {
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
          for (var col in _kTableColumns) rowMap[col.key] = '-';
          rowMap['price'] = '未识别';
        }
      } catch (e) {
        logger.e('OCR Error: $e');
        for (var col in _kTableColumns) rowMap[col.key] = '-';
        rowMap['price'] = '识别错误';
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

// 定义 Provider
final productAiAddProvider =
    NotifierProvider.autoDispose<ProductAiAddController, ProductAiAddState>(
  ProductAiAddController.new,
);

// --- 3. UI 页面 ---

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final providerState = ref.watch(productAiAddProvider);
    final controller = ref.read(productAiAddProvider.notifier);

    // 提取当前的 media 列表供 ImageUploader 回显
    final currentMediaList = providerState.items.map((e) => e.media).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                    _buildTableHeader(),
                    const SizedBox(height: 8),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: const Color(0xFFEef6FF),
      child: Row(
        children: [
          Icon(Icons.volume_up_outlined, color: colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI自动识别中，双击表格文字可进行修改!!!',
              style: TextStyle(color: colorScheme.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 70 + 16,
            child: Text(' 图片预览',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: _kTableColumns.map((col) {
                  return Container(
                    width: col.width,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      col.label,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
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

  Widget _buildDataRow(BuildContext context, int index, ProductDraftItem item,
      Function(String key, String val) onUpdate) {
    // 如果该行正在识别中，显示 Loading
    if (item.isRecognizing) {
      return Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  item.media.url,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: _kTableColumns.map((col) {
                  final text = item.getValue(col.key);
                  return Container(
                    width: col.width,
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onDoubleTap: () {
                          EditDialog.show(
                            context,
                            initialText: text == '-' ? '' : text,
                            onConfirm: (newText) => onUpdate(col.key, newText),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: text == '-'
                                      ? Colors.grey[400]
                                      : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('保存产品'),
        ),
      ),
    );
  }
}
