import 'dart:io';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/field_selector.dart';
import 'package:cloud/pages/widgets/image_uploader_light.dart';
import 'package:cloud/pages/widgets/video_uploader.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/services/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InspectionItemNormalPage extends HookConsumerWidget {
  final int id;
  final InspectionItem? inspectionItem;
  final Map<String, List<TemporaryMedia>> mediaMap;
  final void Function(String key, List<TemporaryMedia> medias) onMediaChanged;

  const InspectionItemNormalPage({
    super.key,
    required this.id,
    this.inspectionItem,
    required this.mediaMap,
    required this.onMediaChanged,
  });

  static const _cText = Color(0xFF333333);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color primaryColor = colorScheme.primary;

    return Column(
      children: [
        _PhotoCard(
          blue: primaryColor,
          text: _cText,
          mediaMap: mediaMap,
          onMediaChanged: onMediaChanged,
        ),
      ],
    );
  }
}

class _PhotoCard extends HookConsumerWidget {
  final Color blue;
  final Color text;
  final Map<String, List<TemporaryMedia>> mediaMap;
  final void Function(String key, List<TemporaryMedia> list) onMediaChanged;

  const _PhotoCard({
    required this.blue,
    required this.text,
    required this.mediaMap,
    required this.onMediaChanged,
  });

  static const Set<String> _photoKeys = {
    'shipping_mark_front',
    'shipping_mark_side',
    'unboxing',
    'barcode_label',
    'weight_proof',
    'cover',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'inspection_item_confirm_v1',
          defaultFields: inspectionDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);
    final colorScheme = Theme.of(context).colorScheme;

    const String videoKey = 'inspection_video';

    // 状态：是否直接拍照 (默认为 true)
    final isDirectCamera = useState(true);

