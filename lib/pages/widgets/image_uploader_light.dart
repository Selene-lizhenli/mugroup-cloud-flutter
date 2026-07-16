import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:camera/camera.dart' as camera;
import 'package:camerawesome/camerawesome_plugin.dart' hide FlashMode;
import 'package:cloud/app/app.dart';
import 'package:cloud/helper/camera_capture.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/providers/setting_provider.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart' hide Sensors;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart' hide FlashMode;

/// 图片拖拽时携带的数据，用于标识来源分组与索引。
class MediaDragData {
  final String key;
  final int index;
  MediaDragData({required this.key, required this.index});
}

/// [removedItem] 仅在删除图片时传入，上传等其它场景不传。
typedef ImageUploaderValueChanged = void Function(
  List<TemporaryMedia> list, [
  TemporaryMedia? removedItem,
]);

//  验货专用拍照上传组件
/// 支持单拍、相册选择、连拍与拖拽排序、传感器原生/1:1 画幅、连拍限制最大张数、支持显示在拍内容。
/// 不支持智能识别、主图细节图。
///
/// 通过 [enableContinuousWithGyroscopeWithoutSize] 选择连拍页：
/// true → ContinuousCameraPageWithoutSize；false → ContinuousCameraPageOtherPhoto（全平台均为 wechat_camera_picker）。
class ImageUploaderInspection extends HookConsumerWidget {
  static const double defaultItemWidth = 80;
  static const double defaultItemHeight = 80;

  final String? label;
  final double? width;
  final double? height;
  final int? maxCount;
  final List<TemporaryMedia>? value;
  final ImageUploaderValueChanged? _onChanged;

  final String? errorText;

  // --- 核心控制参数 ---

  /// 连拍开关：
  /// true  => 允许长按进入连拍模式
  /// false => 长按无效果
  final bool enableContinuous;

  /// 是否使用无画幅切换的连拍相机：
  /// true  => [ContinuousCameraPageWithoutSize]（全平台 wechat，无画幅切换，可成片跟随横竖）
  /// false => [ContinuousCameraPageOtherPhoto]（全平台 wechat，可切换画幅，成片锁定竖屏）
  final bool enableContinuousWithGyroscopeWithoutSize;

  /// 仅对 [ContinuousCameraPageWithoutSize] 生效：进入时「成片跟随横竖」的默认值。
  /// true  => 默认：横拿出横图、竖拿出竖图
  /// false => 默认：成片锁定竖屏
  final bool enableContinuousGyroscopeRotation;

  final bool showContinuousOption;

  final IconData? customIcon;

  final String? uploaderKey;
  final void Function(MediaDragData source, MediaDragData target)? onSwap;

  /// 连拍完成后，调用父组件处理分发
  final void Function(List<File> files)? onContinuousCapture;

  /// 连拍最大张数；null 表示不限制
  final int? continuousMaxCount;

  ///  展示标签，连拍缩略图底部显示。
  final List<String>? pendingCaptureFieldLabels;

  /// 为 true 时根据可用宽度自动计算每行最多展示个数并换行；默认 false 单行展示。
  final bool enableWrapLayout;

  /// 为 true 时相册选图按选中顺序串行调用上传接口，保证结果顺序与选中一致。
  final bool preserveGallerySelectionOrder;

  /// 相册选择的最大张数，独立于 maxCount。当设置此值时，即使 maxCount 已满，
  /// 仍允许从相册选择多张图片（用于多选后分发到其他字段的场景）。
  final int? maxAssetsForGallery;

  /// 预览时使用的完整图集；为 null 时仅预览本组件 [value]。
  /// 用于跨字段左右翻动预览（如验货必拍字段汇总）。
  final List<TemporaryMedia>? previewGallery;

  final Widget? extraContent;
  final ValueChanged<bool>? onUploadingChanged;

  ImageUploaderInspection({
    super.key,
    this.label,
    this.width = defaultItemWidth,
    this.height = defaultItemHeight,
    this.maxCount,
    this.value,
    ValueChanged<List<TemporaryMedia>>? onChanged,
    ImageUploaderValueChanged? onMediaChanged,
    this.errorText,
    this.showContinuousOption = false,
    this.enableContinuous = false,
    this.enableContinuousWithGyroscopeWithoutSize = true,
    this.enableContinuousGyroscopeRotation = false,
    this.onContinuousCapture,
    this.continuousMaxCount,
    this.pendingCaptureFieldLabels, // 待拍摄的内容 label，连拍缩略图底部展示的标签，与待拍字段顺序一致。
    this.enableWrapLayout = false,
    this.preserveGallerySelectionOrder = false,
    this.maxAssetsForGallery,
    this.previewGallery,
    this.customIcon,
    this.uploaderKey,
    this.onSwap,
    this.extraContent,
    this.onUploadingChanged,
  })  : assert(
          onChanged == null || onMediaChanged == null,
          'onChanged 与 onMediaChanged 只能传一个',
        ),
        _onChanged = onMediaChanged ??
            (onChanged == null
                ? null
                : (list, [removedItem]) => onChanged(list));

