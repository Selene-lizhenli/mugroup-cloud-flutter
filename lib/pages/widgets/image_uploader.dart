import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud/pages/widgets/continuous_camera_page.dart';
export 'continuous_camera_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:cloud/helper/camera_capture.dart';

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


// 支持单拍、相册选择、连拍、16比9画幅、4比3画幅 、智能识别、主图细节图 
// 不支持：显示在拍内容、 1比1画幅 。
class ImageUploader extends HookConsumerWidget {
  final String? label;
  final double? width;
  final double? height;
  final int? maxCount;
  final List<TemporaryMedia>? value;
  final ImageUploaderValueChanged? _onChanged;

  // 智能识别相关
  final bool showRecognizeButton;
  final Future<dynamic> Function(Map<String, dynamic>)? recognizeApi;
  final ValueChanged<dynamic>? onRecognizeResult;
  final String? errorText;

  /// 智能识别按钮位置：
  /// false => 顶部（默认）、true => 底部左对齐
  final bool recognizeAtBottom;

  // --- 核心控制参数 ---
  /// 模式控制：
  /// true  => 单击直接进入普通相机
  /// false => 单击弹出菜单（包含“拍摄”和“相册”）
  final bool directCamera;

  /// 新增参数：直接打开相册
  final bool directGallery;

  /// 连拍开关：
  /// true  => 允许长按进入连拍模式
  /// false => 长按无效果
  final bool enableContinuous;

  final bool showContinuousOption;

  final IconData? customIcon;

  final bool autoRecognize;

  final String? uploaderKey;
  final void Function(MediaDragData source, MediaDragData target)? onSwap;

  final void Function(List<File> files)? onContinuousCapture;

  /// 连拍最大张数；null 表示不限制
  final int? continuousMaxCount;

  final Widget? extraContent;
  final ValueChanged<bool>? onUploadingChanged;

  ImageUploader({
    super.key,
    this.label,
    this.width = 80,
    this.height = 80,
    this.maxCount,
    this.value,
    ValueChanged<List<TemporaryMedia>>? onChanged,
    ImageUploaderValueChanged? onMediaChanged,
    this.autoRecognize = false,
    this.showRecognizeButton = false,
    this.recognizeApi,
    this.onRecognizeResult,
    this.errorText,
    this.recognizeAtBottom = false,
    // 默认设置：保留弹窗，关闭连拍
    this.directCamera = false, //
    this.directGallery = false,//
    this.showContinuousOption = false,
    this.enableContinuous = false,
    this.onContinuousCapture,
    this.continuousMaxCount,
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
    final currentImages = value ?? [];
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    final bool hasError =
        (errorText?.isNotEmpty ?? false) && currentImages.isEmpty;

    Future<void> executeRecognition(List<TemporaryMedia> medias) async {
      if (recognizeApi == null) return;
      try {
        await EasyLoading.show(
            status: '智能识别中...', maskType: EasyLoadingMaskType.clear);
        final result = await recognizeApi!({'image': medias});
        if (result != null && onRecognizeResult != null) {
          EasyLoading.showSuccess("识别成功");
          onRecognizeResult!(result);
        } else {
          EasyLoading.dismiss();
        }
      } catch (e) {
        debugPrint('自动识别异常: $e');
        EasyLoading.dismiss();
      }
    }

    // --- 内部方法：上传文件 (用于连拍/普通拍摄) ---
    Future<void> uploadFiles(List<File> files) async {
      final List<TemporaryMedia> uploadedMedias = [];
      try {
        onUploadingChanged?.call(true);
        EasyLoading.show(status: '上传中...');
        for (final file in files) {
          final TemporaryMedia temporaryMedia = await upload(file: file);
          uploadedMedias.add(temporaryMedia);
        }
      } finally {
        onUploadingChanged?.call(false);
        EasyLoading.dismiss();
      }

      if (uploadedMedias.isNotEmpty) {
        final List<TemporaryMedia> newList = [
          ...currentImages,
          ...uploadedMedias
        ];
        _notifyChanged(newList);

        if (autoRecognize && recognizeApi != null) {
          await executeRecognition(newList);
        }
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
      if (files.isNotEmpty) await uploadFiles(files);
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
      return;
    }

    // --- 动作 2：打开相册 ---
    Future<void> openGallery() async {
      try {
        final permission = await PhotoManager.requestPermissionExtend();
        if (!permission.hasAccess) {
          EasyLoading.showInfo('请先开启相册权限');
          return;
        }

        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: remainingCount,
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
              builder: (context) => ContinuousCameraPage(
                maxCount: continuousMaxCount,
              ),
            ),
          );
          if (result != null && result.isNotEmpty) {
            final List<File> files = result.map((e) => File(e.path)).toList();

            if (onContinuousCapture != null) {
              onContinuousCapture!(files); // 交给父组件处理分发
            } else {
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

      if (directCamera) {
        // 模式一：直接进相机
        await openStandardCamera();
      } else if (directGallery) {
        // 优先级 2：直接进相册 (新增逻辑)
        print(directGallery);
        await openGallery();
      } else {
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

    final bool showTopBar =
        label != null || (showRecognizeButton && !recognizeAtBottom);
    final bool showBottomRecognize = showRecognizeButton && recognizeAtBottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopBar) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold))
              else
                const SizedBox(),
              if (showRecognizeButton && !recognizeAtBottom)
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
                        Text("智能识别",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...List.generate(currentImages.length, (index) {
                  return _buildImageItem(context, index,
                      currentImages[index].thumbUrl ?? currentImages[index].url,
                      onRemove: () => handleDelete(index));
                }),
                if (remainingCount > 0)
                  _buildAddButton(
                    onTap: handleTap,
                    // 只有开启了连拍，才绑定长按事件
                    onLongPress: enableContinuous ? handleLongPress : null,
                    hasError: hasError,
                    currentIndex: currentImages.length,
                  ),
              ],
            ),
            if (extraContent != null) ...[
              extraContent!,
            ],
            if (showBottomRecognize)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12),
                child: GestureDetector(
                  onTap: handleSmartRecognize,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.center_focus_weak,
                          size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Text("智能识别",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
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

  Widget _buildImageItem(BuildContext context, int index, String? url,
      {required VoidCallback onRemove}) {
    final itemContent = Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            final previewUrls = value
                    ?.map((e) => e.url)
                    .where((u) => _isValidPreviewUrl(u))
                    .toList() ??
                const <String>[];

            if (previewUrls.isEmpty) return;
            final safeIndex = index.clamp(0, previewUrls.length - 1);
            showFlanImagePreview(
              context,
              images: previewUrls,
              startPosition: safeIndex,
              loop: false,
            );
          },
          child: Container(
            width: width,
            height: height,
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
    required int currentIndex, //必须传入当前图片的数量
  }) {
    final btnContent = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: width,
        height: height,
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