    // 智能分发图片到字段，用于连拍后按顺序填充图片
    Future<void> distributeFilesToFields(
      List<FieldConfig> targetFields,
      List<File> files,
    ) async {
      if (files.isEmpty) return;

      try {
        EasyLoading.show(status: '正在智能分发...');

        int fileIndex = 0;

        for (final field in targetFields) {
          if (fileIndex >= files.length) break;

          final file = files[fileIndex];
          final media = await upload(file: file);
          onMediaChanged(field.name, [media]);
          fileIndex++;
        }

        if (fileIndex < files.length) {
          final remainingFiles = files.sublist(fileIndex);
          final List<TemporaryMedia> newDetails = [];

          for (final file in remainingFiles) {
            final media = await upload(file: file);
            newDetails.add(media);
          }

          final currentDetails = mediaMap['details'] ?? [];
          onMediaChanged('details', [...currentDetails, ...newDetails]);
        }

        EasyLoading.showSuccess('分发完成');
      } catch (e) {
        EasyLoading.showError('处理失败');
        debugPrint(e.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }

    final visibleFields = useMemoized(
      () => fieldConfigs
          .where((f) => f.isVisible && _photoKeys.contains(f.name))
          .toList(),
      [fieldConfigs],
    );

    final unfilledFields = useMemoized(
      () => visibleFields
          .where((field) => (mediaMap[field.name] ?? []).isEmpty)
          .toList(),
      [visibleFields, mediaMap],
    );

    void handleMediaSwap(MediaDragData source, MediaDragData target) {
      if (source.key == target.key && source.index == target.index) return;

      final sourceList = List<TemporaryMedia>.from(mediaMap[source.key] ?? []);
      final targetList = List<TemporaryMedia>.from(mediaMap[target.key] ?? []);

      if (source.index >= sourceList.length) return;

      final sourceMedia = sourceList[source.index];

      if (source.key == target.key) {
        // 同区域内拖拽
        sourceList.removeAt(source.index);
        sourceList.insert(target.index, sourceMedia);
        onMediaChanged(source.key, sourceList);
      } else {
        // 网格拖到底部 details，或者底部 details 拖到网格
        TemporaryMedia? targetMedia =
            target.index < targetList.length ? targetList[target.index] : null;

        if (targetMedia != null) {
          sourceList[source.index] = targetMedia;
        } else {
          sourceList.removeAt(source.index);
        }

        if (targetMedia != null) {
          targetList[target.index] = sourceMedia;
        } else {
          targetList.add(sourceMedia);
        }

        onMediaChanged(source.key, sourceList);
        onMediaChanged(target.key, targetList);
      }
    }

    return _BaseCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double spacing = 12.0;
          final double itemSize =
              ((totalWidth - (spacing * 2)) / 3).floorToDouble();

          final detailsList = mediaMap['details'] ?? [];

          // 汇总已拍摄的必拍字段图片（不含「其他验货图片」），预览时可左右翻动
          final List<TemporaryMedia> fieldPreviewGallery = [];
          for (final field in visibleFields) {
            final images = mediaMap[field.name] ?? [];
            if (images.isEmpty) continue;
            fieldPreviewGallery
                .add(images.length > 1 ? images.last : images.first);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部行：标题 + (切换按钮 & 字段设置)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧：标题
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end, // 让提示文字对齐标题底部
                    children: [
                      _TitleRow(
                        icon: Icons.camera_alt_outlined,
                        title: '验货图片',
                        color: blue,
                        textColor: text,
                      ),
                      const SizedBox(width: 6), // 间距
                      const Padding(
                        padding:
                            EdgeInsets.only(bottom: 2), // 微调底部距离，使其视觉上与文字基线对齐
                        child: Text(
                          '  (长按相机开启连拍)',
                          style: TextStyle(
                            fontSize: 12, // 小字号
                            color: accentTealDeepColor,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(2),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFF5F6FA),
                        //     borderRadius: BorderRadius.circular(16),
                        //   ),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       _buildToggleItem(
                        //         label: '拍照',
                        //         isActive: isDirectCamera.value,
                        //         icon: Icons.check,
                        //         color: blue,
                        //         onTap: () => isDirectCamera.value = true,
                        //       ),
                        //       _buildToggleItem(
                        //         label: '相册',
                        //         isActive: !isDirectCamera.value,
                        //         icon: Icons.radio_button_unchecked,
                        //         color: blue,
                        //         onTap: () => isDirectCamera.value = false,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context)
                                    .size
                                    .width, // 底部抽屉宽度占满屏幕
                              ),
                              builder: (ctx) {
                                return FieldSelector(
                                  fields: fieldConfigs,
                                  defaultFields: inspectionDefaultFields,
                                  onConfigChanged:
                                      (List<FieldConfig> newConfigs) {
                                    notifier.updateConfigs(newConfigs);
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.settings,
                                  size: 16,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                "设置",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: totalWidth,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: spacing,
                  runSpacing: 16.0,
                  children: visibleFields.map((field) {
                    final pendingFields = unfilledFields;
                    return _buildGridItem(
                      key: ValueKey(field.name),
                      apiKey: field.name,
                      label: field.label,
                      width: itemSize,
                      isDirectCamera: isDirectCamera.value,
                      mediaMap: mediaMap,
                      onMediaChanged: onMediaChanged,
                      enableContinuous: true,
                      pendingFields: pendingFields,
                      onSwap: handleMediaSwap,
                      distributeFilesToFields: distributeFilesToFields,
                      visibleFields: visibleFields,
                      previewGallery: fieldPreviewGallery,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('其他验货图片',
                          style: TextStyle(
                              color: text, fontWeight: FontWeight.w500)),
                      Text('${detailsList.length}/50张',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ImageUploaderInspection(
                    label: null,
                    maxCount: 50,
                    enableContinuousWithGyroscopeWithoutSize: false,
                    value: detailsList,
                    customIcon: Icons.camera_alt,
                    enableContinuous: true,
                    showContinuousOption: true,
                    enableWrapLayout: true,
                    // 不传 onContinuousCapture：连拍/拍摄结果全部进入「其他验货图片」
                    onChanged: (list) => onMediaChanged('details', list),
                    uploaderKey: 'details',
                    onSwap: handleMediaSwap,
                    // preserveGallerySelectionOrder: false,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TitleRow(
                        icon: Icons.video_camera_back_outlined,
                        title: '验货视频',
                        color: blue,
                        textColor: text,
                      ),
                      Text('${mediaMap[videoKey]?.length ?? 0}/1个',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  VideoUploader(
                    label: null,
                    maxCount: 1,
                    value: mediaMap[videoKey] ?? [],
                    onChanged: (newList) => onMediaChanged(videoKey, newList),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridItem({
    Key? key,
    required String apiKey,
    required String label,
    required double width,
    required bool isDirectCamera,
    required bool enableContinuous,
    required Map<String, List<TemporaryMedia>> mediaMap,
    required void Function(String key, List<TemporaryMedia> list)
        onMediaChanged,
    required void Function(MediaDragData source, MediaDragData target) onSwap,
    required List<FieldConfig> pendingFields,
    required Future<void> Function(List<FieldConfig>, List<File>)
        distributeFilesToFields,
    required List<FieldConfig> visibleFields,
    required List<TemporaryMedia> previewGallery,
  }) {
    List<TemporaryMedia> currentImages = mediaMap[apiKey] ?? [];

    if (apiKey != 'details' && currentImages.length > 1) {
      currentImages = [currentImages.last];
    }

    return SizedBox(
      key: key,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label图片',
            style: TextStyle(
              fontSize: 13,
              color: text,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ImageUploaderInspection(
                label: null,
                maxCount: 1,
                maxAssetsForGallery: 99,
                customIcon: Icons.camera_alt,
                value: currentImages,
                showContinuousOption: true,
                enableContinuous: enableContinuous,
                pendingCaptureFieldLabels:
                    pendingFields.map((field) => field.label).toList(),
                previewGallery: previewGallery,
                onChanged: (list) => _distributeNewImagesToFields(
                  apiKey: apiKey,
                  list: list,
                  mediaMap: mediaMap,
                  visibleFields: visibleFields,
                  onMediaChanged: onMediaChanged,
                ),
                onContinuousCapture: (files) =>
                    distributeFilesToFields(pendingFields, files),
                uploaderKey: apiKey,
                onSwap: onSwap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 字段图片变更：单张直接写入当前字段；多张依次填入当前及后续空字段，超出归入其他验货图片。
  void _distributeNewImagesToFields({
    required String apiKey,
    required List<TemporaryMedia> list,
    required Map<String, List<TemporaryMedia>> mediaMap,
    required List<FieldConfig> visibleFields,
    required void Function(String key, List<TemporaryMedia> list)
        onMediaChanged,
  }) {
    final previousImages = mediaMap[apiKey] ?? [];
    final previousIds = previousImages.map((m) => m.id).toSet();
    final newImages =
        list.where((m) => !previousIds.contains(m.id)).toList();

    if (newImages.isEmpty) {
      onMediaChanged(apiKey, list);
      return;
    }

    if (newImages.length == 1) {
      onMediaChanged(apiKey, newImages);
      return;
    }

    final currentIndex =
        visibleFields.indexWhere((f) => f.name == apiKey);
    final candidateFields = currentIndex >= 0
        ? visibleFields.sublist(currentIndex)
        : <FieldConfig>[];

    int imageIdx = 0;
    for (final field in candidateFields) {
      if (imageIdx >= newImages.length) break;
      final existing = mediaMap[field.name] ?? [];
      // 当前字段始终填入；后续字段仅在为空时填入
      if (field.name != apiKey && existing.isNotEmpty) continue;
      onMediaChanged(field.name, [newImages[imageIdx]]);
      imageIdx++;
    }

    if (imageIdx < newImages.length) {
      final overflow = newImages.sublist(imageIdx);
      final currentDetails =
          List<TemporaryMedia>.from(mediaMap['details'] ?? []);
      final totalAfter = currentDetails.length + overflow.length;
      if (totalAfter > 50) {
        EasyLoading.showError('其他验货图片已达上限50张，部分图片未能添加');
        final canAdd = 50 - currentDetails.length;
        if (canAdd > 0) {
          currentDetails.addAll(overflow.take(canAdd));
          onMediaChanged('details', currentDetails);
        }
      } else {
        currentDetails.addAll(overflow);
        onMediaChanged('details', currentDetails);
      }
    }
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: child,
      );
}

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  const _TitleRow(
      {required this.icon,
      required this.title,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1)),
        ],
      );
}
