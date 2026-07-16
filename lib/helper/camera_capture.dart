import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_crop_isolate.dart';

/// Capture a single photo using system camera.
///
/// We use [image_picker] here because some devices (e.g. certain Huawei pads)
/// can produce blurry results in other camera picker implementations right
/// after shutter confirmation.
Future<File?> captureSinglePhotoFile() async {
  final picker = ImagePicker();
  final XFile? photo = await picker.pickImage(
    source: ImageSource.camera, // 来源：相机（gallery为相册）
    imageQuality: 100, // 图片压缩质量 0~100，100=无压缩原图
    preferredCameraDevice: CameraDevice.rear, // 默认后置摄像头
  );
  if (photo == null) return null;
  return File(photo.path);
}

//  使用系统相机进行单拍
//  使用处： 以图搜图、image_loader单拍等等

/// 连拍快速预览裁剪解码宽度。
const int kContinuousCaptureFastDecodeWidth = 2048;

/// 连拍快路径 JPEG 质量（缩略图）。
const int kContinuousCaptureFastJpegQuality = 88;

/// 精修 JPEG 质量；使用系统编码器，尽量接近原图色彩。
const int kContinuousCaptureRefineJpegQuality = 100;

/// 裁剪前解码的最大宽度；null 表示按原图全分辨率解码。
const int? kCameraCropMaxDecodeWidth = null;

Future<ui.Image> _decodeImageFromBytes(
  Uint8List bytes, {
  int? maxDecodeWidth = kCameraCropMaxDecodeWidth,
}) async {
  final ui.Codec codec = maxDecodeWidth != null
      ? await ui.instantiateImageCodec(bytes, targetWidth: maxDecodeWidth)
      : await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frame = await codec.getNextFrame();
  return frame.image;
}

Future<File> _writeTempCroppedFile(
  Uint8List bytes, {
  required String extension,
}) async {
  final tempDir = await getTemporaryDirectory();
  final outFile = File(
    '${tempDir.path}/camera_crop_${DateTime.now().millisecondsSinceEpoch}.$extension',
  );
  await outFile.writeAsBytes(bytes);
  return outFile;
}

Future<File?> _encodeCroppedImage(ui.Image croppedImage) async {
  final byteData =
      await croppedImage.toByteData(format: ui.ImageByteFormat.png);
  croppedImage.dispose();
  if (byteData == null) return null;

  return _writeTempCroppedFile(
    byteData.buffer.asUint8List(),
    extension: 'png',
  );
}

/// 裁剪后的 [ui.Image] 用系统 JPEG 编码，比 image 包 encodeJpg 更接近相机色彩。
Future<File?> encodeUiImageAsNativeJpeg(
  ui.Image image, {
  int quality = kContinuousCaptureRefineJpegQuality,
}) async {
  final int width = image.width;
  final int height = image.height;
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (byteData == null) return null;

  final Uint8List? compressed = await FlutterImageCompress.compressWithList(
    byteData.buffer.asUint8List(),
    minWidth: width,
    minHeight: height,
    quality: quality,
    format: CompressFormat.jpeg,
    autoCorrectionAngle: false,
    rotate: 0,
    keepExif: false,
  );
  if (compressed == null) return null;
  return _writeTempCroppedFile(compressed, extension: 'jpg');
}

Future<File?> _drawCropAndEncodeNativeJpeg({
  required ui.Image source,
  required Rect cropRect,
  FilterQuality filterQuality = FilterQuality.high,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
}) async {
  final int cropW = cropRect.width.round();
  final int cropH = cropRect.height.round();
  if (cropW <= 0 || cropH <= 0) {
    source.dispose();
    return null;
  }

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    source,
    cropRect,
    Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
    Paint()..filterQuality = filterQuality,
  );
  source.dispose();
  final picture = recorder.endRecording();
  final croppedImage = await picture.toImage(cropW, cropH);
  return encodeUiImageAsNativeJpeg(croppedImage, quality: jpegQuality);
}

