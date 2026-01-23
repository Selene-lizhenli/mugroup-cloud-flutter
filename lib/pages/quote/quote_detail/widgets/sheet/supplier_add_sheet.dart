import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplierAddSheet extends HookConsumerWidget {
  final int? quotationId;

  const SupplierAddSheet({
    super.key,
    this.quotationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final selectedTab = useState(0); // 0: 新建供应商, 1: 选择已有

    // 表单状态
    final supplierName = useState('');
    final area = useState('');
    final shopNumber = useState('');
    final businessCard = useState<List<TemporaryMedia>>([]);

    final screenHeight = MediaQuery.of(context).size.height;

    final quoteDetailState = ref.watch(quoteDetailProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.6,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题栏
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '添加供应商',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // 标签页
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    _buildTab(
                      context,
                      '新建供应商',
                      isSelected: selectedTab.value == 0,
                      onTap: () => selectedTab.value = 0,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(width: 24),
                    _buildTab(
                      context,
                      '选择已有',
                      isSelected: selectedTab.value == 1,
                      onTap: () => selectedTab.value = 1,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
              // 内容区域
              Flexible(
                child: selectedTab.value == 0
                    ? _buildCreateForm(
                        context,
                        supplierName,
                        area,
                        shopNumber,
                        businessCard,
                        colorScheme,
                        theme,
                        quoteDetailState,
                      )
                    : _buildSelectForm(
                        context, colorScheme, theme, quoteDetailState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : Colors.grey.shade600,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm(
    BuildContext context,
    ValueNotifier<String> supplierName,
    ValueNotifier<String> area,
    ValueNotifier<String> shopNumber,
    ValueNotifier<List<TemporaryMedia>> businessCard,
    ColorScheme colorScheme,
    ThemeData theme,
    QuoteDetailState quoteDetailState,
  ) {
    void onSubmit() async {
      // 验证供应商名称
      if (supplierName.value.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请输入供应商名称'),
          ),
        );
        return;
      }

      try {
        // 构建提交数据
        final data = <String, dynamic>{
          'name': supplierName.value.trim(),
          'collection_name': "bussiness_card",
        };

        // 处理档口位置
        if (area.value.isNotEmpty || shopNumber.value.isNotEmpty) {
          final stallAddress = [
            if (area.value.isNotEmpty) area.value,
            if (shopNumber.value.isNotEmpty) shopNumber.value,
          ].join(';');
          data['stall_address'] = stallAddress;
        }

        // 处理名片图片 - 转换为包含 collection_name 的格式
        if (businessCard.value.isNotEmpty) {
          data['images'] = businessCard.value
              .map((e) => {
                    ...e.toJson(),
                    'collection_name': 'bussiness_card',
                  })
              .toList();
        }

        final supplier = await storeSupplySupplier(data);
        if (supplier != null && context.mounted) {
          Navigator.pop(context);
          if (quotationId != null && supplier.id != null) {
            context.router.push(QuoteProductAddAdaptiveRoute( 
              supplierId: supplier.id.toString(),
              initialMode: 0, 
            ));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('创建供应商失败: ${e.toString()}'),
            ),
          );
        }
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 供应商名称
            Input(
              label: '供应商名称',
              value: supplierName.value,
              onChanged: (value) => supplierName.value = value,
              hintText: '请输入供应商名称',
              isRequired: true,
            ),
            const SizedBox(height: 12),
            // 档口位置
            Text(
              '档口位置',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Input(
                    label: '区域',
                    value: area.value,
                    onChanged: (value) => area.value = value,
                    hintText: '请输入区域',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(
                  child: Input(
                    label: '店铺号',
                    value: shopNumber.value,
                    onChanged: (value) => shopNumber.value = value,
                    hintText: '请输入店铺号',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 名片
            Text(
              '名片',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ImageUploader(
                directCamera: false,
                maxCount: 1,
                showRecognizeButton: false,
                recognizeApi: identifySupplySuppliersCard,
                onRecognizeResult: (data) {
                  if (data != null && data is Map<String, dynamic>) {
                    // 更新供应商名称
                    if (data['name'] != null) {
                      supplierName.value = data['name'].toString();
                    }
                    // 可以在这里添加其他字段的更新逻辑
                  }
                },
                value: businessCard.value,
                onChanged: (value) => businessCard.value = value,
              ),
            ),
            const SizedBox(height: 16),
            // 底部按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '创建供应商',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectForm(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    QuoteDetailState quoteDetailState,
  ) {
    final searchController = useTextEditingController();
    useListenable(searchController);
    final search = useState<String?>(null);
    final suppliers = useState<List<Supplier>?>(null);
    final isLoading = useState<bool>(true);
    final debounceTimer = useRef<Timer?>(null);

    // 加载供应商列表
    useEffect(() {
      Future<void> loadSuppliers() async {
        try {
          isLoading.value = true;
          final resp = await getSupplySuppliers(queryParameters: {
            "search": search.value,
          });
          suppliers.value = resp.data;
        } finally {
          isLoading.value = false;
        }
      }

      loadSuppliers();
      return () => debounceTimer.value?.cancel();
    }, [search.value]);

    void onSearchChanged(String val) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
        search.value = val.isEmpty ? null : val;
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 搜索框
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: '搜索名称、编号或相关产品...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon:
                    const Icon(Icons.search, size: 18, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel,
                            size: 16, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          debounceTimer.value?.cancel();
                          search.value = null;
                        },
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(minWidth: 32),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 供应商列表
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: isLoading.value
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: MuProgressIndicator(barWidth: 2),
                      ),
                    )
                  : (suppliers.value == null || suppliers.value!.isEmpty)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              "暂无数据",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 13),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: suppliers.value!.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final supplier = suppliers.value![index];
                            final supplierName =
                                supplier.shortName ?? supplier.name ?? '未知供应商';
                            final supplierId = supplier.id;
                            final supplierNo = supplier.supplierNo;

                            return InkWell(
                              onTap: () {
                                logger.d(
                                    'supplier_id: $supplierId, quotationId: $quotationId');
                                if (supplierId != null && quotationId != null) {
                                  // 关闭当前 sheet
                                  Navigator.pop(context);
                                  // 跳转到创建产品页面，传递供应商编号
                                  context.router
                                      .push(QuoteProductAddAdaptiveRoute( 
                                    supplierId: supplierId.toString(),
                                    initialMode: 0, 
                                  ));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            supplierName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (supplierNo != null) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              supplierNo,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colorScheme
                                                    .surfaceContainerHighest,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // 大于号图标，点击后跳转到创建产品页面
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey.shade400,
                                      size: 20,
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
    );
  }
}