  void _notifyChanged(List<TemporaryMedia> list,
      [TemporaryMedia? removedItem]) {
    _onChanged?.call(list, removedItem);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImages = useMemoized(() => value ?? [], [value]);
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    final bool hasError =
        (errorText?.isNotEmpty ?? false) && currentImages.isEmpty;

    // --- 内部方法：上传文件 (用于连拍/普通拍摄) ---
    Future<void> uploadFiles(
      List<File> files, {
      bool preserveOrder = false,
    }) async {
      final List<TemporaryMedia> uploadedMedias = [];
      try {
        onUploadingChanged?.call(true);
        if (preserveOrder) {
          // 相册按选中顺序串行上传：展示进度，每张成功后立刻刷新列表。
          final int total = files.length;
          for (var i = 0; i < files.length; i++) {
            await EasyLoading.show(status: '上传中 ${i + 1}/$total');
            final media = await upload(file: files[i]);
            uploadedMedias.add(media);
            _notifyChanged([...currentImages, ...uploadedMedias]);
          }
        } else {
          await EasyLoading.show(status: '上传中...');
          uploadedMedias.addAll(
            await Future.wait(files.map((file) => upload(file: file))),
          );
          if (uploadedMedias.isNotEmpty) {
            _notifyChanged([...currentImages, ...uploadedMedias]);
          }
        }
      } finally {
        onUploadingChanged?.call(false);
        EasyLoading.dismiss();
      }
    }

    // 上传时使用源文件
    Future<File?> resolveEntityOriginalFile(AssetEntity entity) async {
      try {
        final File? origin = await entity.originFile;
        if (origin != null) return origin;
      } catch (_) {}
      return entity.file;
    }

    // --- 内部方法：上传实体 (用于相册选择) ---
    Future<void> uploadEntities(List<AssetEntity> entities) async {
      final List<File> files = [];
      for (final entity in entities) {
        final f = await resolveEntityOriginalFile(entity);
        if (f != null) files.add(f);
      }
      if (files.isNotEmpty) {
        await uploadFiles(
          files,
          preserveOrder: preserveGallerySelectionOrder,
        );
      }
    }

    // --- 动作 1：打开系统相机 ---
    Future<void> openStandardCamera() async {
      //单拍时使用系統自帶的相机，for: wechat_camera_picker有兼容性问题，按下快门的瞬间拍糊。
      try {
        final file = await captureSinglePhotoFile();
        if (file != null) await uploadFiles([file]);
      } catch (e) {
        EasyLoading.showError('无法打开相机: $e');
      }
    }

    // --- 动作 2：打开相册 ---
    Future<void> openGallery() async {
      try {
        final permission = await PhotoManager.requestPermissionExtend();
        if (!permission.hasAccess) {
          EasyLoading.showInfo('请先开启相册权限');
          return;
        }

        final int galleryMaxAssets = maxAssetsForGallery ?? remainingCount;

        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: galleryMaxAssets,
            requestType: RequestType.image,
          ),
        );
        if (result != null && result.isNotEmpty) {
          await uploadEntities(result);
        }
      } on PlatformException catch (e) {
        debugPrint('openGallery PlatformException: ${e.message}');
        EasyLoading.showError('打开相册失败，请重试');
      } catch (e) {
        debugPrint('openGallery error: $e');
        EasyLoading.showError('打开相册失败，请重试');
      }
    }

    // --- 动作 3：打开连拍 (长按触发) ---
    Future<void> openContinuousCamera() async {
      try {
        if (context.mounted) {
          final List<XFile>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => enableContinuousWithGyroscopeWithoutSize
                  // 6个字段验货图片相机
                  ? ContinuousCameraPageWithoutSize(
                      maxCount: continuousMaxCount,
                      captureFieldLabels: pendingCaptureFieldLabels,
                      initialEnableGyroscopeRotation:
                          enableContinuousGyroscopeRotation,
                    )
                  // 其他验货图片相机
                  : ContinuousCameraPageOtherPhoto(
                      maxCount: continuousMaxCount,
                    ),
            ),
          );
          if (result != null && result.isNotEmpty) {
            final List<File> files = result.map((e) => File(e.path)).toList();

            if (onContinuousCapture != null) {
              onContinuousCapture!(files); // 交给父组件处理分发
            } else {
              // 连拍按拍摄顺序串行上传，显示进度，每张成功后立刻刷新列表。
              await uploadFiles(files);
            }
          }
        }
      } catch (e) {
        EasyLoading.showError('无法打开相机: $e');
      }
    }

    // showFlanActionSheet 走 rootNavigator，须用同一 navigator 关闭，否则会误关父级 BottomSheet
    void popActionSheet() {
      Navigator.of(context, rootNavigator: true).maybePop();
    }

    // --- 点击处理逻辑 ---
    Future<void> handleTap() async {
      if (remainingCount <= 0) return;

      // 模式二：弹窗选择 (相册 + 相机)
      await showFlanActionSheet(
        context,
        cancelText: "取消",
        actions: [
          FlanActionSheetAction(
            name: "拍摄",
            callback: (action) async {
              popActionSheet();
              await openStandardCamera();
            },
          ),
          if (showContinuousOption)
            FlanActionSheetAction(
              name: "连拍模式",
              callback: (action) async {
                popActionSheet();
                await openContinuousCamera();
              },
            ),
          FlanActionSheetAction(
            name: "从手机相册选择",
            callback: (action) async {
              popActionSheet();
              await openGallery();
            },
          ),
        ],
      );
    }

    // --- 长按处理逻辑 ---
    Future<void> handleLongPress() async {
      if (remainingCount <= 0 || !enableContinuous) return;
      HapticFeedback.mediumImpact();
      await openContinuousCamera();
    }

    void handleDelete(int index) async {
      final bool confirm = await ConfirmDialog.show(
        context,
        content: '确定要移除这张图片吗？',
      );
      if (!confirm) return;
      final newImageList = [...currentImages];
      var item = newImageList[index];
      if (item.uuid == null) {
        final mediaId = item.idAsInt;
        if (mediaId != null) {
          await deleteMedia(mediaId, {});
        }
      }
      newImageList.removeAt(index);
      _notifyChanged(newImageList, item);
    }

    const double itemSpacing = 10;
    final double itemWidth = width ?? defaultItemWidth;
    final double itemHeight = height ?? defaultItemHeight;

    int computeItemsPerRow(double layoutWidth) {
      if (!layoutWidth.isFinite || layoutWidth <= 0) return 1;
      return ((layoutWidth + itemSpacing) / (itemWidth + itemSpacing))
          .floor()
          .clamp(1, 999);
    }

    Widget buildImageLayout({int? itemsPerRow}) {
      final List<Widget> imageWidgets = [
        ...List.generate(currentImages.length, (index) {
          return _buildImageItem(
            context,
            index,
            currentImages[index].thumbUrl ?? currentImages[index].url,
            onRemove: () => handleDelete(index),
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          );
        }),
        if (remainingCount > 0)
          _buildAddButton(
            onTap: handleTap,
            onLongPress: enableContinuous ? handleLongPress : null,
            hasError: hasError,
            currentIndex: currentImages.length,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
      ];

      if (itemsPerRow == null) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < imageWidgets.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    right: i < imageWidgets.length - 1 ? itemSpacing : 0,
                  ),
                  child: imageWidgets[i],
                ),
            ],
          ),
        );
      }

      final int perRow = itemsPerRow;
      final int rowCount = (imageWidgets.length + perRow - 1) ~/ perRow;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(rowCount, (row) {
          final int start = row * perRow;
          final int end = start + perRow;
          final List<Widget> rowItems = imageWidgets.sublist(
            start,
            end > imageWidgets.length ? imageWidgets.length : end,
          );

          return Padding(
            padding:
                EdgeInsets.only(bottom: row < rowCount - 1 ? itemSpacing : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(rowItems.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < rowItems.length - 1 ? itemSpacing : 0,
                  ),
                  child: rowItems[index],
                );
              }),
            ),
          );
        }),
      );
    }

    final Widget imageArea = enableWrapLayout
        ? LayoutBuilder(
            builder: (context, constraints) {
              return buildImageLayout(
                itemsPerRow: computeItemsPerRow(constraints.maxWidth),
              );
            },
          )
        : buildImageLayout();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: imageArea),
            if (extraContent != null) ...[
              extraContent!,
            ],
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 2.0),
            child: Text(errorText!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }

  bool _isValidPreviewUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return uri.host.isNotEmpty;
    }
    if (uri.scheme == 'file') {
      // file:/// 或空路径都视为无效，避免触发 No host specified
      return uri.path.trim().isNotEmpty && uri.path.trim() != '/';
    }
    return false;
  }

  Widget _buildImageWidget(String? url) {
    if (!_isValidPreviewUrl(url)) {
      return const Icon(Icons.image, color: Colors.grey);
    }

    final uri = Uri.parse(url!);
    if (uri.scheme == 'file') {
      return Image.file(File.fromUri(uri), fit: BoxFit.cover);
    }
    return Image.network(url, fit: BoxFit.cover);
  }

  Widget _buildImageItem(
    BuildContext context,
    int index,
    String? url, {
    required VoidCallback onRemove,
    double? itemWidth,
    double? itemHeight,
  }) {
    final double w = itemWidth ?? width ?? defaultItemWidth;
    final double h = itemHeight ?? height ?? defaultItemHeight;
    final itemContent = Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            final gallerySource =
                previewGallery ?? value ?? const <TemporaryMedia>[];
            final previewItems =
                gallerySource.where((m) => _isValidPreviewUrl(m.url)).toList();
            if (previewItems.isEmpty) return;

            final tapped =
                (value != null && index < value!.length) ? value![index] : null;
            int startPosition = 0;
            if (tapped != null) {
              final found = previewItems.indexWhere((m) => m.id == tapped.id);
              startPosition =
                  found >= 0 ? found : index.clamp(0, previewItems.length - 1);
            } else {
              startPosition = index.clamp(0, previewItems.length - 1);
            }

            showFlanImagePreview(
              context,
              images: previewItems.map((m) => m.url).toList(),
              startPosition: startPosition,
              loop: false,
            );
          },
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _isValidPreviewUrl(url)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _buildImageWidget(url))
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
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)]),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );

    // 如果没有配置 uploaderKey，就退化为普通不可拖拽的图片
    if (uploaderKey == null || onSwap == null) return itemContent;
    return DragTarget<MediaDragData>(
      onAcceptWithDetails: (details) {
        onSwap!(details.data, MediaDragData(key: uploaderKey!, index: index));
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return LongPressDraggable<MediaDragData>(
          data: MediaDragData(key: uploaderKey!, index: index),
          feedback: Material(
              color: Colors.transparent,
              child: Opacity(opacity: 0.8, child: itemContent)),
          childWhenDragging: Opacity(opacity: 0.3, child: itemContent),
          child: Container(
            decoration: BoxDecoration(
              border: isHovered
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: itemContent,
          ),
        );
      },
    );
  }

  Widget _buildAddButton({
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    bool hasError = false,
    required int currentIndex,
    double? itemWidth,
    double? itemHeight,
  }) {
    final double w = itemWidth ?? width ?? defaultItemWidth;
    final double h = itemHeight ?? height ?? defaultItemHeight;
    final btnContent = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: hasError ? Colors.red : const Color(0x00FFFFFF),
            width: hasError ? 1.2 : 1.0,
          ),
        ),
        child: Icon(customIcon ?? Icons.add,
            color: const Color(0xFF999999), size: 28),
      ),
    );

    //  如果没开启拖拽，直接返回普通按钮
    if (uploaderKey == null || onSwap == null) return btnContent;

    // 3开启拖拽后，让 + 号也能接收图片
    return DragTarget<MediaDragData>(
      onAcceptWithDetails: (details) {
        onSwap!(details.data,
            MediaDragData(key: uploaderKey!, index: currentIndex));
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return Container(
          decoration: isHovered
              ? BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(6),
                )
              : null,
          child: btnContent,
        );
      },
    );
  }
}

class _AndroidCaptureSnapshot {
  final Size viewportSize;
  final Rect previewRect;
  final CameraAspectRatios aspectRatio;
  final Rect captureFrameRect;

  const _AndroidCaptureSnapshot({
    required this.viewportSize,
    required this.previewRect,
    required this.aspectRatio,
    required this.captureFrameRect,
  });
}

class _IosCaptureSnapshot {
  final Size viewportSize;
  final CameraAspectRatios aspectRatio;
  final double cameraAspectRatio;
  final camera.CameraLensDirection lensDirection;
  final Rect captureFrameRect;

  const _IosCaptureSnapshot({
    required this.viewportSize,
    required this.aspectRatio,
    required this.cameraAspectRatio,
    required this.lensDirection,
    required this.captureFrameRect,
  });
}

class _PendingCapture {
  final int targetIndex;
  final bool addedNewThumbnailSlot;
  final _IosCaptureSnapshot? iosSnapshot;
  final _AndroidCaptureSnapshot? androidSnapshot;

  const _PendingCapture({
    required this.targetIndex,
    this.addedNewThumbnailSlot = false,
    this.iosSnapshot,
    this.androidSnapshot,
  });
}

/// 画幅切换：传感器原生（用 [CameraAspectRatios.ratio_4_3] 表示）↔ 1:1。
const String _continuousCameraLightAspectRatioKey =
    'continuous_camera_light_aspect_ratio';
const String _persistedAspectRatioNative = 'native';
const String _persistedAspectRatio1x1 = '1_1';

CameraAspectRatios loadPersistedCaptureAspectRatio() {
  final saved = app.prefs.getString(_continuousCameraLightAspectRatioKey);
  if (saved == _persistedAspectRatio1x1) {
    return CameraAspectRatios.ratio_1_1;
  }
  return CameraAspectRatios.ratio_4_3;
}

void persistCaptureAspectRatio(CameraAspectRatios aspectRatio) {
  final value = usesVirtualSquareCaptureFrame(aspectRatio)
      ? _persistedAspectRatio1x1
      : _persistedAspectRatioNative;
  app.prefs.setString(_continuousCameraLightAspectRatioKey, value);
}

CameraAspectRatios cycleCaptureAspectRatio(CameraAspectRatios current) {
  switch (current) {
    case CameraAspectRatios.ratio_1_1:
      return CameraAspectRatios.ratio_4_3;
    case CameraAspectRatios.ratio_4_3:
    case CameraAspectRatios.ratio_16_9:
      return CameraAspectRatios.ratio_1_1;
  }
}

bool usesVirtualSquareCaptureFrame(CameraAspectRatios aspectRatio) {
  return aspectRatio == CameraAspectRatios.ratio_1_1;
}

/// 是否为「传感器原生」画幅（不额外裁成 3:4，取完整预览区域）。
bool usesNativeSensorCaptureFrame(CameraAspectRatios aspectRatio) {
  return !usesVirtualSquareCaptureFrame(aspectRatio);
}

/// 竖屏连拍画幅：1:1 宽占满；原生画幅由调用方直接使用完整预览矩形。
({double widthOverHeight, CaptureFrameFit fit})
    resolvePortraitCaptureFrameLayout(CameraAspectRatios aspectRatio) {
  if (usesVirtualSquareCaptureFrame(aspectRatio)) {
    return (widthOverHeight: 1.0, fit: CaptureFrameFit.fitWidth);
  }
  // 原生：占位值，实际取景框用完整 previewRect。
  switch (aspectRatio) {
    case CameraAspectRatios.ratio_1_1:
      return (widthOverHeight: 1.0, fit: CaptureFrameFit.fitWidth);
    case CameraAspectRatios.ratio_4_3:
    case CameraAspectRatios.ratio_16_9:
      return (widthOverHeight: 3 / 4, fit: CaptureFrameFit.fitWidth);
  }
}

/// iOS / Android（含小米/红米）cover 预览与原生画幅不一致，统一 UI 取景 + 拍后裁剪。
bool shouldSkipNativeAspectRatioSwitch(CameraAspectRatios aspectRatio) {
  if (Platform.isIOS || Platform.isAndroid) return true;
  return usesVirtualSquareCaptureFrame(aspectRatio);
}

