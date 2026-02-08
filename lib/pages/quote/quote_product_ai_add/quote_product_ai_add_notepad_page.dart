import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/constants/quote_ai_template_config.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/product_upload_zone.dart';
import 'package:cloud/services/media.dart';
import 'package:cloud/services/sample.dart';
import 'package:dio/dio.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json_repair_flutter/json_repair_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 单个产品条目（一行数据）
class ProductDraftItem {
  final Map<String, String> data;

  ProductDraftItem({required this.data});

  ProductDraftItem copyWith({Map<String, String>? data}) {
    return ProductDraftItem(data: data ?? this.data);
  }

  String getValue(String key) => data[key] ?? '-';

  // --- 新增：持久化 ---
  Map<String, dynamic> toJson() => {'data': data};
  factory ProductDraftItem.fromJson(Map<String, dynamic> json) =>
      ProductDraftItem(data: Map<String, String>.from(json['data']));
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

  // --- 新增：持久化 ---
  Map<String, dynamic> toJson() => {
        'media': media.toJson(),
        'products': products.map((e) => e.toJson()).toList(),
        'isExpanded': isExpanded,
      };

  factory ImageProductGroup.fromJson(Map<String, dynamic> json) =>
      ImageProductGroup(
        media: TemporaryMedia.fromJson(json['media']),
        products: (json['products'] as List)
            .map((e) => ProductDraftItem.fromJson(e))
            .toList(),
        isExpanded: json['isExpanded'] ?? true,
        isRecognizing: false, // 重启后默认不处于识别状态
      );
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
  static const String _kStorageKey = 'product_ai_notepad_draft'; // 存储Key

  @override
  ProductAiAddState build() {
    _loadDraft(); // 初始化时加载
    return ProductAiAddState();
  }

