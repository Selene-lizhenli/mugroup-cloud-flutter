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

    // 1. 焦点与滚动控制
    final supplierNameFocus = useFocusNode();
    final shopNumberFocus = useFocusNode();
    final scrollController = useScrollController();

    // 获取环境信息
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    void forceScrollToBottom() {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    useEffect(() {
      void listener() {
        if (shopNumberFocus.hasFocus) {
          forceScrollToBottom();
        }
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: isKeyboardOpen ? screenHeight * 0.9 : screenHeight * 0.8,
        minHeight: isKeyboardOpen ? screenHeight * 0.7 : 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('添加供应商',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 内容区域
          Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: keyboardHeight + 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUploader(
                    directCamera: true,
                    maxCount: 1,
                    customIcon: Icons.camera_alt,
                    recognizeAtBottom: true,
                    enableContinuous: true,
                    showRecognizeButton: true,
                    recognizeApi: identifySupplierShopCard,
                    onRecognizeResult: (data) {
                      if (data != null && data is Map<String, dynamic>) {
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
                  const SizedBox(height: 16),
                  Input(
                    label: '供应商名称',
                    value: supplierName.value,
                    onChanged: (value) => supplierName.value = value,
                    focusNode: supplierNameFocus,
                    hintText: '请输入供应商名称',
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  Input(
                    label: '店铺号',
                    value: shopNumber.value,
                    onChanged: (value) => shopNumber.value = value,
                    // 绑定焦点 Node
                    focusNode: shopNumberFocus,
                    hintText: '请输入店铺号',
                  ),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, colorScheme, supplierName,
                      shopNumber, businessCard, onSubmit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      context, colorScheme, supplierName, shopNumber, businessCard, onSubmit) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('创建供应商'),
          ),
        ),
      ],
    );
  }
}