Rect resolveEffectiveCaptureRect(
  Size viewportSize,
  Rect previewRect,
  CameraAspectRatios aspectRatio,
) {
  if (!shouldSkipNativeAspectRatioSwitch(aspectRatio)) {
    return previewRect;
  }
  // 传感器原生：不额外裁切，取完整预览区域。
  if (usesNativeSensorCaptureFrame(aspectRatio)) {
    final Rect container = previewRect.width > 0 && previewRect.height > 0
        ? previewRect
        : Offset.zero & viewportSize;
    return container;
  }
  final layout = resolvePortraitCaptureFrameLayout(aspectRatio);
  final Rect container = previewRect.width > 0 && previewRect.height > 0
      ? previewRect
      : Offset.zero & viewportSize;
  final Rect frameInContainer = computeCaptureFrameRect(
    container.size,
    widthOverHeight: layout.widthOverHeight,
    fit: layout.fit,
  );
  return frameInContainer.shift(container.topLeft);
}

/// 画幅切换按钮：原生传感器预览 ↔ 1:1。
class _AspectRatioSwitchButton extends StatelessWidget {
  final CameraAspectRatios aspectRatio;
  final Future<void> Function() onSwitch;

  const _AspectRatioSwitchButton({
    required this.aspectRatio,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconChild;
    switch (aspectRatio) {
      case CameraAspectRatios.ratio_16_9:
      case CameraAspectRatios.ratio_4_3:
        // 传感器原生（完整预览）
        iconChild = const Icon(
          Icons.crop_original,
          color: Colors.white,
          size: 24,
        );
        break;
      case CameraAspectRatios.ratio_1_1:
        iconChild = const Image(
          image: AssetImage('packages/camerawesome/assets/icons/1_1.png'),
          width: 24,
        );
        break;
    }

    return AwesomeOrientedWidget(
      child: AwesomeBouncingWidget(
        onTap: onSwitch,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: Center(child: iconChild),
        ),
      ),
    );
  }
}

/// iOS / 无尺寸连拍：隐藏 wechat 默认 UI，由自绘控件接管。
class _ContinuousWechatPickerState extends CameraPickerState {
  Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    camera.CameraController? controller,
  )? buildCustomForeground;

  Listenable? overlayRepaintListenable;

  /// 为 true 时根据加速度计决定「成片」横竖（预览始终竖长画幅）。
  bool enableGyroscopeRotation = false;

  /// 手机当前物理姿态，仅用于成片旋转，不驱动预览布局。
  DeviceOrientation physicalCaptureOrientation = DeviceOrientation.portraitUp;

  /// 默认不订阅加速度计，避免一进连拍就触发运动传感器导致部分 iOS 闪退。
  /// 仅在开启「成片跟随横竖」时再订阅。
  @override
  void initAccelerometerSubscription() {
    if (enableGyroscopeRotation) {
      ensureAccelerometerSubscription();
    }
  }

  void ensureAccelerometerSubscription() {
    if (accelerometerSubscription != null) return;
    try {
      accelerometerSubscription =
          accelerometerEventStream().listen(handleAccelerometerEvent);
    } catch (e) {
      debugPrint('Accelerometer subscribe failed: $e');
    }
  }

  void cancelAccelerometerSubscription() {
    accelerometerSubscription?.cancel();
    accelerometerSubscription = null;
  }

  void setGyroscopeRotationEnabled(bool enabled) {
    enableGyroscopeRotation = enabled;
    if (enabled) {
      ensureAccelerometerSubscription();
    } else {
      cancelAccelerometerSubscription();
      physicalCaptureOrientation = DeviceOrientation.portraitUp;
    }
  }

  @override
  void handleAccelerometerEvent(AccelerometerEvent event) {
    // 只记录姿态；绝不 lock 到横屏，否则预览会变成「横向比例大」。
    if (!enableGyroscopeRotation) {
      physicalCaptureOrientation = DeviceOrientation.portraitUp;
      return;
    }
    if (!mounted || innerController == null) return;

    final double x = event.x, y = event.y, z = event.z;
    final DeviceOrientation? newOrientation;
    if (x.abs() > y.abs() && x.abs() > z.abs()) {
      newOrientation = x > 0
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeRight;
    } else if (y.abs() > x.abs() && y.abs() > z.abs()) {
      newOrientation =
          y > 0 ? DeviceOrientation.portraitUp : DeviceOrientation.portraitDown;
    } else {
      newOrientation = null;
    }
    if (newOrientation != null) {
      physicalCaptureOrientation = newOrientation;
    }
  }

  /// 按物理姿态旋转成片：横拿→横图，竖拿→竖图；预览不受影响。
  /// [orientationOverride] 用于锁定快门瞬间姿态，避免异步处理后姿态已变。
  Future<XFile> orientCapturedFile(
    XFile source, {
    DeviceOrientation? orientationOverride,
  }) async {
    if (!enableGyroscopeRotation) return source;
    final DeviceOrientation orientation =
        orientationOverride ?? physicalCaptureOrientation;
    final int rotateDegrees;
    switch (orientation) {
      case DeviceOrientation.landscapeLeft:
        rotateDegrees = 270;
        break;
      case DeviceOrientation.landscapeRight:
        rotateDegrees = 90;
        break;
      case DeviceOrientation.portraitDown:
        rotateDegrees = 180;
        break;
      case DeviceOrientation.portraitUp:
        return source;
    }
    try {
      final Uint8List bytes = await source.readAsBytes();
      final Uint8List? rotated = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 95,
        rotate: rotateDegrees,
        autoCorrectionAngle: false,
        keepExif: false,
      );
      if (rotated == null || rotated.isEmpty) return source;
      final Directory tempDir = await getTemporaryDirectory();
      final File outFile = File(
        '${tempDir.path}/capture_orient_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await outFile.writeAsBytes(rotated, flush: true);
      return XFile(outFile.path);
    } catch (e) {
      debugPrint('Orient captured file error: $e');
      return source;
    }
  }

  @override
  Widget buildForegroundBody({
    required BuildContext context,
    required BoxConstraints constraints,
    DeviceOrientation? deviceOrientation,
  }) {
    Widget buildContent() {
      return buildCustomForeground?.call(
              context, constraints, innerController) ??
          const SizedBox.shrink();
    }

    final listenable = overlayRepaintListenable;
    if (listenable == null) return buildContent();
    return ListenableBuilder(
      listenable: listenable,
      builder: (_, __) => buildContent(),
    );
  }
}

//  其他验货图片  的 定制相机
/// 连拍相机（全平台: wechat_camera_picker），画幅可在「传感器原生」与「1:1」间切换。
/// 预览与成片均锁定竖屏，不提供横竖跟随切换。
class ContinuousCameraPageOtherPhoto extends HookConsumerWidget {
  static const double bottomSideSlotWidth = 80;
  static const Color captureFrameBorderColor = Colors.black;
  static const double captureFrameBorderWidth = 1.5;

  /// 默认变焦倍率（相对光学 1.0）。
  static const double defaultZoomLevel = 1.1;

  /// 连拍最大张数；null 或 <=0 表示不限制
  final int? maxCount;

  const ContinuousCameraPageOtherPhoto({
    super.key,
    this.maxCount,
  });

  static double resolveWechatIosCameraAspectRatio(
    camera.CameraValue? value,
    double fallback,
  ) {
    if (value == null || !value.isInitialized) return fallback;
    final previewSize = value.previewSize;
    if (previewSize != null && previewSize.height > 0) {
      return previewSize.width / previewSize.height;
    }
    return value.aspectRatio;
  }

  static Rect wechatIosPreviewRect(Size viewport, double cameraAspectRatio) {
    if (viewport.width <= 0 || cameraAspectRatio <= 0) {
      return Offset.zero & viewport;
    }
    final double portraitWidthOverHeight = 1 / cameraAspectRatio;
    double previewW = viewport.width;
    double previewH = previewW / portraitWidthOverHeight;
    if (previewH > viewport.height) {
      previewH = viewport.height;
      previewW = previewH * portraitWidthOverHeight;
    }
    // 预览区域高度减少 100，底部留给控件区。
    previewH = (previewH - 100).clamp(1.0, viewport.height);
    return Rect.fromLTWH(
      (viewport.width - previewW) / 2,
      0,
      previewW,
      previewH,
    );
  }

  static Rect _clampRectWithinBounds(Rect rect, Rect bounds) {
    final double left = rect.left.clamp(bounds.left, bounds.right);
    final double top = rect.top.clamp(bounds.top, bounds.bottom);
    final double right = rect.right.clamp(bounds.left, bounds.right);
    final double bottom = rect.bottom.clamp(bounds.top, bounds.bottom);
    if (right <= left || bottom <= top) return bounds;
    return Rect.fromLTRB(left, top, right, bottom);
  }

  static Future<ui.Image> orientIosCameraImageToPortrait(
    ui.Image image, {
    required camera.CameraLensDirection lensDirection,
  }) async {
    final int w = image.width;
    final int h = image.height;
    if (h >= w) return image;

    final bool ccw = lensDirection == camera.CameraLensDirection.front;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    if (ccw) {
      canvas.translate(0, w.toDouble());
      canvas.rotate(-math.pi / 2);
    } else {
      canvas.translate(h.toDouble(), 0);
      canvas.rotate(math.pi / 2);
    }
    canvas.drawImage(
      image,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.high,
    );
    image.dispose();
    final picture = recorder.endRecording();
    return picture.toImage(h, w);
  }

  static Rect resolveWechatIosEffectiveCaptureRect(
    Size viewportSize,
    CameraAspectRatios aspectRatio, {
    required double cameraAspectRatio,
  }) {
    final Rect previewRect =
        wechatIosPreviewRect(viewportSize, cameraAspectRatio);
    // 传感器原生：取景框 = 完整相机预览，不再裁成 3:4。
    if (usesNativeSensorCaptureFrame(aspectRatio)) {
      return previewRect;
    }
    final layout = resolvePortraitCaptureFrameLayout(aspectRatio);
    final Rect frameInPreview = computeCaptureFrameRect(
      previewRect.size,
      widthOverHeight: layout.widthOverHeight,
      fit: layout.fit,
    );
    return frameInPreview.shift(previewRect.topLeft);
  }

