import 'dart:io';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ImageUploader extends HookConsumerWidget {
  final String name;
  final String? label;
  final int? maxCount;
  final List<TemporaryMedia>? value;
  final ValueChanged<List<TemporaryMedia>>? onChanged;

  const ImageUploader({
    super.key,
    required this.name,
    this.label,
    this.maxCount,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImages = value ?? [];
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    Future<void> processAndUploadEntities(List<AssetEntity> entities) async {
      final List<TemporaryMedia> uploadedMedias = [];

      for (final entity in entities) {
        final File? file = await entity.file;

        if (file != null) {
          final TemporaryMedia temporaryMedia = await upload(file: file);
          uploadedMedias.add(temporaryMedia);
        }
      }

      if (uploadedMedias.isNotEmpty) {
        final newImageList = [...currentImages, ...uploadedMedias];
        onChanged?.call(newImageList);
      }
    }

    Future<void> handlePickAndUpload() async {
      if (remainingCount <= 0) {
        return;
      }

      await showFlanActionSheet(
        context,
        cancelText: "取消",
        actions: [
          FlanActionSheetAction(
            name: "拍摄",
            callback: (action) async {
              final AssetEntity? entity =
                  await CameraPicker.pickFromCamera(context);

              if (context.mounted) Navigator.of(context).maybePop();

              if (entity == null) return;

              await processAndUploadEntities([entity]);
            },
          ),
          FlanActionSheetAction(
            name: "从手机相册选择",
            callback: (action) async {
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                  maxAssets: remainingCount,
                  requestType: RequestType.image,
                ),
              );

              if (context.mounted) Navigator.of(context).maybePop();

              if (result == null || result.isEmpty) return;

              // 异步处理上传
              await processAndUploadEntities(result);
            },
          ),
        ],
      );
    }

    void handleDelete(int index) {
      final newImageList = [...currentImages];
      newImageList.removeAt(index);
      onChanged?.call(newImageList);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // 渲染已存在的图片
            ...List.generate(currentImages.length, (index) {
              final item = currentImages[index];
              return _buildImageItem(
                item.thumbUrl ?? item.url,
                onRemove: () => handleDelete(index),
              );
            }),

            // 渲染添加按钮 (如果没有达到最大限制)
            if (remainingCount > 0) _buildAddButton(onTap: handlePickAndUpload),
          ],
        ),
      ],
    );
  }

  // 子组件：单个图片预览
  Widget _buildImageItem(String? url, {required VoidCallback onRemove}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: url != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
              : const Icon(Icons.image, color: Colors.grey),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // 子组件：添加按钮
  Widget _buildAddButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: const Icon(Icons.add, color: Color(0xFF999999), size: 28),
      ),
    );
  }
}
