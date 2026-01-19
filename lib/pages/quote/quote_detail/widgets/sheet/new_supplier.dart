import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
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
 
    final supplierName = useState('');
    final area = useState('');
    final shopNumber = useState('');
    final businessCard = useState<List<TemporaryMedia>>([]); 
    final quoteDetailState = ref.watch(quoteDetailProvider);
    final supplierNameFocus = useFocusNode();

    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [ 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    ),
                  ],
                ),
              ),

              // 内容区域，使用 Expanded 让下方可滚动，自适应校验提示高度
              Expanded(
                child: _buildCreateForm(
                  context,
                  supplierName,
                  area,
                  shopNumber,
                  businessCard,
                  colorScheme,
                  theme,
                  quoteDetailState, 
                  supplierNameFocus,
                ),
              ),
            ],
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
    FocusNode supplierNameFocus,
  ) {
    void onSubmit() async { 
      if (supplierName.value.trim().isEmpty) { 
        supplierNameFocus.requestFocus();
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
              onChanged: (value) {
                supplierName.value = value; 
              }, 
              focusNode: supplierNameFocus,
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
}