  // --- 新增：持久化读写 ---
  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_kStorageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final loadedGroups =
            decoded.map((e) => ImageProductGroup.fromJson(e)).toList();
        state = state.copyWith(groups: loadedGroups);
      }
    } catch (e) {
      debugPrint('加载草稿失败: $e');
    }
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(state.groups.map((e) => e.toJson()).toList());
      await prefs.setString(_kStorageKey, jsonStr);
    } catch (e) {
      debugPrint('保存草稿失败: $e');
    }
  }

  void changeTemplate(String templateId) {
    if (state.currentTemplateId == templateId) return;
    state = state.copyWith(currentTemplateId: templateId);
  }

  void removeGroup(int index) {
    if (index >= state.groups.length) return;
    final newList = List<ImageProductGroup>.from(state.groups);
    newList.removeAt(index);
    state = state.copyWith(groups: newList);
    _saveDraft(); // 保存
  }

  void removeProduct(int groupIndex, int productIndex) {
    if (groupIndex >= state.groups.length) return;
    final groups = List<ImageProductGroup>.from(state.groups);
    final group = groups[groupIndex];
    if (productIndex >= group.products.length) return;

    final newProducts = List<ProductDraftItem>.from(group.products);
    newProducts.removeAt(productIndex);

    groups[groupIndex] = group.copyWith(products: newProducts);
    state = state.copyWith(groups: groups);
    _saveDraft(); // 保存
  }

  Future<void> uploadAndRecognize(
      File file, WidgetRef ref, int? quoteId, String? supplierId) async {
    try {
      // 1. 先上传文件拿到 TemporaryMedia
      final media = await upload(file: file);
      final String taskId = media.thumbUrl ?? "";

      // 2. 立即在 state 中创建一个属于这张图的 Group
      final newGroup = ImageProductGroup(
        media: media,
        // 初始给一个空行，解决你说的“识别完才出现”的问题，实现即时占位
        products: [
          ProductDraftItem(data: {
            for (var col in kQuoteAiNotePadTemplates.first.columns) col.key: '-'
          })
        ],
        isRecognizing: true,
      );

      state = state.copyWith(groups: [...state.groups, newGroup]);
      _saveDraft();

      // 3. 立即为这张图开启独立的 SSE 识别任务，不等待其他图片
      _startSingleImageSse(taskId, media);
    } catch (e) {
      debugPrint("上传识别失败: $e");
    }
  }

  void _startSingleImageSse(String taskId, TemporaryMedia media) async {
    String buffer = "";
    StreamSubscription? sub;
    final currentTemplate = getTemplateById(state.currentTemplateId);

    try {
      // 使用之前讨论过的 silentApi 避开拦截器崩溃问题
      final response = await silentApi.post<ResponseBody>(
        'api/open/agents/sample/store-market-note-product',
        data: {
          'item_type': 'market_product',
          'template_id': state.currentTemplateId,
          "images": [media],
        },
        options: Options(responseType: ResponseType.stream),
      );

      sub = response.data?.stream.map((d) => utf8.decode(d)).listen((chunk) {
        // 直接监听 chunk，不再等待 LineSplitter 拆行
        // 因为 chunk 可能是 "data: {\"nam" 这种不完整的字符串

        // 简单的 SSE 协议解析：提取 data: 之后的内容
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data:')) {
            String content = line.replaceFirst('data:', '').trim();

            if (content.contains("[DONE]")) {
              _finalizeGroup(taskId, sub);
              return;
            }

            buffer += content;
          }
        }

        // 只要 buffer 发生变化，就尝试修复并更新 UI
        if (buffer.isNotEmpty) {
          _updateGroupItemsFromBuffer(taskId, buffer, currentTemplate);
        }
      },
          onDone: () => _finalizeGroup(taskId, sub),
          onError: (_) => _finalizeGroup(taskId, sub));

      ref.onDispose(() => sub?.cancel());
    } catch (e) {
      _finalizeGroup(taskId, sub);
    }
  }

  void _updateGroupItemsFromBuffer(
      String taskId, String buffer, TemplateOption template) {
    try {
      // 使用 json_repair 修复当前的列表字符串
      final repaired = repairJson(buffer);
      List<dynamic> rawList = [];

      if (repaired is List) {
        rawList = repaired;
      } else if (repaired is Map) {
        // 有时刚开始解析会变成单个 Map
        rawList = [repaired];
      }

      state = state.copyWith(
        groups: state.groups.map((group) {
          if (group.media.thumbUrl != taskId) return group;

          // 将解析出的 raw 数据转为 ProductDraftItem
          List<ProductDraftItem> currentProducts = rawList.map((itemData) {
            Map<String, String> rowMap = {};
            for (var col in template.columns) {
              String rawVal = (itemData[col.key] ?? '').toString().trim();
              rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
            }
            return ProductDraftItem(data: rowMap);
          }).toList();

          // 如果解析为空，保持一个占位行（可选）
          if (currentProducts.isEmpty) {
            currentProducts = [
              ProductDraftItem(
                  data: {for (var col in template.columns) col.key: '-'})
            ];
          }

          return group.copyWith(
            products: currentProducts,
            isRecognizing: true, // 仍然在识别中
          );
        }).toList(),
      );
    } catch (e) {
      // 解析失败说明 buffer 还没到能修好的地步，保持现状
    }
  }

  void _finalizeGroup(String taskId, StreamSubscription? sub) {
    sub?.cancel();
    state = state.copyWith(
      groups: state.groups.map((group) {
        if (group.media.thumbUrl == taskId) {
          return group.copyWith(isRecognizing: false);
        }
        return group;
      }).toList(),
    );
    _saveDraft(); // 最终保存一次
  }

  void toggleGroupExpand(int groupIndex) {
    if (groupIndex >= state.groups.length) return;
    final newGroups = List<ImageProductGroup>.from(state.groups);
    final group = newGroups[groupIndex];
    newGroups[groupIndex] = group.copyWith(isExpanded: !group.isExpanded);
    state = state.copyWith(groups: newGroups);
    _saveDraft(); // 保存折叠状态
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
    _saveDraft(); // 保存修改内容
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
                'purchase_cost': val('purchase_cost'),
                'outer_capacity': val('outer_capacity'),
                'supplier_sku': val('product_no'),
              }
            ],
            "product_no": val('product_no'),
            'spec': val('spec'),
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

  void clear() async {
    state = ProductAiAddState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kStorageKey); // 清除本地缓存
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
                      controller: controller,
                      ref: ref),
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
    required ProductAiAddController controller,
    required WidgetRef ref,
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
                      controller: controller,
                      ref: ref),
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
    required ProductAiAddController controller,
    required WidgetRef ref,
  }) {
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
                                    config.key == 'product_no'
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
                        child: ProductUploadZone(
                          width: 90,
                          height: 90,
                          onFileSelected: (File file) {
                            controller.uploadAndRecognize(
                                file, ref, quoteId, supplierId);
                          },
                        ))),
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
            if (group.isExpanded)
              Column(
                children: [
                  if (group.products.isNotEmpty)
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
                                controller,
                              ))
                          .toList(),
                    ),
                  if (group.isRecognizing && group.products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("准备识别...",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                ],
              ),
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
                                      'purchase_cost',
                                      'outer_capacity',
                                      'inner_capacity',
                                      'weight',
                                      'outer_volume',
                                      'moq',
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
                                        validator: (value) {
                                          if (isNumberField &&
                                              value.isNotEmpty) {
                                            final reg =
                                                RegExp(r'^\d+(\.\d+)?$');
                                            if (!reg.hasMatch(value)) {
                                              return '请输入有效的数字';
                                            }
                                          }
                                          return null;
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