  static Rect mapWechatIosFrameToImageRect({
    required Size imageSize,
    required Rect previewRect,
    required Rect captureFrameInViewport,
  }) {
    final Rect visibleFrame = captureFrameInViewport.intersect(previewRect);
    final double nx =
        (visibleFrame.left - previewRect.left) / previewRect.width;
    final double ny = (visibleFrame.top - previewRect.top) / previewRect.height;
    final double nw = visibleFrame.width / previewRect.width;
    final double nh = visibleFrame.height / previewRect.height;
    final double previewAspect = previewRect.width / previewRect.height;
    final double imageAspect = imageSize.width / imageSize.height;
    if ((previewAspect - imageAspect).abs() < 0.02) {
      return Rect.fromLTWH(
        nx * imageSize.width,
        ny * imageSize.height,
        nw * imageSize.width,
        nh * imageSize.height,
      );
    }
    final Rect visibleImage =
        computeCoverVisibleRect(imageSize, previewRect.size);
    return Rect.fromLTWH(
      visibleImage.left + nx * visibleImage.width,
      visibleImage.top + ny * visibleImage.height,
      nw * visibleImage.width,
      nh * visibleImage.height,
    );
  }

  static Future<File> cropImageForWechatIosFrame(
    File source,
    Size viewportSize,
    Rect captureFrameInViewport,
    double cameraAspectRatio, {
    camera.CameraLensDirection lensDirection = camera.CameraLensDirection.back,
    int? maxDecodeWidth,
    FilterQuality filterQuality = FilterQuality.high,
    bool encodeAsNativeJpeg = false,
    int jpegQuality = kContinuousCaptureRefineJpegQuality,
  }) async {
    final bytes = await source.readAsBytes();
    final ui.Codec codec = maxDecodeWidth != null
        ? await ui.instantiateImageCodec(bytes, targetWidth: maxDecodeWidth)
        : await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image oriented = await orientIosCameraImageToPortrait(
      frame.image,
      lensDirection: lensDirection,
    );
    final Size imageSize =
        Size(oriented.width.toDouble(), oriented.height.toDouble());
    final Rect previewRect =
        wechatIosPreviewRect(viewportSize, cameraAspectRatio);
    if (previewRect.width <= 0 ||
        previewRect.height <= 0 ||
        captureFrameInViewport.width <= 0 ||
        captureFrameInViewport.height <= 0) {
      oriented.dispose();
      return source;
    }
    final Rect cropRect = _clampRectWithinBounds(
      mapWechatIosFrameToImageRect(
        imageSize: imageSize,
        previewRect: previewRect,
        captureFrameInViewport: captureFrameInViewport,
      ),
      Offset.zero & imageSize,
    );
    final int cropW = cropRect.width.round();
    final int cropH = cropRect.height.round();
    if (cropW <= 0 || cropH <= 0) {
      oriented.dispose();
      return source;
    }
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      oriented,
      cropRect,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint()..filterQuality = filterQuality,
    );
    oriented.dispose();
    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(cropW, cropH);
    if (encodeAsNativeJpeg) {
      final encoded = await encodeUiImageAsNativeJpeg(
        croppedImage,
        quality: jpegQuality,
      );
      return encoded ?? source;
    }
    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    croppedImage.dispose();
    if (byteData == null) return source;
    final tempDir = await getTemporaryDirectory();
    final outFile = File(
      '${tempDir.path}/camera_crop_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await outFile.writeAsBytes(byteData.buffer.asUint8List());
    return outFile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturedImages = useState<List<XFile?>>([]);
    final savingThumbnailIndices = useState<Set<int>>({});
    final replaceIndex = useState<int?>(null);
    final scrollController = useScrollController();
    final shutterAnimController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    final isCapturing = useState(false);
    final displayAspectRatio =
        useState(loadPersistedCaptureAspectRatio()); // 本地记忆：原生 / 1:1
    final isAspectRatioSwitchingRef = useRef(false);
    final isExitingRef = useRef(false);
    final viewportSizeRef = useRef<Size?>(null);
    final pendingCaptureRef = useRef<_PendingCapture?>(null);
    final pendingCaptureByPathRef = useRef<Map<String, _PendingCapture>>({});
    final fastCropQueueRef = useRef<Future<void>>(Future.value());
    final refineCropQueueRef = useRef<Future<void>>(Future.value());
    final wechatPickerStateRef = useRef<_ContinuousWechatPickerState?>(null);
    final iosCameraControllerRef = useRef<camera.CameraController?>(null);
    final iosCameraAspectRatioRef = useRef<double>(4 / 3);
    final iosCameraLensDirectionRef = useRef(camera.CameraLensDirection.back);
    final lastDefaultZoomControllerRef = useRef<camera.CameraController?>(null);
    final showCenterFocusPoint = useState(false);
    final centerFocusPointKey = useState(0);
    final focusPointHideTimerRef = useRef<Timer?>(null);
    final iosOverlayRepaintTick = useMemoized(() => ValueNotifier(0), []);

    /// CameraPicker createState 只执行一次，通过 ref 读取最新 overlay。
    final iosOverlayBuilderRef =
        useRef<Widget Function(camera.CameraController?, Size)>(
      (_, __) => const SizedBox.shrink(),
    );
    useEffect(
      () {
        // 预览与成片均锁定竖屏。
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
        ]);
        return () {
          focusPointHideTimerRef.value?.cancel();
          iosOverlayRepaintTick.dispose();
          SystemChrome.setPreferredOrientations(const [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        };
      },
      [iosOverlayRepaintTick],
    );
    final shutterScaleAnim = useMemoized(
      () => Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(
          parent: shutterAnimController,
          curve: Curves.easeInOut,
        ),
      ),
      [shutterAnimController],
    );

    Future<void> backupToGalleryIfEnabled(String imagePath) async {
      if (!ref.read(settingProvider).photoBackupToGallery) return;
      try {
        await Gal.putImage(imagePath);
      } catch (e) {
        debugPrint('连拍图片备份至相册失败: $e');
      }
    }

    final int validCapturedCount =
        capturedImages.value.where((e) => e != null).length;
    useEffect(() {
      iosOverlayRepaintTick.value++;
      return null;
    }, [
      displayAspectRatio.value,
      capturedImages.value,
      savingThumbnailIndices.value,
      isCapturing.value,
      replaceIndex.value,
      validCapturedCount,
    ]);
    final bool hasCaptureLimit = maxCount != null && maxCount! > 0;
    final bool isAtCaptureLimit =
        hasCaptureLimit && validCapturedCount >= maxCount!;
    final bool isRetakeMode = replaceIndex.value != null;
    final bool atCaptureLimit = !isRetakeMode && isAtCaptureLimit;

    void applyCapturedFile(int index, XFile file) {
      final nextImages = [...capturedImages.value];
      if (index < nextImages.length) {
        nextImages[index] = file;
      } else {
        while (nextImages.length < index) {
          nextImages.add(null);
        }
        nextImages.add(file);
      }
      capturedImages.value = nextImages;
    }

