import 'dart:io';
import 'package:cloud/models/media.dart';
import 'package:cloud/services/media.dart';
import 'package:cloud/services/supply.dart';
import 'package:dio/dio.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class SupplySupplierYanchangPage extends HookConsumerWidget {
  final int? supplierId;
  const SupplySupplierYanchangPage({super.key, this.supplierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierMedias = useMemoized(() => [
          {'title': '场地实拍', 'collection_name': 'site_photos'},
          {'title': '样品间实拍', 'collection_name': 'showroom_photos'},
          {'title': '设备实拍', 'collection_name': 'device_photos'},
        ]);

    final mediaMapState = useState<Map<String, List<Media>>>({
      'site_photos': [],
      'showroom_photos': [],
      'device_photos': [],
    });

    // 辅助函数：更新状态
    void updateMediaList(String collectionName, List<Media> newList) {
      final newMap = Map<String, List<Media>>.from(mediaMapState.value);
      newMap[collectionName] = newList;
      mediaMapState.value = newMap;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: supplierMedias.map((item) {
          final String title = item['title']!;
          final String collectionName = item['collection_name']!;
          final List<Media> currentList =
              mediaMapState.value[collectionName] ?? [];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _LocalImageUploader<Media>(
                    value: currentList,
                    maxCount: 9, // 限制最大张数

                    urlExtractor: (media) => media.thumbUrl ?? media.url ?? '',

                    onChanged: (newList) =>
                        updateMediaList(collectionName, newList),

                    onUpload: (File file) async {
                      try {
                        String fileName = file.path.split('/').last;
                        FormData formData = FormData.fromMap({
                          "file": await MultipartFile.fromFile(file.path,
                              filename: fileName),
                          "collection_name": collectionName,
                        });

                        final result = await uploadSupplySupplierYanChang(
                            supplierId!, formData as Map<String, dynamic>?);
                        return result;
                      } catch (e) {
                        EasyLoading.showError("上传失败");
                        return null;
                      }
                    },

                    onItemRemove: (media) async {
                      final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) {
                            return Text('123');
                          });

                      if (confirm != true) return false;

                      EasyLoading.show(status: '移除中...');
                      try {
                        if (media.id == null) return true;

                        await deleteMedia(media.id!, {});

                        EasyLoading.showSuccess('移除成功');
                        return true;
                      } catch (e) {
                        return false;
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

typedef ImageUrlExtractor<T> = String Function(T item);
typedef UploadHandler<T> = Future<T?> Function(File file);
typedef RemoveHandler<T> = Future<bool> Function(T item);

class _LocalImageUploader<T> extends StatelessWidget {
  final int? maxCount;
  final List<T>? value;
  final ValueChanged<List<T>>? onChanged;
  final UploadHandler<T> onUpload;
  final ImageUrlExtractor<T> urlExtractor;
  final RemoveHandler<T>? onItemRemove;

  const _LocalImageUploader({
    super.key,
    this.maxCount,
    this.value,
    this.onChanged,
    required this.onUpload,
    required this.urlExtractor,
    this.onItemRemove,
  });

  @override
  Widget build(BuildContext context) {
    final currentImages = value ?? [];
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    Future<void> processAndUploadEntities(List<AssetEntity> entities) async {
      final List<T> uploadedItems = [];

      for (final entity in entities) {
        final File? file = await entity.file;
        if (file != null) {
          final T? result = await onUpload(file);
          if (result != null) {
            uploadedItems.add(result);
          }
        }
      }

      if (uploadedItems.isNotEmpty) {
        onChanged?.call([...currentImages, ...uploadedItems]);
      }
    }

    Future<void> handlePickAndUpload() async {
      if (remainingCount <= 0) return;

      await showFlanActionSheet(
        context,
        cancelText: "取消",
        actions: [
          FlanActionSheetAction(
            name: "拍摄",
            callback: (_) async {
              final AssetEntity? entity = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: const CameraPickerConfig(enableRecording: false),
              );
              if (context.mounted) Navigator.maybePop(context);
              if (entity != null) await processAndUploadEntities([entity]);
            },
          ),
          FlanActionSheetAction(
            name: "从手机相册选择",
            callback: (_) async {
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                  maxAssets: remainingCount,
                  requestType: RequestType.image,
                ),
              );
              if (context.mounted) Navigator.maybePop(context);
              if (result != null) await processAndUploadEntities(result);
            },
          ),
        ],
      );
    }

    Future<void> handleDelete(int index) async {
      final item = currentImages[index];

      if (onItemRemove != null) {
        final bool success = await onItemRemove!(item);
        if (!success) return;
      }

      final newImageList = [...currentImages];
      newImageList.removeAt(index);
      onChanged?.call(newImageList);
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(currentImages.length, (index) {
          final url = urlExtractor(currentImages[index]);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  showFlanImagePreview(context,
                      images:
                          currentImages.map((e) => urlExtractor(e)).toList(),
                      startPosition: index);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => handleDelete(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ],
                    ),
                    child:
                        const Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
        if (remainingCount > 0)
          GestureDetector(
            onTap: handlePickAndUpload,
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
          ),
      ],
    );
  }
}