/// 连拍精修：系统解码 + 裁剪 + 系统 JPEG 编码，减少重编码偏色。
Future<File> cropImageToViewportCaptureFramePreserveColor(
  String sourcePath,
  Size viewportSize,
  Rect captureFrameInViewport, {
  Rect? coverPreviewRect,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
}) async {
  final sourceFile = File(sourcePath);
  final Rect coverRect = coverPreviewRect != null &&
          coverPreviewRect.width > 0 &&
          coverPreviewRect.height > 0
      ? coverPreviewRect
      : Offset.zero & viewportSize;

  final Rect visibleFrame = captureFrameInViewport.intersect(coverRect);
  if (visibleFrame.width <= 0 || visibleFrame.height <= 0) {
    return sourceFile;
  }

  try {
    final bytes = await sourceFile.readAsBytes();
    final ui.Image image = await _decodeImageFromBytes(bytes);
    final Rect frameInCover = Rect.fromLTWH(
      visibleFrame.left - coverRect.left,
      visibleFrame.top - coverRect.top,
      visibleFrame.width,
      visibleFrame.height,
    );
    final Rect cropRect = computeImageCropRectForCoverPreviewFrame(
      imageSize: Size(image.width.toDouble(), image.height.toDouble()),
      screenSize: coverRect.size,
      screenCaptureFrame: frameInCover,
    );
    final File? encoded = await _drawCropAndEncodeNativeJpeg(
      source: image,
      cropRect: cropRect,
      jpegQuality: jpegQuality,
    );
    return encoded ?? sourceFile;
  } catch (e) {
    debugPrint('Preserve-color viewport crop error: $e');
    return sourceFile;
  }
}

img.Image? _decodeOrientedImage(
  Uint8List bytes, {
  int? maxDecodeWidth,
}) {
  final img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  img.Image oriented = img.bakeOrientation(decoded);
  if (maxDecodeWidth != null && oriented.width > maxDecodeWidth) {
    oriented = img.copyResize(
      oriented,
      width: maxDecodeWidth,
      interpolation: img.Interpolation.linear,
    );
  }
  return oriented;
}

Future<File?> _cropImageBytesWithImagePackage({
  required Uint8List bytes,
  required Size viewportSize,
  required Rect captureFrameInViewport,
  Rect? coverPreviewRect,
  int? maxDecodeWidth,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
}) async {
  final img.Image? decoded = _decodeOrientedImage(
    bytes,
    maxDecodeWidth: maxDecodeWidth,
  );
  if (decoded == null) return null;

  final Rect coverRect = coverPreviewRect != null &&
          coverPreviewRect.width > 0 &&
          coverPreviewRect.height > 0
      ? coverPreviewRect
      : Offset.zero & viewportSize;

  final Rect visibleFrame = captureFrameInViewport.intersect(coverRect);
  if (visibleFrame.width <= 0 || visibleFrame.height <= 0) {
    return null;
  }

  final Rect frameInCover = Rect.fromLTWH(
    visibleFrame.left - coverRect.left,
    visibleFrame.top - coverRect.top,
    visibleFrame.width,
    visibleFrame.height,
  );

  final imageSize =
      Size(decoded.width.toDouble(), decoded.height.toDouble());
  final Rect cropRect = computeImageCropRectForCoverPreviewFrame(
    imageSize: imageSize,
    screenSize: coverRect.size,
    screenCaptureFrame: frameInCover,
  );

  final int cropX = cropRect.left.round().clamp(0, decoded.width - 1);
  final int cropY = cropRect.top.round().clamp(0, decoded.height - 1);
  final int cropW = cropRect.width.round().clamp(1, decoded.width - cropX);
  final int cropH = cropRect.height.round().clamp(1, decoded.height - cropY);

  final img.Image cropped =
      img.copyCrop(decoded, x: cropX, y: cropY, width: cropW, height: cropH);
  final Uint8List encoded = Uint8List.fromList(
    img.encodeJpg(cropped, quality: jpegQuality),
  );
  return _writeTempCroppedFile(encoded, extension: 'jpg');
}