    void scrollThumbnailsToEnd() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
          );
        }
      });
    }

    void markThumbnailSaving(int targetIndex, {required bool addedNewSlot}) {
      savingThumbnailIndices.value = {
        ...savingThumbnailIndices.value,
        targetIndex,
      };
      if (addedNewSlot) {
        capturedImages.value = [...capturedImages.value, null];
        scrollThumbnailsToEnd();
      }
    }

    void clearThumbnailSaving(int targetIndex) {
      if (!savingThumbnailIndices.value.contains(targetIndex)) return;
      final nextSaving = {...savingThumbnailIndices.value}..remove(targetIndex);
      savingThumbnailIndices.value = nextSaving;
    }

    void revertSavingPlaceholder(_PendingCapture pending) {
      clearThumbnailSaving(pending.targetIndex);
      if (!pending.addedNewThumbnailSlot) return;
      final nextImages = [...capturedImages.value];
      final int index = pending.targetIndex;
      if (index >= 0 &&
          index < nextImages.length &&
          nextImages[index] == null) {
        nextImages.removeAt(index);
        capturedImages.value = nextImages;
      }
    }

    void bindPendingCaptureToPath(String path, _PendingCapture pending) {
      pendingCaptureByPathRef.value[path] = pending;
    }

    _PendingCapture? takePendingCaptureForPath(String path) {
      final pending = pendingCaptureByPathRef.value.remove(path);
      return pending;
    }

    Future<T> enqueueFastCrop<T>(Future<T> Function() task) {
      final completer = Completer<T>();
      fastCropQueueRef.value = fastCropQueueRef.value.then((_) async {
        try {
          if (!completer.isCompleted) {
            completer.complete(await task());
          }
        } catch (e, stackTrace) {
          debugPrint('Fast crop queue error: $e');
          if (!completer.isCompleted) {
            completer.completeError(e, stackTrace);
          }
        }
      });
      return completer.future;
    }

    Future<T> enqueueRefineCrop<T>(Future<T> Function() task) {
      final completer = Completer<T>();
      refineCropQueueRef.value = refineCropQueueRef.value.then((_) async {
        try {
          if (!completer.isCompleted) {
            completer.complete(await task());
          }
        } catch (e, stackTrace) {
          debugPrint('Refine crop queue error: $e');
          if (!completer.isCompleted) {
            completer.completeError(e, stackTrace);
          }
        }
      });
      return completer.future;
    }

    Widget buildSavingThumbnailContent() {
      return const Center(
        child: Text(
          '正在裁剪中...',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      );
    }

    Future<void> waitForCameraOperations() async {
      const maxAttempts = 60;
      for (var i = 0; i < maxAttempts; i++) {
        if (!isCapturing.value && !isAspectRatioSwitchingRef.value) break;
        await Future.delayed(const Duration(milliseconds: 50));
      }
      try {
        await fastCropQueueRef.value;
      } catch (_) {}
      try {
        await refineCropQueueRef.value;
      } catch (_) {}
    }

    Future<void> safeExitPop<T extends Object?>([T? result]) async {
      if (isExitingRef.value) return;
      isExitingRef.value = true;
      await waitForCameraOperations();
      // 给相机释放预览/纹理留出时间，避免返回时原生层闪退。
      await Future.delayed(const Duration(milliseconds: 200));
      if (context.mounted) {
        Navigator.pop(context, result);
      }
    }

    Future<XFile> processCapturedFile(
      String path, {
      int? maxDecodeWidth = kContinuousCaptureFastDecodeWidth,
      int jpegQuality = kContinuousCaptureFastJpegQuality,
      _IosCaptureSnapshot? iosSnapshot,
      _AndroidCaptureSnapshot? androidSnapshot,
    }) async {
      final bool isRefinePass = maxDecodeWidth == null;
      final aspectRatio = iosSnapshot?.aspectRatio ??
          androidSnapshot?.aspectRatio ??
          displayAspectRatio.value;

      // 传感器原生画幅：成片即相机原图，跳过 UI 取景裁剪。
      if (usesNativeSensorCaptureFrame(aspectRatio)) {
        return XFile(path);
      }

      // 1:1 等虚拟画幅：UI 取景框 + isolate 裁剪（精修也走 isolate）。
      try {
        final Size screenSize = iosSnapshot?.viewportSize ??
            viewportSizeRef.value ??
            MediaQuery.sizeOf(context);
        final CameraAspectRatios ratio =
            iosSnapshot?.aspectRatio ?? aspectRatio;
        final double cameraAspectRatio =
            iosSnapshot?.cameraAspectRatio ?? iosCameraAspectRatioRef.value;
        final Rect captureFrame = iosSnapshot?.captureFrameRect ??
            resolveWechatIosEffectiveCaptureRect(
              screenSize,
              ratio,
              cameraAspectRatio: cameraAspectRatio,
            );
        final Rect previewRect = wechatIosPreviewRect(
          screenSize,
          cameraAspectRatio,
        );
        final bool isFront =
            (iosSnapshot?.lensDirection ?? iosCameraLensDirectionRef.value) ==
                camera.CameraLensDirection.front;
        // 精修：全分辨率（maxDecodeWidth=null）；快路径：限制解码宽度。
        // 像素尺寸由原图决定，不缩放；JPEG 质量略降可明显加快编码且肉眼几乎无损。
        final int encodeQuality = isRefinePass ? 95 : jpegQuality;
        final cropped = await cropImageForWechatIosFrameInIsolate(
          path,
          captureFrame,
          previewRect,
          maxDecodeWidth: maxDecodeWidth,
          jpegQuality: encodeQuality,
          rotateIfLandscape: true,
          isFrontCamera: isFront,
        );
        return XFile(cropped.path);
      } catch (e) {
        debugPrint('wechat crop error: $e');
      }
      return XFile(path);
    }

    void replaceCapturedFileAt(
      int index,
      XFile file, {
      String? onlyIfCurrentPath,
    }) {
      final nextImages = [...capturedImages.value];
      if (index < 0 || index >= nextImages.length) return;
      if (onlyIfCurrentPath != null &&
          nextImages[index]?.path != onlyIfCurrentPath) {
        return;
      }
      nextImages[index] = file;
      capturedImages.value = nextImages;
    }

    Future<void> deleteTempCaptureFile(String? filePath) async {
      if (filePath == null || filePath.isEmpty) return;
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Delete temp capture file error: $e');
      }
    }

    Future<void> refineCapturedFileInBackground({
      required int targetIndex,
      required String sourcePath,
      required String previewPath,
      _IosCaptureSnapshot? iosSnapshot,
      _AndroidCaptureSnapshot? androidSnapshot,
    }) async {
      try {
        final aspectRatio = iosSnapshot?.aspectRatio ??
            androidSnapshot?.aspectRatio ??
            displayAspectRatio.value;
        // 原生画幅无裁剪/精修产物，直接备份原图，避免误删唯一文件。
        if (usesNativeSensorCaptureFrame(aspectRatio)) {
          unawaited(backupToGalleryIfEnabled(sourcePath));
          return;
        }
        final refined = await processCapturedFile(
          sourcePath,
          maxDecodeWidth: null,
          jpegQuality: kContinuousCaptureRefineJpegQuality,
          iosSnapshot: iosSnapshot,
          androidSnapshot: androidSnapshot,
        );
        if (!context.mounted || isExitingRef.value) return;
        replaceCapturedFileAt(
          targetIndex,
          refined,
          onlyIfCurrentPath: previewPath,
        );
        await deleteTempCaptureFile(previewPath);
        if (refined.path != sourcePath) {
          await deleteTempCaptureFile(sourcePath);
        }
        unawaited(backupToGalleryIfEnabled(refined.path));
      } catch (e) {
        debugPrint('Refine captured file error: $e');
      }
    }

    Future<void> applyDefaultZoom(camera.CameraController? controller) async {
      if (controller == null || !controller.value.isInitialized) return;
      try {
        final double minZoom = await controller.getMinZoomLevel();
        final double maxZoom = await controller.getMaxZoomLevel();
        final double zoom = defaultZoomLevel.clamp(minZoom, maxZoom).toDouble();
        await controller.setZoomLevel(zoom);
      } catch (e) {
        debugPrint('Apply default zoom error: $e');
      }
    }

    /// 显示画面正中的对焦框 UI，约 2 秒后淡出。
    void showCenterFocusPointUi() {
      focusPointHideTimerRef.value?.cancel();
      centerFocusPointKey.value++;
      showCenterFocusPoint.value = true;
      iosOverlayRepaintTick.value++;
      focusPointHideTimerRef.value = Timer(const Duration(seconds: 2), () {
        showCenterFocusPoint.value = false;
        iosOverlayRepaintTick.value++;
      });
    }

    /// 将对焦/曝光点对准预览正中（归一化坐标 0.5, 0.5），并显示对焦框。
    Future<void> focusOnCenter(camera.CameraController? controller) async {
      if (controller == null || !controller.value.isInitialized) return;
      showCenterFocusPointUi();
      try {
        const center = Offset(0.5, 0.5);
        await Future.wait(<Future<void>>[
          if (controller.value.focusPointSupported)
            controller.setFocusPoint(center),
          if (controller.value.exposurePointSupported)
            controller.setExposurePoint(center),
        ]);
        await controller.setFocusMode(camera.FocusMode.auto);
        if (controller.value.exposureMode != camera.ExposureMode.locked) {
          await controller.setExposureMode(camera.ExposureMode.auto);
        }
      } catch (e) {
        debugPrint('Focus on center error: $e');
      }
    }

    Future<void> resumeIosWechatPreview() async {
      final controller = iosCameraControllerRef.value;
      if (controller == null || !controller.value.isInitialized) return;
      try {
        await controller.setFocusMode(camera.FocusMode.auto);
        // 必须解锁曝光：wechat / 快门路径可能留下 locked，否则画面像定格。
        await controller.setExposureMode(camera.ExposureMode.auto);
        // 若未 pause 则为空操作；保证预览可持续刷新。
        await controller.resumePreview();
        await applyDefaultZoom(controller);
        await focusOnCenter(controller);
      } catch (e) {
        debugPrint('Resume iOS preview error: $e');
      }
    }

    Future<void> handleCapturedPath(String path) async {
      final pending = takePendingCaptureForPath(path);
      if (pending == null) return;

      final int targetIndex = pending.targetIndex;
      final _IosCaptureSnapshot? iosSnapshot = pending.iosSnapshot;
      final _AndroidCaptureSnapshot? androidSnapshot = pending.androidSnapshot;
      final CameraAspectRatios aspectRatio = iosSnapshot?.aspectRatio ??
          androidSnapshot?.aspectRatio ??
          displayAspectRatio.value;

      // 默认（传感器原生）画幅：不入裁剪/精修队列，直接使用原图（无缩略图占位）。
      if (usesNativeSensorCaptureFrame(aspectRatio)) {
        if (!context.mounted || isExitingRef.value) {
          return;
        }
        final XFile result = XFile(path);
        applyCapturedFile(targetIndex, result);
        if (replaceIndex.value != null) {
          replaceIndex.value = null;
        } else {
          scrollThumbnailsToEnd();
        }
        unawaited(backupToGalleryIfEnabled(result.path));
        return;
      }

      unawaited(
        enqueueFastCrop(() async {
          try {
            final XFile processedFile = await processCapturedFile(
              path,
              iosSnapshot: iosSnapshot,
              androidSnapshot: androidSnapshot,
            );
            if (!context.mounted || isExitingRef.value) {
              clearThumbnailSaving(targetIndex);
              return;
            }

            clearThumbnailSaving(targetIndex);
            if (replaceIndex.value != null) {
              applyCapturedFile(targetIndex, processedFile);
              replaceIndex.value = null;
            } else {
              applyCapturedFile(targetIndex, processedFile);
            }

            unawaited(
              enqueueRefineCrop(() async {
                await refineCapturedFileInBackground(
                  targetIndex: targetIndex,
                  sourcePath: path,
                  previewPath: processedFile.path,
                  iosSnapshot: iosSnapshot,
                  androidSnapshot: androidSnapshot,
                );
              }),
            );
          } catch (e) {
            debugPrint('Handle captured path error: $e');
            clearThumbnailSaving(targetIndex);
            revertSavingPlaceholder(pending);
          }
        }),
      );
    }

    Future<void> handleIosWechatCapture(XFile file) async {
      final pending = pendingCaptureRef.value;
      pendingCaptureRef.value = null;
      isCapturing.value = false;
      if (pending != null) {
        bindPendingCaptureToPath(file.path, pending);
      }
      unawaited(resumeIosWechatPreview());
      unawaited(handleCapturedPath(file.path));
    }

    Future<void> cycleIosFlashMode() async {
      final controller = iosCameraControllerRef.value;
      if (controller == null || !controller.value.isInitialized) return;
      const modes = [
        camera.FlashMode.off,
        camera.FlashMode.auto,
        camera.FlashMode.always,
        camera.FlashMode.torch,
      ];
      final current = controller.value.flashMode;
      final next = modes[(modes.indexOf(current) + 1) % modes.length];
      try {
        await controller.setFlashMode(next);
      } catch (e) {
        debugPrint('Switch iOS flash error: $e');
      }
    }

    void cycleIosAspectRatio() {
      if (isAspectRatioSwitchingRef.value || isCapturing.value) return;
      isAspectRatioSwitchingRef.value = true;
      HapticFeedback.selectionClick();
      final next = cycleCaptureAspectRatio(displayAspectRatio.value);
      displayAspectRatio.value = next;
      persistCaptureAspectRatio(next);
      isAspectRatioSwitchingRef.value = false;
    }

    Future<void> requestIosTakePhoto() async {
      final pickerState = wechatPickerStateRef.value;
      if (pickerState == null || isCapturing.value) return;
      if (replaceIndex.value == null && isAtCaptureLimit) {
        EasyLoading.showToast('最多可拍 $maxCount 张');
        return;
      }
      final controller = iosCameraControllerRef.value;
      final camera.CameraValue? cameraValue =
          controller?.value.isInitialized == true ? controller!.value : null;
      final Size viewportSize =
          viewportSizeRef.value ?? MediaQuery.sizeOf(context);
      final double cameraAspectRatio = resolveWechatIosCameraAspectRatio(
        cameraValue,
        iosCameraAspectRatioRef.value,
      );
      final Rect captureFrameRect = resolveWechatIosEffectiveCaptureRect(
        viewportSize,
        displayAspectRatio.value,
        cameraAspectRatio: cameraAspectRatio,
      );
      final int targetIndex = replaceIndex.value ?? capturedImages.value.length;
      final bool addedNewSlot = replaceIndex.value == null;
      final bool isNativeFrame =
          usesNativeSensorCaptureFrame(displayAspectRatio.value);
      pendingCaptureRef.value = _PendingCapture(
        targetIndex: targetIndex,
        // 默认画幅不预插占位，失败时也无需回滚缩略图位。
        addedNewThumbnailSlot: isNativeFrame ? false : addedNewSlot,
        iosSnapshot: _IosCaptureSnapshot(
          viewportSize: viewportSize,
          aspectRatio: displayAspectRatio.value,
          cameraAspectRatio: cameraAspectRatio,
          lensDirection: iosCameraLensDirectionRef.value,
          captureFrameRect: captureFrameRect,
        ),
      );
      // 默认画幅不显示缩略图占位；1:1 仍显示「正在裁剪中」。
      if (!isNativeFrame) {
        markThumbnailSaving(targetIndex, addedNewSlot: addedNewSlot);
      }
      isCapturing.value = true;
      shutterAnimController
          .forward()
          .then((_) => shutterAnimController.reverse());
      HapticFeedback.lightImpact();
      try {
        if (isNativeFrame) {
          // 传感器原生：沿用 wechat takePicture（拍后会 pause 再由我们 resume）。
          await pickerState.takePicture();
        } else {
          // 1:1：绕开 wechat takePicture，避免其 pausePreview 导致预览定格。
          final camera.CameraController? ctrl = controller;
          if (ctrl == null ||
              !ctrl.value.isInitialized ||
              ctrl.value.isTakingPicture) {
            throw StateError('Camera is not ready to take picture.');
          }
          final XFile file = await ctrl.takePicture();
          await handleIosWechatCapture(file);
        }
      } catch (e) {
        debugPrint('iOS take photo error: $e');
        final pending = pendingCaptureRef.value;
        if (pending != null) {
          revertSavingPlaceholder(pending);
        }
        pendingCaptureRef.value = null;
        isCapturing.value = false;
        unawaited(resumeIosWechatPreview());
      }
    }

    void deleteAndRetake(int index) {
      final nextImages = [...capturedImages.value];
      nextImages[index] = null;
      capturedImages.value = nextImages;
      replaceIndex.value = index;
    }

    void showImagePreview(int index) {
      if (savingThumbnailIndices.value.contains(index)) return;
      final XFile? file = capturedImages.value[index];
      if (file == null) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Preview',
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (ctx, anim1, anim2) {
          return HookBuilder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: InteractiveViewer(
                          child:
                              Image.file(File(file.path), fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    color: Colors.white, size: 28),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                              Text(
                                  '${index + 1}/${capturedImages.value.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 77,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      deleteAndRetake(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            153, 44, 44, 44),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.refresh_rounded,
                                              color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text('重拍',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget buildDefaultThumbnailItem(int index, bool isGlobalRetakeMode) {
      final XFile? file = capturedImages.value[index];
      final bool isSaving = savingThumbnailIndices.value.contains(index);
      final bool isTarget = replaceIndex.value == index;

      Border? currentBorder;
      if (isTarget) {
        currentBorder = Border.all(color: const Color(0xFFFF9500), width: 2);
      } else {
        currentBorder =
            Border.all(color: Colors.white.withOpacity(0.2), width: 1);
      }

      return GestureDetector(
        onTap: isSaving
            ? null
            : () {
                if (file == null) {
                  replaceIndex.value = index;
                } else {
                  showImagePreview(index);
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: currentBorder,
            color:
                isSaving ? Colors.transparent : Colors.white.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isSaving)
                  buildSavingThumbnailContent()
                else if (file != null)
                  Image.file(File(file.path), fit: BoxFit.cover)
                else
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white38, size: 20),
                    ),
                  ),
                if (isGlobalRetakeMode && !isTarget)
                  Container(color: Colors.black54),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    color: isTarget ? const Color(0xFFFF9500) : Colors.black54,
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (!isSaving && file == null && isTarget)
                  const Center(
                      child: Text('补拍',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        ),
      );
    }

    void finishCapture() {
      if (savingThumbnailIndices.value.isNotEmpty) {
        EasyLoading.showToast('图片保存中，请稍候');
        return;
      }
      if (capturedImages.value.isEmpty) {
        unawaited(safeExitPop(<XFile>[]));

        return;
      }

      final result = capturedImages.value.whereType<XFile>().toList();
      Future.wait([
        fastCropQueueRef.value,
        refineCropQueueRef.value,
      ]).then((_) {
        if (!context.mounted || isExitingRef.value) return;
        unawaited(safeExitPop(result));
      }).catchError((_) {
        if (!context.mounted || isExitingRef.value) return;
        unawaited(safeExitPop(result));
      });
      return;
    }

    Widget buildIosFlashButton(camera.CameraController? controller) {
      if (controller == null || !controller.value.isInitialized) {
        return const SizedBox(width: 48);
      }
      return ValueListenableBuilder<camera.CameraValue>(
        valueListenable: controller,
        builder: (_, value, __) {
          final IconData icon;
          switch (value.flashMode) {
            case camera.FlashMode.off:
              icon = Icons.flash_off;
              break;
            case camera.FlashMode.auto:
              icon = Icons.flash_auto;
              break;
            case camera.FlashMode.always:
              icon = Icons.flash_on;
              break;
            case camera.FlashMode.torch:
              icon = Icons.flashlight_on;
              break;
            default:
              icon = Icons.flash_off;
          }
          return IconButton(
            onPressed: cycleIosFlashMode,
            icon: Icon(icon, color: Colors.white),
          );
        },
      );
    }

    Widget buildIosAspectRatioButton() {
      return _AspectRatioSwitchButton(
        aspectRatio: displayAspectRatio.value,
        onSwitch: () async => cycleIosAspectRatio(),
      );
    }

    Widget buildOverlay({
      required VoidCallback onTakePhoto,
      required Widget flashButton,
      required Widget aspectRatioButton,
      Rect? effectiveCaptureRectOverride,
    }) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize =
              Size(constraints.maxWidth, constraints.maxHeight);
          viewportSizeRef.value = viewportSize;
          const Color primaryColor = Color(0xFF007AFF);
          const Color warningColor = Color(0xFFFF9500);
          final bool shutterDisabled = atCaptureLimit || isCapturing.value;
          final Rect effectiveCaptureRect = effectiveCaptureRectOverride ??
              resolveEffectiveCaptureRect(
                viewportSize,
                Offset.zero & viewportSize,
                displayAspectRatio.value,
              );

          Widget buildShutterButton() {
            return GestureDetector(
              onTap: shutterDisabled ? null : onTakePhoto,
              child: ScaleTransition(
                scale: shutterScaleAnim,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: shutterDisabled ? Colors.white38 : Colors.white,
                      width: 4,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isRetakeMode
                          ? warningColor
                          : shutterDisabled
                              ? Colors.white38
                              : Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }

          Widget buildDoneButton() {
            return GestureDetector(
              onTap: finishCapture,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: validCapturedCount > 0 ? 1.0 : 0.5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('完成',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // 成片区域遮罩
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CaptureFrameMaskPainter(
                      captureRect: effectiveCaptureRect,
                    ),
                  ),
                ),
              ),
              // 聚焦指示器
              if (showCenterFocusPoint.value)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double pointSize =
                        math.min(constraints.maxWidth, constraints.maxHeight) /
                            5;
                    return IgnorePointer(
                      child: Center(
                        child: CameraFocusPoint(
                          key: ValueKey(centerFocusPointKey.value),
                          size: pointSize,
                          color: ui.Color.fromARGB(255, 49, 202, 82),
                        ),
                      ),
                    );
                  },
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Spacer(),
                          if (isRetakeMode)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: warningColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text('正在重拍第 ${replaceIndex.value! + 1} 张',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => unawaited(safeExitPop()),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20),
                            ),
                          ),

                          const Spacer(),

                          // 闪光灯 按钮
                          flashButton,
                          const SizedBox(width: 10),
                          // 画幅切换 按钮
                          aspectRatioButton,
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (capturedImages.value.isNotEmpty)
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.3),
                            alignment: Alignment.centerLeft,
                            child: ListView.separated(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: capturedImages.value.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, index) =>
                                  buildDefaultThumbnailItem(
                                      index, isRetakeMode),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 48,
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: bottomSideSlotWidth,
                              child: Center(
                                child: Text(
                                  hasCaptureLimit
                                      ? '已拍 $validCapturedCount/$maxCount'
                                      : '已拍 $validCapturedCount',
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ),
                            ),
                            // 拍照按钮
                            buildShutterButton(),
                            // 完成按钮
                            SizedBox(
                              width: bottomSideSlotWidth,
                              child: Center(child: buildDoneButton()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    Widget buildWechatOverlay(
      camera.CameraController? controller,
      Size viewportSize,
    ) {
      iosCameraControllerRef.value = controller;
      if (controller != null &&
          controller.value.isInitialized &&
          !identical(lastDefaultZoomControllerRef.value, controller)) {
        lastDefaultZoomControllerRef.value = controller;
        unawaited(() async {
          await applyDefaultZoom(controller);
          await focusOnCenter(controller);
        }());
      }
      if (controller != null && controller.value.isInitialized) {
        iosCameraAspectRatioRef.value = resolveWechatIosCameraAspectRatio(
          controller.value,
          iosCameraAspectRatioRef.value,
        );
        iosCameraLensDirectionRef.value = controller.description.lensDirection;
      }
      final effectiveRect = resolveWechatIosEffectiveCaptureRect(
        viewportSize,
        displayAspectRatio.value,
        cameraAspectRatio: iosCameraAspectRatioRef.value,
      );
      return buildOverlay(
        onTakePhoto: requestIosTakePhoto,
        flashButton: buildIosFlashButton(controller),
        aspectRatioButton: buildIosAspectRatioButton(),
        effectiveCaptureRectOverride: effectiveRect,
      );
    }

    iosOverlayBuilderRef.value = buildWechatOverlay;
    wechatPickerStateRef.value?.buildCustomForeground =
        (ctx, constraints, controller) {
      final viewportSize = Size(
        constraints.maxWidth,
        constraints.maxHeight,
      );
      return iosOverlayBuilderRef.value(controller, viewportSize);
    };

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        unawaited(safeExitPop());
      },
      child: CameraPicker(
        createPickerState: () {
          final state = _ContinuousWechatPickerState();
          wechatPickerStateRef.value = state;
          state.overlayRepaintListenable = iosOverlayRepaintTick;
          state.buildCustomForeground = (ctx, constraints, controller) {
            final viewportSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            return iosOverlayBuilderRef.value(controller, viewportSize);
          };
          return state;
        },
        pickerConfig: CameraPickerConfig(
          enableRecording: false,
          enableAudio: false,
          // 预览与成片均锁定竖屏。
          // 不指定 resolutionPreset，使用插件默认 ultraHigh（避免 max 在部分机型初始化闪退）。
          lockCaptureOrientation: DeviceOrientation.portraitUp,
          preferredFlashMode: camera.FlashMode.off,
          onXFileCaptured: (file, _) {
            unawaited(handleIosWechatCapture(file));
            return true;
          },
        ),
      ),
    );
  }
}

