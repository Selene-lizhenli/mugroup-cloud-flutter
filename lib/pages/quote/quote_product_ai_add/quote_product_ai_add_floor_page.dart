import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/product_upload_zone.dart';
import 'package:cloud/services/media.dart';
import 'package:dio/dio.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_repair_flutter/json_repair_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() => {
        'data': data,
        'media': media.toJson(),
        'isRecognizing': isRecognizing,
      };

  factory ProductDraftItem.fromJson(Map<String, dynamic> json) =>
      ProductDraftItem(
        data: Map<String, String>.from(json['data']),
        media: TemporaryMedia.fromJson(json['media']),
        isRecognizing: json['isRecognizing'] ?? false,
      );
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
  static const String _kStorageKey = 'product_ai_add_draft_v1';

  @override
  ProductAiAddState build() {
    _initLoad();
    return ProductAiAddState();
  }

  Future<void> _initLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_kStorageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final List<ProductDraftItem> loadedItems = decoded
            .map((item) => ProductDraftItem.fromJson(item))
            .map((item) => item.copyWith(isRecognizing: false))
            .toList();
        state = state.copyWith(items: loadedItems);
      }
    } catch (e) {
      debugPrint('Draft load error: $e');
    }
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonStr =
          jsonEncode(state.items.map((e) => e.toJson()).toList());
      await prefs.setString(_kStorageKey, jsonStr);
    } catch (e) {
      debugPrint('Draft save error: $e');
    }
  }

  void changeTemplate(String templateId) {
    if (state.currentTemplateId == templateId) return;
    state = state.copyWith(currentTemplateId: templateId);
  }

  void removeItem(int index) {
    if (index >= state.items.length) return;
    final newList = List<ProductDraftItem>.from(state.items);
    newList.removeAt(index);
    state = state.copyWith(items: newList);
    _saveDraft();
  }

  Future<void> uploadAndRecognize(
      File file, WidgetRef ref, int? quoteId, String? supplierId) async {
    try {
      final media = await upload(file: file);
      final initialPath = media.thumbUrl ?? ''; // 记录初始路径作为 ID

      final newItem = ProductDraftItem(
          data: {'old_thumb': initialPath}, // 这里的 old_thumb 永远不变，用于匹配
          media: media,
          isRecognizing: true);

      state = state.copyWith(items: [...state.items, newItem]);
      _startIndividualSse(initialPath, media, quoteId, supplierId);
    } catch (e) {
      debugPrint("Upload Error: $e");
    }
  }

  void _startIndividualSse(String taskId, TemporaryMedia media, int? quoteId,
      String? supplierId) async {
    String buffer = "";
    String eventType = "message"; // 默认事件类型
    StreamSubscription? sub;

    try {
      final response = await api.post<ResponseBody>(
        'api/open/agents/sample/store-market-product',
        data: {
          "images": [media],
          if (quoteId != null) "quotation_id": quoteId,
          "supplier_id": supplierId,
          'item_type': 'market_product',
        },
        options: Options(responseType: ResponseType.stream),
      );

      sub = response.data?.stream
          .map((d) => utf8.decode(d))
          .transform(const LineSplitter())
          .listen((line) {
        // logger.d(line);
        if (line.startsWith('event:')) {
          eventType = line.replaceFirst('event:', '').trim();
          return;
        }

        if (!line.startsWith('data:')) return;
        String content = line.replaceFirst('data:', '').trim();

        if (content.contains("[DONE]")) return _finalize(taskId, sub);

        // --- 关键改进：针对不同 event 重置 buffer 或 增量处理 ---
        if (eventType == 'created') {
          // created 通常是单发一次的完整 JSON
          try {
            final Map<String, dynamic> raw = jsonDecode(content);

            logger.d(raw);
            _updateItemData(taskId, raw, isCreated: true);
          } catch (_) {
            // 如果解析失败，说明 created 也是分片的
            buffer += content;
          }
        } else {
          // message 识别信息通常是流式的
          buffer += content;
        }

        // logger.d(buffer);
        // 统一尝试从当前 buffer 修复并更新 OCR 文本
        _processBufferToUI(taskId, buffer);
      },
              onDone: () => _finalize(taskId, sub),
              onError: (_) => _finalize(taskId, sub));

      ref.onDispose(() => sub?.cancel());
    } catch (e) {
      _finalize(taskId, sub);
    }
  }

  void _processBufferToUI(String taskId, String buffer) {
    try {
      final repaired = repairJson(buffer);
      Map<String, dynamic>? raw;
      if (repaired is Map) raw = Map<String, dynamic>.from(repaired);
      if (repaired is List && repaired.isNotEmpty) {
        raw = Map<String, dynamic>.from(repaired.first);
      }

      if (raw != null) {
        _updateItemData(taskId, raw, isCreated: false);
      }
    } catch (_) {}
  }

  void _updateItemData(String taskId, Map<String, dynamic> raw,
      {required bool isCreated}) {
    const businessKeys = {
      'product_id',
      'supply_quote_id',
      'image',
      'old_thumb',
      'quotation_sample_id'
    };

    state = state.copyWith(
      items: state.items.map((item) {
        if (item.data['old_thumb'] != taskId) return item;

        final nextData = Map<String, String>.from(item.data);
        TemporaryMedia nextMedia = item.media;

        // 处理图片和 ID (只在包含对应 key 时更新)
        if (raw.containsKey('product_id')) {
          nextData['product_id'] = raw['product_id'].toString();
        }
        if (raw.containsKey('supply_quote_id')) {
          nextData['supply_quote_id'] = raw['supply_quote_id'].toString();
        }
        if (raw.containsKey('quotation_sample_id')) {
          nextData['quotation_sample_id'] =
              raw['quotation_sample_id'].toString();
        }
        if (raw.containsKey('image') && raw['image'] is Map) {
          nextMedia =
              TemporaryMedia.fromJson(Map<String, dynamic>.from(raw['image']));
        }

        // 处理 OCR 展示字段：遍历 raw 中所有不在黑名单里的 key
        raw.forEach((k, v) {
          if (!businessKeys.contains(k)) {
            final val = v?.toString().replaceAll('\n', '').trim() ?? '';
            if (val.isNotEmpty && val != 'null') {
              nextData[k] = val;
            }
          }
        });

        return item.copyWith(data: nextData, media: nextMedia);
      }).toList(),
    );
  }

  void _finalize(String taskId, StreamSubscription? sub) {
    sub?.cancel();
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.data['old_thumb'] == taskId)
          return item.copyWith(isRecognizing: false);
        return item;
      }).toList(),
    );
    _saveDraft();
  }

  void updateCell(int index, String key, String value) {
    if (index >= state.items.length) return;
    final item = state.items[index];
    final newData = Map<String, String>.from(item.data);
    newData[key] = value.isEmpty ? '-' : value;
    final newItems = List<ProductDraftItem>.from(state.items);
    newItems[index] = item.copyWith(data: newData);
    state = state.copyWith(items: newItems);
    _saveDraft();
  }

  void clear() async {
    state = ProductAiAddState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStorageKey);
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
                  _buildCollapsibleTemplateSelector(context, currentTemplate,
                      isExpanded: isTemplateExpanded,
                      colorScheme: colorScheme,
                      currentMediaList: currentMediaList,
                      onSelect: (newId) => controller.changeTemplate(newId),
                      controller: controller,
                      ref: ref),
                  _buildInfoBar(colorScheme),
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
                          () => controller.removeItem(index),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
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
    // required Function(List<TemporaryMedia>?) onImagesChanged,
    required ProductAiAddController controller,
    required WidgetRef ref,
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
                      '识别模板 (点击卡片内相机直接上传文件识别)',
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
                    currentId: currentTemplate.id,
                    colorScheme: colorScheme,
                    onSelect: onSelect,
                    currentMediaList: currentMediaList,
                    // onImagesChanged: onImagesChanged,
                    controller: controller,
                    ref: ref,
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
    // required Function(List<TemporaryMedia>?) onImagesChanged,
    required ProductAiAddController controller,
    required WidgetRef ref,
  }) {
    const double kItemHeight = 92.0;
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
                Container(
                    width: 1, height: 40, color: Colors.grey.withOpacity(0.1)),
                SizedBox(
                  width: 90,
                  child: ProductUploadZone(
                    width: 90,
                    height: 90,
                    onFileSelected: (File file) {
                      controller.uploadAndRecognize(
                          file, ref, quoteId, supplierId);
                    },
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

  Widget _buildDataRow(
    BuildContext context,
    int index,
    ProductDraftItem item,
    TemplateOption template,
    Function(String key, String val) onUpdate,
    VoidCallback onDelete,
  ) {
    const double rowHeight = 72.0;

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
                onTap: () =>
                    showFlanImagePreview(context, images: [item.media.url]),
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
                        : Image.network(
                            item.media.url,
                            key: ValueKey(
                                item.media.url), // 核心：URL 变了，强制图片 Widget 刷新
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey)),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2));
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 数据列表
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
                              'price',
                              'out_carton',
                              'inner_pack',
                              'weight',
                              'volume',
                              'moq',
                              'capacity'
                            };

                            final bool isNumberField =
                                numberKeys.contains(col.key);
                            EditDialog.show(context,
                                title: col.label,
                                initialText: isEmpty ? '' : text,
                                keyboardType: isNumberField
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true)
                                    : TextInputType.text, validator: (value) {
                              if (isNumberField && value.isNotEmpty) {
                                final reg = RegExp(r'^\d+(\.\d+)?$');
                                if (!reg.hasMatch(value)) {
                                  return '请输入有效的数字';
                                }
                              }
                              return null;
                            }, onConfirm: (v) {
                              logger.d(item.getValue('product_id'));
                              logger.d(item.getValue('supply_quote_id'));
                              logger.d(item.getValue('quotation_sample_id'));
                              // onUpdate(col.key, v);
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
        // 删除按钮：红色悬浮圆圈
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
