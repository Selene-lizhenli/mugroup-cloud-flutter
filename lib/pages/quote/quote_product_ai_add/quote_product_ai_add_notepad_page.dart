import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductAiAddNotepadPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddNotepadPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryBlue = Color(0xFF4080FF);
    const Color bgGrey = Color(0xFFF5F5F5);
    const Color textGrey = Color(0xFF666666);

    final supplierController = useTextEditingController();

    final selectedSupplierState = useState<Map<String, dynamic>?>(null);

    final imageList = useState<List<TemporaryMedia>?>(null);

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        title: const Text(
          'AI自动录入产品',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFFEef6FF),
              child: const Row(
                children: [
                  Icon(Icons.volume_up_outlined, color: primaryBlue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '您正在使用AI录入功能，信息将会由自动识别录入!!!',
                      style: TextStyle(color: primaryBlue, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. 橙色状态 Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      border: const Border(
                        left: BorderSide(color: Colors.orange, width: 4),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '当前录入模式：记事本',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.description, color: Colors.white),
                      label: const Text(
                        '上传记事本页',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A72E0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Row(
                    children: [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Text('供应商',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: supplierController,
                            readOnly: true,
                            onTap: () async {
                              final Map<String, dynamic>? result =
                                  await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const SupplierSelect(),
                              );

                              if (result != null) {
                                supplierController.text = result['name'] ?? '';

                                selectedSupplierState.value = result;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: '输入供应商名称搜索或添加',
                              hintStyle:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                              prefixIcon: Icon(Icons.search,
                                  size: 20, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5), // 深蓝色
                          minimumSize: const Size(80, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('SKU设置',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '整页报价单图片',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '上传整页报价单图片，系统将自动识别并录入产品信息',
                            style: TextStyle(color: textGrey, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ImageUploader(
                          value: imageList.value,
                          onChanged: (value) {
                            imageList.value = value;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              disabledBackgroundColor: const Color(0xFFCCCCCC),
                              disabledForegroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              elevation: 0,
                            ),
                            child: const Text(
                              '提交识别',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