/// 在预览上标出实际成片区域。
class _CaptureFrameMaskPainter extends CustomPainter {
  final Rect captureRect;

  const _CaptureFrameMaskPainter({required this.captureRect});

  @override
  void paint(Canvas canvas, Size size) {
    if (captureRect.width <= 0 || captureRect.height <= 0) return;

    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.55);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRect(captureRect),
      ),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = ContinuousCameraPageOtherPhoto.captureFrameBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ContinuousCameraPageOtherPhoto.captureFrameBorderWidth;
    canvas.drawRect(captureRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CaptureFrameMaskPainter oldDelegate) {
    return oldDelegate.captureRect != captureRect;
  }
}

/// 无尺寸切换的连拍相机：全平台使用 [wechat_camera_picker]，不支持画幅切换与裁剪。
/// 预览始终为竖长画幅；开启「成片跟随横竖」时，横拿手机生成横图、竖拿生成竖图。
/// 按照字段拍摄定制化 自定义横屏旋转、不带有画幅切换
class ContinuousCameraPageWithoutSize extends HookConsumerWidget {
  static const double bottomSideSlotWidth = 80;

  /// 默认变焦倍率（相对光学 1.0）。
  static const double defaultZoomLevel = 1.1;

  /// 连拍最大张数；null 或 <=0 表示不限制
  final int? maxCount;