/// 连拍 Android 裁剪：在 isolate 中读文件/解码/裁剪，避免阻塞相机预览。
Future<File> cropImageToViewportCaptureFrameInIsolate(
  String sourcePath,
  Size viewportSize,
  Rect captureFrameInViewport, {
  Rect? coverPreviewRect,
  int? maxDecodeWidth,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
}) async {
  final Rect coverRect = coverPreviewRect != null &&
          coverPreviewRect.width > 0 &&
          coverPreviewRect.height > 0
      ? coverPreviewRect
      : Offset.zero & viewportSize;

  final Rect visibleFrame = captureFrameInViewport.intersect(coverRect);
  if (visibleFrame.width <= 0 || visibleFrame.height <= 0) {
    return File(sourcePath);
  }

  final CroppedImageBytes? result = await compute(
    androidViewportCropIsolate,
    AndroidViewportCropParams(
      sourcePath: sourcePath,
      captureLeft: captureFrameInViewport.left,
      captureTop: captureFrameInViewport.top,
      captureWidth: captureFrameInViewport.width,
      captureHeight: captureFrameInViewport.height,
      coverLeft: coverRect.left,
      coverTop: coverRect.top,
      coverWidth: coverRect.width,
      coverHeight: coverRect.height,
      maxDecodeWidth: maxDecodeWidth,
      jpegQuality: jpegQuality,
    ),
  );
  if (result == null) return File(sourcePath);
  return _writeTempCroppedFile(result.bytes, extension: result.extension);
}

/// 连拍 iOS wechat 裁剪：在 isolate 中处理，避免阻塞相机预览。
Future<File> cropImageForWechatIosFrameInIsolate(
  String sourcePath,
  Rect captureFrameInViewport,
  Rect previewRect, {
  int? maxDecodeWidth,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
  bool rotateIfLandscape = false,
  bool isFrontCamera = false,
}) async {
  if (previewRect.width <= 0 ||
      previewRect.height <= 0 ||
      captureFrameInViewport.width <= 0 ||
      captureFrameInViewport.height <= 0) {
    return File(sourcePath);
  }

  final CroppedImageBytes? result = await compute(
    iosWechatCropIsolate,
    IosWechatCropParams(
      sourcePath: sourcePath,
      captureLeft: captureFrameInViewport.left,
      captureTop: captureFrameInViewport.top,
      captureWidth: captureFrameInViewport.width,
      captureHeight: captureFrameInViewport.height,
      previewLeft: previewRect.left,
      previewTop: previewRect.top,
      previewWidth: previewRect.width,
      previewHeight: previewRect.height,
      maxDecodeWidth: maxDecodeWidth,
      jpegQuality: jpegQuality,
      rotateIfLandscape: rotateIfLandscape,
      isFrontCamera: isFrontCamera,
    ),
  );
  if (result == null) return File(sourcePath);
  return _writeTempCroppedFile(result.bytes, extension: result.extension);
}

/// 竖屏连拍取景框贴边方式。
enum CaptureFrameFit {
  /// 宽度贴满容器，高度按比例（竖屏 4:3：宽 3 高 4）。
  fitWidth,

  /// 高度贴满容器，宽度按比例（竖屏 16:9：宽 9 高 16）。
  fitHeight,

  /// 完整落入容器内居中（1:1 及默认 contain）。
  fitInside,
}

/// 在容器内居中计算取景框。
///
/// [widthOverHeight] 为宽/高（竖屏 4:3 → 3/4，竖屏 16:9 → 9/16，1:1 → 1.0）。
Rect computeCaptureFrameRect(
  Size containerSize, {
  required double widthOverHeight,
  CaptureFrameFit fit = CaptureFrameFit.fitInside,
}) {
  if (widthOverHeight <= 0) {
    return Offset.zero & containerSize;
  }

  late double frameW;
  late double frameH;

  switch (fit) {
    case CaptureFrameFit.fitWidth:
      frameW = containerSize.width;
      frameH = frameW / widthOverHeight;
      return Rect.fromLTWH(
        0,
        (containerSize.height - frameH) / 2,
        frameW,
        frameH,
      );
    case CaptureFrameFit.fitHeight:
      frameH = containerSize.height;
      frameW = frameH * widthOverHeight;
      return Rect.fromLTWH(
        (containerSize.width - frameW) / 2,
        0,
        frameW,
        frameH,
      );
    case CaptureFrameFit.fitInside:
      final double containerAR = containerSize.width / containerSize.height;
      if (containerAR > widthOverHeight) {
        frameH = containerSize.height;
        frameW = frameH * widthOverHeight;
      } else {
        frameW = containerSize.width;
        frameH = frameW / widthOverHeight;
      }
      break;
  }

  return Rect.fromCenter(
    center: Offset(containerSize.width / 2, containerSize.height / 2),
    width: frameW,
    height: frameH,
  );
}

