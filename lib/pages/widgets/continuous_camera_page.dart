import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:cloud/helper/camera_capture.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gal/gal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class _PendingCapture {
  final int targetIndex;

  const _PendingCapture({required this.targetIndex});
}

CameraAspectRatios cycleCaptureAspectRatio(
  CameraAspectRatios current, {
  required bool enableSquareAspectRatio,
}) {
  switch (current) {
    case CameraAspectRatios.ratio_4_3:
      return CameraAspectRatios.ratio_16_9;
    case CameraAspectRatios.ratio_16_9:
      return enableSquareAspectRatio
          ? CameraAspectRatios.ratio_1_1
          : CameraAspectRatios.ratio_4_3;
    case CameraAspectRatios.ratio_1_1:
      return CameraAspectRatios.ratio_4_3;
  }
}

bool usesVirtualSquareCaptureFrame(
  CameraAspectRatios aspectRatio, {
  required bool enableSquareAspectRatio,
}) {
  // 1:1 全平台走虚拟取景 + 拍后裁剪，避免 Android/iOS 原生 ratio_1_1 不稳定。
  return enableSquareAspectRatio && aspectRatio == CameraAspectRatios.ratio_1_1;
}

/// 竖屏连拍画幅：4:3 宽 3 高 4（宽占满），16:9 宽 9 高 16（高占满），1:1 宽占满。
({double widthOverHeight, CaptureFrameFit fit})
    resolvePortraitCaptureFrameLayout(
  CameraAspectRatios aspectRatio, {
  required bool enableSquareAspectRatio,
}) {
  if (usesVirtualSquareCaptureFrame(
    aspectRatio,
    enableSquareAspectRatio: enableSquareAspectRatio,
  )) {
    return (widthOverHeight: 1.0, fit: CaptureFrameFit.fitWidth);
  }
  switch (aspectRatio) {
    case CameraAspectRatios.ratio_1_1:
      return (widthOverHeight: 1.0, fit: CaptureFrameFit.fitWidth);
    case CameraAspectRatios.ratio_4_3:
      return (widthOverHeight: 3 / 4, fit: CaptureFrameFit.fitWidth);
    case CameraAspectRatios.ratio_16_9:
      return (widthOverHeight: 9 / 16, fit: CaptureFrameFit.fitHeight);
  }
}

/// iOS 原生画幅裁剪与 cover 预览不一致，统一走 UI 取景 + 拍后裁剪。
bool shouldSkipNativeAspectRatioSwitch(
  CameraAspectRatios aspectRatio, {
  required bool enableSquareAspectRatio,
}) {
  return Platform.isIOS ||
      usesVirtualSquareCaptureFrame(
        aspectRatio,
        enableSquareAspectRatio: enableSquareAspectRatio,
      );
}

Rect resolveEffectiveCaptureRect(
  Size viewportSize,
  Rect previewRect,
  CameraAspectRatios aspectRatio, {
  required bool enableSquareAspectRatio,
}) {
  if (!shouldSkipNativeAspectRatioSwitch(
    aspectRatio,
    enableSquareAspectRatio: enableSquareAspectRatio,
  )) {
    return previewRect;
  }
  final layout = resolvePortraitCaptureFrameLayout(
    aspectRatio,
    enableSquareAspectRatio: enableSquareAspectRatio,
  );
  return computeCaptureFrameRect(
    viewportSize,
    widthOverHeight: layout.widthOverHeight,
    fit: layout.fit,
  );
}

/// CamerAwesome 内置画幅按钮。
class _AspectRatioSwitchButton extends StatelessWidget {
  final CameraAspectRatios aspectRatio;
  final Future<void> Function() onSwitch;

  const _AspectRatioSwitchButton({
    required this.aspectRatio,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final AssetImage icon;
    final double width;
    switch (aspectRatio) {
      case CameraAspectRatios.ratio_16_9:
        width = 32;
        icon = const AssetImage('packages/camerawesome/assets/icons/16_9.png');
        break;
      case CameraAspectRatios.ratio_4_3:
        width = 24;
        icon = const AssetImage('packages/camerawesome/assets/icons/4_3.png');
        break;
      case CameraAspectRatios.ratio_1_1:
        width = 24;
        icon = const AssetImage('packages/camerawesome/assets/icons/1_1.png');
        break;
    }

    return AwesomeOrientedWidget(
      child: AwesomeBouncingWidget(
        onTap: onSwitch,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Image(image: icon, width: width),
          ),
        ),
      ),
    );
  }
}