  /// 连拍缩略图底部展示的标签，与待拍字段顺序一致。
  final List<String>? captureFieldLabels;

  /// 进入页面时是否默认开启「成片跟随横竖」（预览始终竖屏，顶部可再切换）。
  final bool initialEnableGyroscopeRotation;

  const ContinuousCameraPageWithoutSize({
    super.key,
    this.maxCount,
    this.captureFieldLabels,
    this.initialEnableGyroscopeRotation = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturedImages = useState<List<XFile?>>([]);
    final replaceIndex = useState<int?>(null);
    final scrollController = useScrollController();
    final shutterAnimController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );
    final isCapturing = useState(false);
    final gyroEnabled = useState(initialEnableGyroscopeRotation);
    final isExitingRef = useRef(false);
    final pendingTargetIndexRef = useRef<int?>(null);
    final wechatPickerStateRef = useRef<_ContinuousWechatPickerState?>(null);
    final cameraControllerRef = useRef<camera.CameraController?>(null);
    final lastCenteredFocusControllerRef =
        useRef<camera.CameraController?>(null);

    /// CameraPicker 的 createState 只执行一次，需通过 ref 拿到最新 overlay 构建函数。
    final overlayBuilderRef = useRef<Widget Function(camera.CameraController?)>(
      (_) => const SizedBox.shrink(),
    );
    final showCenterFocusPoint = useState(false);
    final centerFocusPointKey = useState(0);
    final focusPointHideTimerRef = useRef<Timer?>(null);
    final overlayRepaintTick = useMemoized(() => ValueNotifier(0), []);
    useEffect(
      () {
        // 预览 UI 强制竖屏；横拿手机时界面不变，仅成片方向随陀螺仪变化。
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
        ]);
        return () {
          focusPointHideTimerRef.value?.cancel();
          overlayRepaintTick.dispose();
          SystemChrome.setPreferredOrientations(const [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        };
      },
      [overlayRepaintTick],
    );

    final shutterScaleAnim = useMemoized(
      () => Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(
          parent: shutterAnimController,
          curve: Curves.easeInOut,
        ),
      ),
      [shutterAnimController],
    );

    Future<void> backupToGalleryIfEnabled(String imagePath) async {
      if (!ref.read(settingProvider).photoBackupToGallery) return;
      try {
        await Gal.putImage(imagePath);
      } catch (e) {
        debugPrint('连拍图片备份至相册失败: $e');
      }
    }

    final int validCapturedCount =
        capturedImages.value.where((e) => e != null).length;
    useEffect(() {
      overlayRepaintTick.value++;
      return null;
    }, [
      capturedImages.value,
      isCapturing.value,
      replaceIndex.value,
      validCapturedCount,
      gyroEnabled.value,
    ]);

    final bool hasCaptureLimit = maxCount != null && maxCount! > 0;
    final bool isAtCaptureLimit =
        hasCaptureLimit && validCapturedCount >= maxCount!;
    final bool isRetakeMode = replaceIndex.value != null;
    final bool atCaptureLimit = !isRetakeMode && isAtCaptureLimit;
    final bool useLabelThumbnails =
        captureFieldLabels != null && captureFieldLabels!.isNotEmpty;
    final String? currentCaptureLabel = () {
      final labels = captureFieldLabels;
      if (labels == null || labels.isEmpty) return null;
      final int index = isRetakeMode ? replaceIndex.value! : validCapturedCount;
      if (index < labels.length) return labels[index];
      return '其他';
    }();

    void applyCapturedFile(int index, XFile file) {
      final nextImages = [...capturedImages.value];
      if (index < nextImages.length) {
        nextImages[index] = file;
      } else {
        while (nextImages.length < index) {
          nextImages.add(null);
        }
        nextImages.add(file);
      }
      capturedImages.value = nextImages;
    }