/// 在容器内居中计算目标宽高比（宽/高）的取景框（contain 模式）。
Rect computeCenteredAspectFrameRect(Size containerSize, double aspectRatio) {
  return computeCaptureFrameRect(
    containerSize,
    widthOverHeight: aspectRatio,
    fit: CaptureFrameFit.fitInside,
  );
}

/// 预览以 cover 铺满屏幕时，将屏幕上的取景框映射到成片裁剪区域。
Rect computeImageCropRectForScreenFrame({
  required Size imageSize,
  required Size screenSize,
  required double targetAspectRatio,
}) {
  if (targetAspectRatio <= 0) {
    return Offset.zero & imageSize;
  }

  final Rect screenFrame = computeCaptureFrameRect(
    screenSize,
    widthOverHeight: targetAspectRatio,
    fit: CaptureFrameFit.fitInside,
  );
  return computeImageCropRectForCoverPreviewFrame(
    imageSize: imageSize,
    screenSize: screenSize,
    screenCaptureFrame: screenFrame,
  );
}

/// cover 模式下，[viewportSize] 视口在 [contentSize] 内容上的可见居中区域。
Rect computeCoverVisibleRect(Size contentSize, Size viewportSize) {
  if (contentSize.width <= 0 ||
      contentSize.height <= 0 ||
      viewportSize.width <= 0 ||
      viewportSize.height <= 0) {
    return Offset.zero & contentSize;
  }

  final double contentAR = contentSize.width / contentSize.height;
  final double viewportAR = viewportSize.width / viewportSize.height;

  late double visibleW;
  late double visibleH;
  late double visibleX;
  late double visibleY;

  if (contentAR > viewportAR) {
    visibleH = contentSize.height;
    visibleW = visibleH * viewportAR;
    visibleX = (contentSize.width - visibleW) / 2;
    visibleY = 0;
  } else {
    visibleW = contentSize.width;
    visibleH = visibleW / viewportAR;
    visibleX = 0;
    visibleY = (contentSize.height - visibleH) / 2;
  }

  return Rect.fromLTWH(visibleX, visibleY, visibleW, visibleH);
}

Rect _clampRectWithinBounds(Rect rect, Rect bounds) {
  final double left = rect.left.clamp(bounds.left, bounds.right);
  final double top = rect.top.clamp(bounds.top, bounds.bottom);
  final double right = rect.right.clamp(bounds.left, bounds.right);
  final double bottom = rect.bottom.clamp(bounds.top, bounds.bottom);
  if (right <= left || bottom <= top) {
    return bounds;
  }
  return Rect.fromLTRB(left, top, right, bottom);
}

/// cover 预览：将屏幕取景框按归一化坐标映射到成片 cover 可见区域。
Rect computeImageCropRectForCoverPreviewFrame({
  required Size imageSize,
  required Size screenSize,
  required Rect screenCaptureFrame,
}) {
  if (imageSize.width <= 0 ||
      imageSize.height <= 0 ||
      screenSize.width <= 0 ||
      screenSize.height <= 0 ||
      screenCaptureFrame.width <= 0 ||
      screenCaptureFrame.height <= 0) {
    return Offset.zero & imageSize;
  }

  final Rect visibleImage = computeCoverVisibleRect(imageSize, screenSize);
  final double nx = screenCaptureFrame.left / screenSize.width;
  final double ny = screenCaptureFrame.top / screenSize.height;
  final double nw = screenCaptureFrame.width / screenSize.width;
  final double nh = screenCaptureFrame.height / screenSize.height;

  final Rect cropRect = Rect.fromLTWH(
    visibleImage.left + nx * visibleImage.width,
    visibleImage.top + ny * visibleImage.height,
    nw * visibleImage.width,
    nh * visibleImage.height,
  );

  return _clampRectWithinBounds(cropRect, Offset.zero & imageSize);
}

