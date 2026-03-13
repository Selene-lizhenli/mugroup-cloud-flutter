import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddSupplierSheet extends HookConsumerWidget {
  final int? quotationId;

  const AddSupplierSheet({
    super.key,
    this.quotationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // 状态定义
    final supplierName = useState('');
    final shopNumber = useState('');
    final businessCard = useState<List<TemporaryMedia>>([]);
    final selectedSupplierId = useState<String?>(null);

    // 联想搜索状态
    final searchResults = useState<List<dynamic>>([]);
    final isSearching = useState(false);

    // 焦点与滚动控制
    final supplierNameFocus = useFocusNode();
    final shopNumberFocus = useFocusNode();
    final mainScrollController = useScrollController();

    // 环境信息
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // 处理选中逻辑（模型对象转 Map）
    void handleSelectFromModel(dynamic model) {
      selectedSupplierId.value = model.id?.toString();
      supplierName.value = model.name ?? '';
      shopNumber.value = model.stallAddress ?? '';
      searchResults.value = [];
      FocusScope.of(context).unfocus();
    }

    // 处理选中逻辑（原生 Map）
    void handleSelect(Map<String, dynamic> result) {
      selectedSupplierId.value = result['id']?.toString();
      supplierName.value = result['name']?.toString() ?? '';
      shopNumber.value = result['stall_address']?.toString() ?? '';
      searchResults.value = [];
      FocusScope.of(context).unfocus();
    }

    // 防抖搜索逻辑
    useEffect(() {
      Timer? debounce;
      Future<void> fetchSuggestions() async {
        if (supplierName.value.trim().isEmpty ||
            selectedSupplierId.value != null) {
          searchResults.value = [];
          isSearching.value = false;
          return;
        }

        isSearching.value = true; // 开始搜索
        try {
          final resp = await getSupplySuppliers(queryParameters: {
            "search": supplierName.value.trim(),
            "per_page": 5,
          });
          searchResults.value = resp.data;
        } catch (e) {
          debugPrint('联想搜索失败: $e');
        } finally {
          isSearching.value = false; // 搜索结束
        }
      }

      debounce = Timer(const Duration(milliseconds: 500), fetchSuggestions);
      return () => debounce?.cancel();
    }, [supplierName.value]);

    void forceScrollToBottom() {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mainScrollController.hasClients) {
          mainScrollController.animateTo(
            mainScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    useEffect(() {
      void listener() {
        if (shopNumberFocus.hasFocus) forceScrollToBottom();
      }

      shopNumberFocus.addListener(listener);
      return () => shopNumberFocus.removeListener(listener);
    }, [shopNumberFocus]);

    void onSubmit() async {
      if (supplierName.value.trim().isEmpty) {
        supplierNameFocus.requestFocus();
        return;
      }
      try {
        if (selectedSupplierId.value != null) {
          Navigator.pop(context);
          await context.router.push(QuoteProductNewAddRoute(
            quoteId: quotationId,
            supplierId: selectedSupplierId.value!,
          ));
          return;
        }

        final data = <String, dynamic>{
          'name': supplierName.value.trim(),
          'collection_name': "bussiness_card",
          'stall_address': shopNumber.value.trim(),
          'item_type': "market"
        };

        if (businessCard.value.isNotEmpty) {
          data['images'] = businessCard.value
              .map((e) => {...e.toJson(), 'collection_name': 'bussiness_card'})
              .toList();
        }

        final supplier = await storeSupplySupplier(data);

        if (supplier != null && context.mounted) {
          Navigator.of(context).pop(supplier.toJson());
          if (supplier.id != null || quotationId != null) {
            await context.router.push(QuoteProductNewAddRoute(
              quoteId: quotationId,
              supplierId: supplier.id.toString(),
            ));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('操作失败: ${e.toString()}')),
          );
        }
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: isKeyboardOpen ? screenHeight * 0.9 : screenHeight * 0.85,
        minHeight: isKeyboardOpen ? screenHeight * 0.7 : 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('添加供应商',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              controller: mainScrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: keyboardHeight + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUploader(
                    maxCount: 1,
                    customIcon: Icons.camera_alt,
                    recognizeAtBottom: true,
                    enableContinuous: true,
                    autoRecognize: true,
                    recognizeApi: identifySupplierShopCard,
                    onRecognizeResult: (data) {
                      if (data != null && data is Map<String, dynamic>) {
                        selectedSupplierId.value = null;
                        if (data['supplier_name'] != null) {
                          supplierName.value = data['supplier_name'].toString();
                        }
                        if (data['stall_address'] != null) {
                          shopNumber.value = data['stall_address'].toString();
                        }
                      }
                    },
                    value: businessCard.value,
                    onChanged: (value) => businessCard.value = value,
                  ),
                  const SizedBox(height: 20),

                  // 供应商名称输入区
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Input(
                              label: '供应商名称',
                              value: supplierName.value,
                              onChanged: (value) {
                                supplierName.value = value;
                                selectedSupplierId.value = null;
                              },
                              focusNode: supplierNameFocus,
                              hintText: '请输入供应商名称',
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),

                      // 优化后的联想搜索展示 (含加载效果)
                      if ((searchResults.value.isNotEmpty ||
                              isSearching.value) &&
                          selectedSupplierId.value == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(maxHeight: 240),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 面板顶部状态条
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  color: colorScheme.primary.withOpacity(0.05),
                                  child: Row(
                                    children: [
                                      isSearching.value
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : Icon(Icons.lightbulb_outline,
                                              size: 14,
                                              color: colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                          isSearching.value
                                              ? '正在匹配供应商...'
                                              : '系统发现匹配的现有供应商',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                // 加载进度条
                                if (isSearching.value)
                                  LinearProgressIndicator(
                                    minHeight: 2,
                                    backgroundColor: Colors.transparent,
                                    color: colorScheme.primary.withOpacity(0.3),
                                  ),
                                // 结果列表
                                if (searchResults.value.isNotEmpty)
                                  Flexible(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: searchResults.value.length,
                                      separatorBuilder: (c, i) => Divider(
                                          height: 1,
                                          indent: 16,
                                          endIndent: 16,
                                          color: Colors.grey.shade100),
                                      itemBuilder: (context, index) {
                                        final item = searchResults.value[index];
                                        final String name = item.name ?? '';
                                        final String address =
                                            item.stallAddress ?? '';

                                        return InkWell(
                                          onTap: () =>
                                              handleSelectFromModel(item),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor:
                                                      Colors.grey.shade50,
                                                  child: Icon(
                                                      Icons.storefront_outlined,
                                                      size: 18,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(name,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF222222))),
                                                      if (address.isNotEmpty)
                                                        Text(address,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.primary
                                                        .withOpacity(0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text('选取',
                                                      style: TextStyle(
                                                          color: colorScheme
                                                              .primary,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Input(
                    label: '店铺号',
                    value: shopNumber.value,
                    onChanged: (value) => shopNumber.value = value,
                    focusNode: shopNumberFocus,
                    hintText: '请输入店铺号',
                  ),
                  const SizedBox(height: 32),

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('取消',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedSupplierId.value != null
                                ? Colors.orange.shade700
                                : colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                              selectedSupplierId.value != null
                                  ? '使用现有'
                                  : '保存供应商',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
