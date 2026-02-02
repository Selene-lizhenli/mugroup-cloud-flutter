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

    final supplierName = useState('');
    final shopNumber = useState('');
    final businessCard = useState<List<TemporaryMedia>>([]);
    final supplierNameFocus = useFocusNode();

    final minHeight = MediaQuery.of(context).size.height * 0.65;

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
          'stall_address': shopNumber.value.trim(),
        };
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
          if (supplier.id != null) {
            await context.router.push(
              QuoteProductNewAddRoute(
                quoteId: quotationId,
                supplierId: supplier.id.toString(),
              ),
            );
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

    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: minHeight,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Color.fromARGB(255, 245, 245, 245)),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ImageUploader(
                          directCamera: true,
                          maxCount: 1,
                          customIcon: Icons.camera_alt,
                          recognizeAtBottom: true,
                          enableContinuous: true,
                          showRecognizeButton: true,
                          recognizeApi: identifySupplierShopCard,
                          onRecognizeResult: (data) {
                            if (data != null && data is Map<String, dynamic>) {
                              // 更新供应商名称
                              if (data['supplier_name'] != null) {
                                supplierName.value =
                                    data['supplier_name'].toString();
                              }
                              if (data['stall_address'] != null) {
                                shopNumber.value =
                                    data['stall_address'].toString();
                              }
                            }
                          },
                          value: businessCard.value,
                          onChanged: (value) => businessCard.value = value,
                        ),
                      ),
                      const SizedBox(height: 8),
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

                      const SizedBox(height: 8),
                      Row(
                        children: [
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

                      const SizedBox(height: 16),
                      // 底部按钮
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