/// 按视口取景框裁剪；[coverPreviewRect] 为 CamerAwesome cover 预览区域。
Future<File?> cropImageToViewportCaptureFrame(
  File source,
  Size viewportSize,
  Rect captureFrameInViewport, {
  Rect? coverPreviewRect,
  int? maxDecodeWidth = kCameraCropMaxDecodeWidth,
  FilterQuality filterQuality = FilterQuality.high,
  bool useImagePackagePipeline = false,
  int jpegQuality = kContinuousCaptureRefineJpegQuality,
}) async {
  final Rect coverRect = coverPreviewRect != null &&
          coverPreviewRect.width > 0 &&
          coverPreviewRect.height > 0
      ? coverPreviewRect
      : Offset.zero & viewportSize;

  final Rect visibleFrame = captureFrameInViewport.intersect(coverRect);
  if (visibleFrame.width <= 0 || visibleFrame.height <= 0) return source;

  final bytes = await source.readAsBytes();
  if (useImagePackagePipeline) {
    final cropped = await _cropImageBytesWithImagePackage(
      bytes: bytes,
      viewportSize: viewportSize,
      captureFrameInViewport: captureFrameInViewport,
      coverPreviewRect: coverPreviewRect,
      maxDecodeWidth: maxDecodeWidth,
      jpegQuality: jpegQuality,
    );
    return cropped ?? source;
  }

  final Rect frameInCover = Rect.fromLTWH(
    visibleFrame.left - coverRect.left,
    visibleFrame.top - coverRect.top,
    visibleFrame.width,
    visibleFrame.height,
  );

  final image =
      await _decodeImageFromBytes(bytes, maxDecodeWidth: maxDecodeWidth);
  final imageSize = Size(image.width.toDouble(), image.height.toDouble());
  final cropRect = computeImageCropRectForCoverPreviewFrame(
    imageSize: imageSize,
    screenSize: coverRect.size,
    screenCaptureFrame: frameInCover,
  );

  final cropW = cropRect.width.round();
  final cropH = cropRect.height.round();
  if (cropW <= 0 || cropH <= 0) {
    image.dispose();
    return source;
  }

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    image,
    cropRect,
    Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
    Paint()..filterQuality = filterQuality,
  );
  final picture = recorder.endRecording();
  final croppedImage = await picture.toImage(cropW, cropH);
  image.dispose();
  return _encodeCroppedImage(croppedImage);
}

/// 按屏幕取景框裁剪成片，需与 cover 预览及遮罩框算法保持一致。
Future<File?> cropImageToScreenAspectFrame(
  File source,
  Size screenSize, {
  required double widthOverHeight,
  CaptureFrameFit fit = CaptureFrameFit.fitInside,
  int? maxDecodeWidth = kCameraCropMaxDecodeWidth,
}) async {
  if (widthOverHeight <= 0) return source;

  final bytes = await source.readAsBytes();
  final image = await _decodeImageFromBytes(bytes, maxDecodeWidth: maxDecodeWidth);
  final imageSize = Size(image.width.toDouble(), image.height.toDouble());
  final Rect screenCaptureFrame = computeCaptureFrameRect(
    screenSize,
    widthOverHeight: widthOverHeight,
    fit: fit,
  );
  final cropRect = computeImageCropRectForCoverPreviewFrame(
    imageSize: imageSize,
    screenSize: screenSize,
    screenCaptureFrame: screenCaptureFrame,
  );

  final cropW = cropRect.width.round();
  final cropH = cropRect.height.round();
  if (cropW <= 0 || cropH <= 0) return source;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    image,
    cropRect,
    Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
    Paint()..filterQuality = FilterQuality.high,
  );
  final picture = recorder.endRecording();
  final croppedImage = await picture.toImage(cropW, cropH);
  image.dispose();
  return _encodeCroppedImage(croppedImage);
}

/// 将图片按宽高比居中裁剪，[aspectRatio] 为宽/高（如 1.0 表示 1:1，16/9 表示 16:9）。
Future<File?> cropImageCenterToAspectRatio(
  File source,
  double aspectRatio, {
  int? maxDecodeWidth = kCameraCropMaxDecodeWidth,
}) async {
  if (aspectRatio <= 0) return source;

  final bytes = await source.readAsBytes();
  final image = await _decodeImageFromBytes(bytes, maxDecodeWidth: maxDecodeWidth);

  final cropRect = computeCenteredAspectFrameRect(
    Size(image.width.toDouble(), image.height.toDouble()),
    aspectRatio,
  );

  final cropW = cropRect.width.round();
  final cropH = cropRect.height.round();
  if (cropW <= 0 || cropH <= 0) return source;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    image,
    cropRect,
    Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
    Paint()..filterQuality = FilterQuality.high,
  );
  final picture = recorder.endRecording();
  final croppedImage = await picture.toImage(cropW, cropH);
  image.dispose();
  return _encodeCroppedImage(croppedImage);
}
