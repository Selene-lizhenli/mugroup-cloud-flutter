import 'package:cloud/pages/inspection/widgets/add_sku_task.dart';
import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InspectionAddSku extends ConsumerWidget {
  final int id;
  const InspectionAddSku({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          AddSkuTask(
            onSubmit: (data) async {
              try {
                if (data.tabIndex == 0) {
                  final skuList = data.skuList;
                  if (skuList == null || skuList.isEmpty) return;
                  await addInspectionItems(id, {'item_nos': skuList});
                } else {
                  final file = data.selectedFile;
                  if (file == null || file.path == null) return;

                  final formData = FormData.fromMap({
                    'file': await MultipartFile.fromFile(
                      file.path!,
                      filename: file.name,
                    ),
                  });
                  await importInspectionItems(id, formData);
                }

                EasyLoading.showSuccess('添加成功');
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                EasyLoading.showError('操作失败: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('添加 SKU',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