/// 连拍相机页面（CamerAwesome），支持连续拍摄、缩略图、补拍、主图分组、张数限制。
class ContinuousCameraPage extends HookConsumerWidget {
  static const double focusIndicatorSize = 80;
  static const double bottomSideSlotWidth = 80;
  static const Color captureFrameBorderColor = Colors.black;
  static const double captureFrameBorderWidth = 1.5;

  final bool isMain;

  /// 连拍最大张数；null 或 <=0 表示不限制
  final int? maxCount;

  /// 为 true 时画幅循环包含 1:1（Android 为虚拟取景 + 拍后裁剪）。
  final bool enableSquareAspectRatio;

  /// 连拍缩略图底部展示的标签，与待拍字段顺序一致。
  final List<String>? captureFieldLabels;

  const ContinuousCameraPage({
    super.key,
    this.isMain = false,
    this.maxCount,
    this.enableSquareAspectRatio = false,
    this.captureFieldLabels,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturedImages = useState<List<XFile?>>([]);
    final replaceIndex = useState<int?>(null);
    final scrollController = useScrollController();
    final shutterAnimController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );
    final isMainImage = useState(isMain);
    final mainImageFlags = useState<Map<int, bool>>({});
    final isCapturing = useState(false);
    final displayAspectRatio = useState(CameraAspectRatios.ratio_4_3);
    final isAspectRatioSwitchingRef = useRef(false);
    final isExitingRef = useRef(false);
    final photoStateRef = useRef<PhotoCameraState?>(null);
    final viewportSizeRef = useRef<Size?>(null);
    final pendingCaptureRef = useRef<_PendingCapture?>(null);
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
        if (!isCapturing.value && !isAspectRatioSwitchingRef.value) return;
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    Future<void> safeExitPop<T extends Object?>([T? result]) async {
      if (isExitingRef.value) return;
      isExitingRef.value = true;
      await waitForCameraOperations();
      // 给 CameraX 释放预览/纹理留出时间，避免返回时原生层闪退。
      await Future.delayed(const Duration(milliseconds: 200));
      if (context.mounted) {
        Navigator.pop(context, result);
      }
    }

    Future<void> switchAspectRatio(SensorConfig sensorConfig) async {
      if (isAspectRatioSwitchingRef.value || isCapturing.value) return;
      isAspectRatioSwitchingRef.value = true;
      HapticFeedback.selectionClick();
      try {
        final next = cycleCaptureAspectRatio(
          displayAspectRatio.value,
          enableSquareAspectRatio: enableSquareAspectRatio,
        );
        displayAspectRatio.value = next;

        // Android 1:1 / iOS 全画幅：仅 UI 取景 + 拍后裁剪，避免原生裁剪与 cover 预览不一致。
        if (!shouldSkipNativeAspectRatioSwitch(
          next,
          enableSquareAspectRatio: enableSquareAspectRatio,
        )) {
          await sensorConfig.setAspectRatio(next);
        }
      } catch (e) {
        debugPrint('Switch aspect ratio error: $e');
        EasyLoading.showToast('切换画幅失败，请重试');
      } finally {
        isAspectRatioSwitchingRef.value = false;
      }
    }

    Future<XFile> processCapturedFile(String path) async {
      final aspectRatio = displayAspectRatio.value;
      if (!shouldSkipNativeAspectRatioSwitch(
        aspectRatio,
        enableSquareAspectRatio: enableSquareAspectRatio,
      )) {
        return XFile(path);
      }

      try {
        final screenSize =
            viewportSizeRef.value ?? MediaQuery.sizeOf(context);
        final pixelRatio = MediaQuery.devicePixelRatioOf(context);
        final maxDecodeWidth =
            (screenSize.width * pixelRatio).round().clamp(1080, 2560);
        final layout = resolvePortraitCaptureFrameLayout(
          aspectRatio,
          enableSquareAspectRatio: enableSquareAspectRatio,
        );
        final cropped = await cropImageToScreenAspectFrame(
          File(path),
          screenSize,
          widthOverHeight: layout.widthOverHeight,
          fit: layout.fit,
          maxDecodeWidth: maxDecodeWidth,
        );
        if (cropped != null) return XFile(cropped.path);
      } catch (e) {
        debugPrint('Crop to preview frame error: $e');
      }
      return XFile(path);
    }

    Future<void> handleCapturedPath(String path) async {
      final pending = pendingCaptureRef.value;
      if (pending == null) return;

      final int targetIndex = pending.targetIndex;
      final processedFile = await processCapturedFile(path);
      if (!context.mounted || isExitingRef.value) {
        pendingCaptureRef.value = null;
        isCapturing.value = false;
        return;
      }

      if (replaceIndex.value != null) {
        applyCapturedFile(targetIndex, processedFile);
        replaceIndex.value = null;
      } else {
        capturedImages.value = [...capturedImages.value, processedFile];
        scrollThumbnailsToEnd();
      }

      if (isMain) {
        mainImageFlags.value = {
          ...mainImageFlags.value,
          targetIndex: isMainImage.value,
        };
        if (isMainImage.value) isMainImage.value = false;
      }

      unawaited(backupToGalleryIfEnabled(processedFile.path));

      pendingCaptureRef.value = null;
      isCapturing.value = false;
    }

    Future<void> requestTakePhoto() async {
      final photoState = photoStateRef.value;
      if (photoState == null || isCapturing.value) return;
      if (replaceIndex.value == null && isAtCaptureLimit) {
        EasyLoading.showToast('最多可拍 $maxCount 张');
        return;
      }

      isCapturing.value = true;
      pendingCaptureRef.value = _PendingCapture(
        targetIndex: replaceIndex.value ?? capturedImages.value.length,
      );

      shutterAnimController
          .forward()
          .then((_) => shutterAnimController.reverse());
      HapticFeedback.lightImpact();

      try {
        final String path = await photoState.takePhoto();
        await handleCapturedPath(path);
      } catch (e) {
        debugPrint('Take photo error: $e');
        pendingCaptureRef.value = null;
        isCapturing.value = false;
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
          return HookBuilder(
            builder: (context) {
              final isMainFlag = useState(mainImageFlags.value[index] ?? false);

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
                              if (captureFieldLabels != null &&
                                  captureFieldLabels!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isMain) ...[
                                    GestureDetector(
                                      onTap: () {
                                        isMainFlag.value = !isMainFlag.value;
                                        mainImageFlags.value = {
                                          ...mainImageFlags.value,
                                          index: isMainFlag.value,
                                        };
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isMainFlag.value
                                              ? Colors.amber.withOpacity(0.2)
                                              : const Color(0xFF2C2C2C),
                                          border: Border.all(
                                              color: isMainFlag.value
                                                  ? Colors.amber
                                                  : Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isMainFlag.value
                                                  ? Icons.star_rounded
                                                  : Icons.star_outline_rounded,
                                              color: isMainFlag.value
                                                  ? Colors.amber
                                                  : Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              isMainFlag.value
                                                  ? '取消主图'
                                                  : '设为主图',
                                              style: TextStyle(
                                                color: isMainFlag.value
                                                    ? Colors.amber
                                                    : Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
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
      final bool isTarget = replaceIndex.value == index;
      final bool isMainFlag = isMain && (mainImageFlags.value[index] ?? false);

      Border? currentBorder;
      if (isTarget) {
        currentBorder = Border.all(color: const Color(0xFFFF9500), width: 2);
      } else if (isMainFlag) {
        currentBorder = Border.all(color: Colors.amber, width: 2);
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
                if (isMainFlag)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: const Text(
                        '主图',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
                if (file == null && isTarget)
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

    // 字段文案展示的缩略图
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
                        fontWeight: FontWeight.bold),
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
        if (isMain) {
          unawaited(safeExitPop(<Map<String, dynamic>>[]));
        } else {
          unawaited(safeExitPop(<XFile>[]));
        }
        return;
      }

      if (!isMain) {
        final result = capturedImages.value.whereType<XFile>().toList();
        unawaited(safeExitPop(result));
        return;
      }

      final List<Map<String, dynamic>> groupedResults = [];
      Map<String, dynamic>? currentGroup;

      for (int i = 0; i < capturedImages.value.length; i++) {
        final file = capturedImages.value[i];
        if (file == null) continue;

        final bool isMainFlag = mainImageFlags.value[i] == true;

        if (isMainFlag) {
          currentGroup = {
            'main': file,
            'details': <XFile>[],
          };
          groupedResults.add(currentGroup);
        } else if (currentGroup == null) {
          currentGroup = {
            'main': null,
            'details': <XFile>[file],
          };
          groupedResults.add(currentGroup);
        } else {
          (currentGroup['details'] as List<XFile>).add(file);
        }
      }

      unawaited(safeExitPop(groupedResults));
    }

    Widget buildOverlay(PhotoCameraState photoState, Rect captureRect) {
      photoStateRef.value = photoState;
      return LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize =
              Size(constraints.maxWidth, constraints.maxHeight);
          viewportSizeRef.value = viewportSize;
          const Color primaryColor = Color(0xFF007AFF);
          const Color warningColor = Color(0xFFFF9500);
          final bool shutterDisabled = atCaptureLimit || isCapturing.value;
          final Rect effectiveCaptureRect = resolveEffectiveCaptureRect(
            viewportSize,
            captureRect,
            displayAspectRatio.value,
            enableSquareAspectRatio: enableSquareAspectRatio,
          );

      Widget buildShutterButton() {
        return GestureDetector(
          onTap: shutterDisabled ? null : requestTakePhoto,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

      Widget buildAspectRatioButton() {
        return StreamBuilder<SensorConfig>(
          stream: photoState.sensorConfig$,
          builder: (_, sensorConfigSnapshot) {
            if (!sensorConfigSnapshot.hasData) {
              return const SizedBox.shrink();
            }
            final sensorConfig = sensorConfigSnapshot.requireData;
            return _AspectRatioSwitchButton(
              aspectRatio: displayAspectRatio.value,
              onSwitch: () => switchAspectRatio(sensorConfig),
            );
          },
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CaptureFrameMaskPainter(
                  captureRect: effectiveCaptureRect,
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
                      GestureDetector(
                        onTap: () => unawaited(safeExitPop()),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),

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
                      if (isRetakeMode) const Spacer(),
                      // 闪光灯 按钮
                      AwesomeFlashButton(state: photoState),
                      const SizedBox(width: 10),
                      // 画幅切换 按钮
                      buildAspectRatioButton(),
                      const SizedBox(width: 40),
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
                      filter: ImageFilter.blur(
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
                        if (isMain)
                          SizedBox(
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                isMainImage.value = !isMainImage.value;
                                HapticFeedback.mediumImpact();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isMainImage.value
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: isMainImage.value
                                        ? Colors.amber
                                        : Colors.white54,
                                    size: 28,
                                  ),
                                  Text(
                                    '设为主图',
                                    style: TextStyle(
                                      color: isMainImage.value
                                          ? Colors.amber
                                          : Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          width: isMain ? 40 : bottomSideSlotWidth,
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
                          width: isMain ? 80 : bottomSideSlotWidth,
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        unawaited(safeExitPop());
      },
      child: CameraAwesomeBuilder.custom(
        sensor: Sensors.back,
        flashMode: FlashMode.none,
        aspectRatio: CameraAspectRatios.ratio_4_3,
        zoom: 0.0,
        enableAudio: false,
        saveConfig: SaveConfig.photo(
          pathBuilder: () async {
            final Directory dir = await getTemporaryDirectory();
            return '${dir.path}/continuous_${DateTime.now().millisecondsSinceEpoch}.jpg';
          },
        ),
        previewFit: CameraPreviewFit.cover,
        progressIndicator: const ColoredBox(
          color: Colors.black,
          child: Center(
              child: MuProgressIndicator(
                  barWidth: 6,
                  showText: true,
                  text: '正在加载...',
                  textColor: Colors.white)),
        ),
        onPreviewTapBuilder: (state) => OnPreviewTap(
          onTap: (position, flutterPreviewSize, pixelPreviewSize) {
            state.when(
              onPhotoMode: (photoState) {
                photoState.focusOnPoint(
                  flutterPosition: position,
                  pixelPreviewSize: pixelPreviewSize,
                  flutterPreviewSize: flutterPreviewSize,
                );
              },
            );
            HapticFeedback.selectionClick();
          },
          onTapPainter: (position) => AwesomeFocusIndicator(position: position),
          tapPainterDuration: const Duration(seconds: 2),
        ),
        onPreviewScaleBuilder: (state) => OnPreviewScale(
          onScale: (scale) => state.sensorConfig.setZoom(scale),
        ),
        builder: (state, previewSize, previewRect) {
          return state.when(
                onPreparingCamera: (_) => const SizedBox.shrink(),
                onPhotoMode: (photoState) =>
                    buildOverlay(photoState, previewRect),
              ) ??
              const SizedBox.shrink();
        },
      ),
    );
  }
}

/// 在预览上标出实际成片区域（与 CamerAwesome [previewRect] 一致）。
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
      ..color = ContinuousCameraPage.captureFrameBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ContinuousCameraPage.captureFrameBorderWidth;
    canvas.drawRect(captureRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CaptureFrameMaskPainter oldDelegate) {
    return oldDelegate.captureRect != captureRect;
  }
}
