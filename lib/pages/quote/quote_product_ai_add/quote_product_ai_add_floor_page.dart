import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryBlue = Color(0xFF4080FF);
    const Color bgGrey = Color(0xFFF5F5F5);

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
            Row(
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUploader(
                        value: imageList.value,
                        onChanged: (value) {
                          imageList.value = value;
                        },
                      ),
                    ],
                  ),
                )),
              ],
            ),
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
                      '当前录入模式：地板/白板',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
