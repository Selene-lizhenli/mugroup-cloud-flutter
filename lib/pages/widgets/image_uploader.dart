import 'dart:io';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ImageUploader extends HookConsumerWidget {
  final String? label;
  final int? maxCount;
  final List<TemporaryMedia>? value;
  final ValueChanged<List<TemporaryMedia>>? onChanged;
  // --- 图片识别参数 ---
  final bool showRecognizeButton;
  final Future<dynamic> Function(Map<String, dynamic>)? recognizeApi;
  final ValueChanged<dynamic>? onRecognizeResult;

  final String? errorText;

  const ImageUploader({
    super.key,
    this.label,
    this.maxCount,
    this.value,
    this.onChanged,
    this.showRecognizeButton = false,
    this.recognizeApi,
    this.onRecognizeResult,
    this.errorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImages = value ?? [];
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    // 判断当前是否有错误信息
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    Future<void> processAndUploadEntities(List<AssetEntity> entities) async {
      final List<TemporaryMedia> uploadedMedias = [];

      for (final entity in entities) {
        final File? file = await entity.file;

        if (file != null) {
          try {
            EasyLoading.show(status: '上传中...');
            final TemporaryMedia temporaryMedia = await upload(file: file);
            uploadedMedias.add(temporaryMedia);
          } finally {
            EasyLoading.dismiss();
          }
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

    void handleDelete(int index) async {
      final bool confirm = await ConfirmDialog.show(
        context,
        content: '确定要移除这张图片吗？',
      );

      if (confirm != true) return;

      final newImageList = [...currentImages];
      var item = newImageList[index];

      if (item.uuid == null) {
        await deleteMedia(item.id, {});
      }

      newImageList.removeAt(index);
      onChanged?.call(newImageList);
    }

    Future<void> handleSmartRecognize() async {
      // 1. 校验是否有图片
      if (currentImages.isEmpty) {
        EasyLoading.showInfo("请先上传图片");
        return;
      }

      if (recognizeApi == null) {
        debugPrint('ImageUploader: recognizeApi is null');
        return;
      }

      await EasyLoading.show(
          status: '智能识别中...', maskType: EasyLoadingMaskType.clear);

      final result = await recognizeApi!({'image': currentImages});

      // 5. 回调结果
      if (result != null && onRecognizeResult != null) {
        EasyLoading.showSuccess("识别成功");
        onRecognizeResult!(result);
      } else {
        EasyLoading.dismiss();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showRecognizeButton) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右对齐
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                )
              else
                const SizedBox(), // 占位

              if (showRecognizeButton)
                GestureDetector(
                  onTap: handleSmartRecognize,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.center_focus_weak,
                            size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          "智能识别",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
                context,
                index,
                item.thumbUrl ?? item.url,
                onRemove: () => handleDelete(index),
              );
            }),

            // 渲染添加按钮 (如果没有达到最大限制)
            if (remainingCount > 0)
              _buildAddButton(
                onTap: handlePickAndUpload,
                hasError: hasError, // 传递错误状态，改变按钮样式
              ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 2.0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error, // 使用主题的错误色(通常是红色)
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // 子组件：单个图片预览
  Widget _buildImageItem(BuildContext context, int index, String? url,
      {required VoidCallback onRemove}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            showFlanImagePreview(
              context,
              images: value!.map((e) => e.url).toList(),
              startPosition: index,
              loop: false,
            );
          },
          child: Container(
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
  Widget _buildAddButton({required VoidCallback onTap, bool hasError = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(6),
          // 如果有错误，边框变红
          border: Border.all(
            color: hasError ? Colors.red : const Color(0xFFD9D9D9),
            width: hasError ? 1.2 : 1.0, // 错误时边框稍微加粗一点点
          ),
        ),
        child: const Icon(Icons.add, color: Color(0xFF999999), size: 28),
      ),
    );
  }
}