    void scrollThumbnailsToEnd() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
          );
        }
      });
    }

    Future<void> waitForCameraOperations() async {
      const maxAttempts = 60;
      for (var i = 0; i < maxAttempts; i++) {
        if (!isCapturing.value) break;
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    Future<void> safeExitPop<T extends Object?>([T? result]) async {
      if (isExitingRef.value) return;
      isExitingRef.value = true;
      await waitForCameraOperations();
      await Future.delayed(const Duration(milliseconds: 200));
      if (context.mounted) {
        Navigator.pop(context, result);
      }
    }

    /// 显示画面正中的对焦框 UI，约 2 秒后淡出。
    void showCenterFocusPointUi() {
      focusPointHideTimerRef.value?.cancel();
      centerFocusPointKey.value++;
      showCenterFocusPoint.value = true;
      overlayRepaintTick.value++;
      focusPointHideTimerRef.value = Timer(const Duration(seconds: 2), () {
        showCenterFocusPoint.value = false;
        overlayRepaintTick.value++;
      });
    }

    /// 将对焦/曝光点对准预览正中（归一化坐标 0.5, 0.5）。
    Future<void> focusOnCenter(camera.CameraController? controller) async {
      if (controller == null || !controller.value.isInitialized) return;
      showCenterFocusPointUi();
      try {
        const center = Offset(0.5, 0.5);
        await Future.wait(<Future<void>>[
          if (controller.value.focusPointSupported)
            controller.setFocusPoint(center),
          if (controller.value.exposurePointSupported)
            controller.setExposurePoint(center),
        ]);
        await controller.setFocusMode(camera.FocusMode.auto);
        if (controller.value.exposureMode != camera.ExposureMode.locked) {
          await controller.setExposureMode(camera.ExposureMode.auto);
        }
      } catch (e) {
        debugPrint('Focus on center error: $e');
      }
    }

    /// 默认放大 [defaultZoomLevel] 倍（受设备 min/max zoom 约束）。
    Future<void> applyDefaultZoom(camera.CameraController? controller) async {
      if (controller == null || !controller.value.isInitialized) return;
      try {
        final double minZoom = await controller.getMinZoomLevel();
        final double maxZoom = await controller.getMaxZoomLevel();
        final double zoom = defaultZoomLevel.clamp(minZoom, maxZoom).toDouble();
        await controller.setZoomLevel(zoom);
      } catch (e) {
        debugPrint('Apply default zoom error: $e');
      }
    }

    Future<void> resumePreview() async {
      final controller = cameraControllerRef.value;
      if (controller == null || !controller.value.isInitialized) return;
      try {
        await controller.setFocusMode(camera.FocusMode.auto);
        await controller.setExposureMode(camera.ExposureMode.auto);
        await controller.resumePreview();
        await applyDefaultZoom(controller);
        await focusOnCenter(controller);
      } catch (e) {
        debugPrint('Resume preview error: $e');
      }
    }

    Future<void> handleCapturedFile(XFile file) async {
      final targetIndex = pendingTargetIndexRef.value;
      pendingTargetIndexRef.value = null;
      isCapturing.value = false;
      unawaited(resumePreview());
      if (targetIndex == null || !context.mounted || isExitingRef.value) {
        return;
      }

      if (replaceIndex.value != null) {
        applyCapturedFile(targetIndex, file);
        replaceIndex.value = null;
      } else {
        applyCapturedFile(targetIndex, file);
        scrollThumbnailsToEnd();
      }
      unawaited(backupToGalleryIfEnabled(file.path));
    }

    /// 按下快门：先锁定对焦/曝光（锁住画面），再生成图片。
    Future<void> lockFrameThenCapture(
      camera.CameraController controller,
    ) async {
      const center = Offset(0.5, 0.5);
      try {
        if (controller.value.focusPointSupported) {
          await controller.setFocusPoint(center);
        }
        if (controller.value.exposurePointSupported) {
          await controller.setExposurePoint(center);
        }
      } catch (e) {
        debugPrint('Set focus/exposure point error: $e');
      }

      try {
        await controller.setFocusMode(camera.FocusMode.locked);
      } catch (e) {
        debugPrint('Lock focus error: $e');
      }
      try {
        await controller.setExposureMode(camera.ExposureMode.locked);
      } catch (e) {
        debugPrint('Lock exposure error: $e');
      }

      // 等待锁定生效，避免仍在追焦时出片发糊。
      await Future.delayed(const Duration(milliseconds: 120));

      XFile file = await controller.takePicture();
      // 预览始终竖长；成片按手机姿态旋转成横图/竖图。
      final pickerState = wechatPickerStateRef.value;
      if (pickerState != null) {
        file = await pickerState.orientCapturedFile(file);
      }

      // 出片后立即冻结预览，画面定格。
      try {
        await controller.pausePreview();
      } catch (e) {
        debugPrint('Pause preview error: $e');
      }

      await handleCapturedFile(file);
    }

    Future<void> cycleFlashMode() async {
      final controller = cameraControllerRef.value;
      if (controller == null || !controller.value.isInitialized) return;
      const modes = [
        camera.FlashMode.off,
        camera.FlashMode.auto,
        camera.FlashMode.always,
        camera.FlashMode.torch,
      ];
      final current = controller.value.flashMode;
      final next = modes[(modes.indexOf(current) + 1) % modes.length];
      try {
        await controller.setFlashMode(next);
      } catch (e) {
        debugPrint('Switch flash error: $e');
      }
    }

    Future<void> toggleGyroscopeRotation() async {
      final next = !gyroEnabled.value;
      gyroEnabled.value = next;
      HapticFeedback.selectionClick();

      final pickerState = wechatPickerStateRef.value;
      pickerState?.setGyroscopeRotationEnabled(next);
      // 预览永远锁定竖长画幅，不随横拿改变。
      pickerState?.lockedCaptureOrientation = DeviceOrientation.portraitUp;

      final controller = cameraControllerRef.value;
      if (controller == null || !controller.value.isInitialized) return;
      try {
        await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } catch (e) {
        debugPrint('Toggle gyroscope rotation error: $e');
      }
      EasyLoading.showToast(next ? '成片跟随横竖' : '成片锁定竖屏');
      overlayRepaintTick.value++;
    }

    Future<void> requestTakePhoto() async {
      final controller = cameraControllerRef.value;
      if (controller == null ||
          !controller.value.isInitialized ||
          isCapturing.value ||
          controller.value.isTakingPicture) {
        return;
      }
      if (replaceIndex.value == null && isAtCaptureLimit) {
        EasyLoading.showToast('最多可拍 $maxCount 张');
        return;
      }

      final int targetIndex = replaceIndex.value ?? capturedImages.value.length;
      pendingTargetIndexRef.value = targetIndex;
      isCapturing.value = true;
      shutterAnimController
          .forward()
          .then((_) => shutterAnimController.reverse());
      HapticFeedback.lightImpact();
      try {
        // 不走 wechat takePicture：先锁画面，再生成图片。
        await lockFrameThenCapture(controller);
      } catch (e) {
        debugPrint('Take photo error: $e');
        pendingTargetIndexRef.value = null;
        isCapturing.value = false;
        unawaited(resumePreview());
      }
    }

    void deleteAndRetake(int index) {
      final nextImages = [...capturedImages.value];
      nextImages[index] = null;
      capturedImages.value = nextImages;
      replaceIndex.value = index;
    }

    void showImagePreview(int index) {
      final XFile? file = capturedImages.value[index];
      if (file == null) return;

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Preview',
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (ctx, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: InteractiveViewer(
                      child: Image.file(File(file.path), fit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                          Text(
                            '${index + 1}/${capturedImages.value.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 77,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (captureFieldLabels != null &&
                            captureFieldLabels!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              index < captureFieldLabels!.length
                                  ? captureFieldLabels![index]
                                  : '其他',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            deleteAndRetake(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(153, 44, 44, 44),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  '重拍',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget buildDefaultThumbnailItem(int index, bool isGlobalRetakeMode) {
      final XFile? file = capturedImages.value[index];
      final bool isTarget = replaceIndex.value == index;

      Border? currentBorder;
      if (isTarget) {
        currentBorder = Border.all(color: const Color(0xFFFF9500), width: 2);
      } else {
        currentBorder =
            Border.all(color: Colors.white.withOpacity(0.2), width: 1);
      }

      return GestureDetector(
        onTap: () {
          if (file == null) {
            replaceIndex.value = index;
          } else {
            showImagePreview(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: currentBorder,
            color: Colors.white.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (file != null)
                  Image.file(File(file.path), fit: BoxFit.cover)
                else
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white38, size: 20),
                    ),
                  ),
                if (isGlobalRetakeMode && !isTarget)
                  Container(color: Colors.black54),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    color: isTarget ? const Color(0xFFFF9500) : Colors.black54,
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (file == null && isTarget)
                  const Center(
                    child: Text(
                      '补拍',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildLabelThumbnailItem(int index, bool isGlobalRetakeMode) {
      final XFile? file = capturedImages.value[index];
      final bool isTarget = replaceIndex.value == index;
      final String caption =
          (captureFieldLabels != null && index < captureFieldLabels!.length)
              ? captureFieldLabels![index]
              : '其他';

      return GestureDetector(
        onTap: () {
          if (file == null) {
            replaceIndex.value = index;
          } else {
            showImagePreview(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              children: [
                if (file != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(file.path),
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 56,
                    color: const Color.fromARGB(31, 110, 58, 58),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white38, size: 20),
                    ),
                  ),
                if (isGlobalRetakeMode && !isTarget)
                  Container(color: Colors.black54),
                Container(
                  width: 56,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  color: isTarget
                      ? const Color(0xFFFF9500)
                      : const Color.fromARGB(0, 255, 255, 255),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void finishCapture() {
      if (capturedImages.value.isEmpty) {
        unawaited(safeExitPop(<XFile>[]));
        return;
      }
      final result = capturedImages.value.whereType<XFile>().toList();
      unawaited(safeExitPop(result));
    }

    Widget buildFlashButton(camera.CameraController? controller) {
      if (controller == null || !controller.value.isInitialized) {
        return const SizedBox(width: 48);
      }
      return ValueListenableBuilder<camera.CameraValue>(
        valueListenable: controller,
        builder: (_, value, __) {
          final IconData icon;
          switch (value.flashMode) {
            case camera.FlashMode.off:
              icon = Icons.flash_off;
              break;
            case camera.FlashMode.auto:
              icon = Icons.flash_auto;
              break;
            case camera.FlashMode.always:
              icon = Icons.flash_on;
              break;
            case camera.FlashMode.torch:
              icon = Icons.flashlight_on;
              break;
            default:
              icon = Icons.flash_off;
          }
          return IconButton(
            onPressed: cycleFlashMode,
            icon: Icon(icon, color: Colors.white),
          );
        },
      );
    }

    Widget buildGyroscopeButton() {
      return IconButton(
        onPressed: () => unawaited(toggleGyroscopeRotation()),
        tooltip: gyroEnabled.value ? '成片跟随横竖：开' : '成片锁定竖屏',
        icon: Icon(
          gyroEnabled.value
              ? Icons.screen_rotation
              : Icons.screen_lock_rotation,
          color: Colors.white,
        ),
      );
    }

    Widget buildOverlay(camera.CameraController? controller) {
      cameraControllerRef.value = controller;
      if (controller != null &&
          controller.value.isInitialized &&
          !identical(lastCenteredFocusControllerRef.value, controller)) {
        lastCenteredFocusControllerRef.value = controller;
        unawaited(() async {
          await applyDefaultZoom(controller);
          await focusOnCenter(controller);
        }());
      }
      const Color primaryColor = Color(0xFF007AFF);
      const Color warningColor = Color(0xFFFF9500);
      final bool shutterDisabled = atCaptureLimit || isCapturing.value;

      return Stack(
        fit: StackFit.expand,
        children: [
          if (showCenterFocusPoint.value)
            LayoutBuilder(
              builder: (context, constraints) {
                final double pointSize =
                    math.min(constraints.maxWidth, constraints.maxHeight) / 5;
                return IgnorePointer(
                  child: Center(
                    child: CameraFocusPoint(
                      key: ValueKey(centerFocusPointKey.value),
                      size: pointSize,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Spacer(),
                      if (isRetakeMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: warningColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '正在重拍第 ${replaceIndex.value! + 1} 张',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => unawaited(safeExitPop()),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    buildFlashButton(controller),
                    buildGyroscopeButton(),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (capturedImages.value.isNotEmpty)
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                        sigmaX: useLabelThumbnails ? 3 : 10,
                        sigmaY: useLabelThumbnails ? 3 : 10,
                      ),
                      child: Container(
                        height: 90,
                        width: double.infinity,
                        color: useLabelThumbnails
                            ? const Color.fromARGB(255, 164, 164, 164)
                                .withOpacity(0.2)
                            : Colors.black.withOpacity(0.3),
                        alignment: Alignment.centerLeft,
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: capturedImages.value.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) => useLabelThumbnails
                              ? buildLabelThumbnailItem(index, isRetakeMode)
                              : buildDefaultThumbnailItem(index, isRetakeMode),
                        ),
                      ),
                    ),
                  ),
                if (useLabelThumbnails)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 25),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    alignment: Alignment.center,
                    child: currentCaptureLabel != null &&
                            currentCaptureLabel != '其他'
                        ? Text(
                            '正在拍: $currentCaptureLabel',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: EdgeInsets.only(
                    top: useLabelThumbnails ? 8 : 24,
                    bottom: 48,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: bottomSideSlotWidth,
                          child: Center(
                            child: Text(
                              hasCaptureLimit
                                  ? '已拍 $validCapturedCount/$maxCount'
                                  : '已拍 $validCapturedCount',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: shutterDisabled ? null : requestTakePhoto,
                          child: ScaleTransition(
                            scale: shutterScaleAnim,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: shutterDisabled
                                      ? Colors.white38
                                      : Colors.white,
                                  width: 4,
                                ),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isRetakeMode
                                      ? warningColor
                                      : shutterDisabled
                                          ? Colors.white38
                                          : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: bottomSideSlotWidth,
                          child: Center(
                            child: GestureDetector(
                              onTap: finishCapture,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: validCapturedCount > 0 ? 1.0 : 0.5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '完成',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // 每次 rebuild 刷新回调，避免「正在拍」标签等状态停在首次闭包。
    overlayBuilderRef.value = buildOverlay;
    wechatPickerStateRef.value?.buildCustomForeground =
        (ctx, constraints, controller) {
      return overlayBuilderRef.value(controller);
    };
    wechatPickerStateRef.value?.setGyroscopeRotationEnabled(gyroEnabled.value);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        unawaited(safeExitPop());
      },
      child: CameraPicker(
        createPickerState: () {
          final state = _ContinuousWechatPickerState();
          wechatPickerStateRef.value = state;
          state.overlayRepaintListenable = overlayRepaintTick;
          state.setGyroscopeRotationEnabled(gyroEnabled.value);
          state.buildCustomForeground = (ctx, constraints, controller) {
            return overlayBuilderRef.value(controller);
          };
          return state;
        },
        pickerConfig: CameraPickerConfig(
          enableRecording: false,
          enableAudio: false,
          // 预览始终竖屏铺满；成片横/竖由顶部开关 + 加速度计控制。
          // 不指定 resolutionPreset，使用插件默认 ultraHigh（避免 max 在部分机型初始化闪退）。
          lockCaptureOrientation: DeviceOrientation.portraitUp,
          preferredFlashMode: camera.FlashMode.off,
          // 拍照由 lockFrameThenCapture 自行控制：先锁画面再出片。
        ),
      ),
    );
  }
}
