import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// 与 camera_capture.dart 精修质量一致。
const int kContinuousCaptureRefineJpegQuality = 100;

/// Isolate 裁剪结果。
class CroppedImageBytes {
  final Uint8List bytes;
  final String extension;

  const CroppedImageBytes({
    required this.bytes,
    required this.extension,
  });
}

class _Size {
  final double width;
  final double height;

  const _Size(this.width, this.height);
}

class _Rect {
  final double left;
  final double top;
  final double width;
  final double height;

  const _Rect(this.left, this.top, this.width, this.height);

  double get right => left + width;
  double get bottom => top + height;

  _Size get size => _Size(width, height);

  _Rect intersect(_Rect other) {
    final double rLeft = left > other.left ? left : other.left;
    final double rTop = top > other.top ? top : other.top;
    final double rRight = right < other.right ? right : other.right;
    final double rBottom = bottom < other.bottom ? bottom : other.bottom;
    if (rRight <= rLeft || rBottom <= rTop) {
      return const _Rect(0, 0, 0, 0);
    }
    return _Rect(rLeft, rTop, rRight - rLeft, rBottom - rTop);
  }
}

_Rect _fromLTWH(double left, double top, double width, double height) {
  return _Rect(left, top, width, height);
}

_Rect _clampRectWithinBounds(_Rect rect, _Rect bounds) {
  final double left = rect.left.clamp(bounds.left, bounds.right);
  final double top = rect.top.clamp(bounds.top, bounds.bottom);
  final double right = rect.right.clamp(bounds.left, bounds.right);
  final double bottom = rect.bottom.clamp(bounds.top, bounds.bottom);
  if (right <= left || bottom <= top) {
    return bounds;
  }
  return _Rect(left, top, right - left, bottom - top);
}

_Rect _computeCoverVisibleRect(_Size contentSize, _Size viewportSize) {
  if (contentSize.width <= 0 ||
      contentSize.height <= 0 ||
      viewportSize.width <= 0 ||
      viewportSize.height <= 0) {
    return _fromLTWH(0, 0, contentSize.width, contentSize.height);
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

  return _fromLTWH(visibleX, visibleY, visibleW, visibleH);
}

_Rect _computeImageCropRectForCoverPreviewFrame({
  required _Size imageSize,
  required _Size screenSize,
  required _Rect screenCaptureFrame,
}) {
  if (imageSize.width <= 0 ||
      imageSize.height <= 0 ||
      screenSize.width <= 0 ||
      screenSize.height <= 0 ||
      screenCaptureFrame.width <= 0 ||
      screenCaptureFrame.height <= 0) {
    return _fromLTWH(0, 0, imageSize.width, imageSize.height);
  }

  final _Rect visibleImage =
      _computeCoverVisibleRect(imageSize, screenSize);
  final double nx = screenCaptureFrame.left / screenSize.width;
  final double ny = screenCaptureFrame.top / screenSize.height;
  final double nw = screenCaptureFrame.width / screenSize.width;
  final double nh = screenCaptureFrame.height / screenSize.height;

  final _Rect cropRect = _fromLTWH(
    visibleImage.left + nx * visibleImage.width,
    visibleImage.top + ny * visibleImage.height,
    nw * visibleImage.width,
    nh * visibleImage.height,
  );

  return _clampRectWithinBounds(
    cropRect,
    _fromLTWH(0, 0, imageSize.width, imageSize.height),
  );
}

/// Android CamerAwesome cover 预览裁剪参数。
class AndroidViewportCropParams {
  final String sourcePath;
  final double captureLeft;
  final double captureTop;
  final double captureWidth;
  final double captureHeight;
  final double coverLeft;
  final double coverTop;
  final double coverWidth;
  final double coverHeight;
  final int? maxDecodeWidth;
  final int jpegQuality;

  const AndroidViewportCropParams({
    required this.sourcePath,
    required this.captureLeft,
    required this.captureTop,
    required this.captureWidth,
    required this.captureHeight,
    required this.coverLeft,
    required this.coverTop,
    required this.coverWidth,
    required this.coverHeight,
    this.maxDecodeWidth,
    this.jpegQuality = kContinuousCaptureRefineJpegQuality,
  });
}

/// iOS wechat 预览裁剪参数。
class IosWechatCropParams {
  final String sourcePath;
  final double captureLeft;
  final double captureTop;
  final double captureWidth;
  final double captureHeight;
  final double previewLeft;
  final double previewTop;
  final double previewWidth;
  final double previewHeight;
  final int? maxDecodeWidth;
  final int jpegQuality;

  /// 解码后若仍为横图，旋转到竖屏（与主线程 [orientIosCameraImageToPortrait] 一致）。
  final bool rotateIfLandscape;

  /// 前置摄像头横图旋转方向与后置相反。
  final bool isFrontCamera;

  const IosWechatCropParams({
    required this.sourcePath,
    required this.captureLeft,
    required this.captureTop,
    required this.captureWidth,
    required this.captureHeight,
    required this.previewLeft,
    required this.previewTop,
    required this.previewWidth,
    required this.previewHeight,
    this.maxDecodeWidth,
    this.jpegQuality = kContinuousCaptureRefineJpegQuality,
    this.rotateIfLandscape = false,
    this.isFrontCamera = false,
  });
}

img.Image? _decodeOrientedImageBytes(
  Uint8List bytes, {
  int? maxDecodeWidth,
}) {
  // JPEG 优先走专用解码，比通用 decodeImage 更快。
  final img.Image? decoded =
      img.decodeJpg(bytes) ?? img.decodeImage(bytes);
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

CroppedImageBytes? _encodeJpegCrop(
  img.Image decoded,
  _Rect cropRect,
  int quality,
) {
  final int cropX = cropRect.left.round().clamp(0, decoded.width - 1);
  final int cropY = cropRect.top.round().clamp(0, decoded.height - 1);
  final int cropW = cropRect.width.round().clamp(1, decoded.width - cropX);
  final int cropH = cropRect.height.round().clamp(1, decoded.height - cropY);

  final img.Image cropped =
      img.copyCrop(decoded, x: cropX, y: cropY, width: cropW, height: cropH);
  // chroma 子采样默认 4:2:0，比全采样编码快且肉眼几乎无损。
  return CroppedImageBytes(
    bytes: Uint8List.fromList(
      img.encodeJpg(cropped, quality: quality),
    ),
    extension: 'jpg',
  );
}

_Rect _mapWechatIosFrameToImageRect({
  required double imageWidth,
  required double imageHeight,
  required double previewLeft,
  required double previewTop,
  required double previewWidth,
  required double previewHeight,
  required double captureLeft,
  required double captureTop,
  required double captureWidth,
  required double captureHeight,
}) {
  final _Rect previewRect =
      _fromLTWH(previewLeft, previewTop, previewWidth, previewHeight);
  final _Rect captureFrame =
      _fromLTWH(captureLeft, captureTop, captureWidth, captureHeight);
  final _Rect visibleFrame = captureFrame.intersect(previewRect);
  if (visibleFrame.width <= 0 || visibleFrame.height <= 0) {
    return _fromLTWH(0, 0, imageWidth, imageHeight);
  }

  final double nx = (visibleFrame.left - previewRect.left) / previewRect.width;
  final double ny = (visibleFrame.top - previewRect.top) / previewRect.height;
  final double nw = visibleFrame.width / previewRect.width;
  final double nh = visibleFrame.height / previewRect.height;
  final double previewAspect = previewRect.width / previewRect.height;
  final double imageAspect = imageWidth / imageHeight;

  if ((previewAspect - imageAspect).abs() < 0.02) {
    return _fromLTWH(
      nx * imageWidth,
      ny * imageHeight,
      nw * imageWidth,
      nh * imageHeight,
    );
  }

  final _Rect visibleImage = _computeCoverVisibleRect(
    _Size(imageWidth, imageHeight),
    previewRect.size,
  );
  return _fromLTWH(
    visibleImage.left + nx * visibleImage.width,
    visibleImage.top + ny * visibleImage.height,
    nw * visibleImage.width,
    nh * visibleImage.height,
  );
}

/// Android 连拍裁剪（在 isolate 中执行）。
CroppedImageBytes? androidViewportCropIsolate(AndroidViewportCropParams params) {
  try {
    final file = File(params.sourcePath);
    if (!file.existsSync()) return null;

    final img.Image? decoded = _decodeOrientedImageBytes(
      file.readAsBytesSync(),
      maxDecodeWidth: params.maxDecodeWidth,
    );
    if (decoded == null) return null;

    final _Rect coverRect = _fromLTWH(
      params.coverLeft,
      params.coverTop,
      params.coverWidth,
      params.coverHeight,
    );
    final _Rect captureFrame = _fromLTWH(
      params.captureLeft,
      params.captureTop,
      params.captureWidth,
      params.captureHeight,
    );
    final _Rect visibleFrame = captureFrame.intersect(coverRect);
    if (visibleFrame.width <= 0 || visibleFrame.height <= 0) {
      return null;
    }

    final _Rect frameInCover = _fromLTWH(
      visibleFrame.left - coverRect.left,
      visibleFrame.top - coverRect.top,
      visibleFrame.width,
      visibleFrame.height,
    );
    final _Rect cropRect = _computeImageCropRectForCoverPreviewFrame(
      imageSize: _Size(decoded.width.toDouble(), decoded.height.toDouble()),
      screenSize: coverRect.size,
      screenCaptureFrame: frameInCover,
    );

    return _encodeJpegCrop(decoded, cropRect, params.jpegQuality);
  } catch (_) {
    return null;
  }
}

/// iOS wechat 连拍裁剪（在 isolate 中执行）。
CroppedImageBytes? iosWechatCropIsolate(IosWechatCropParams params) {
  try {
    final file = File(params.sourcePath);
    if (!file.existsSync()) return null;

    img.Image? decoded = _decodeOrientedImageBytes(
      file.readAsBytesSync(),
      maxDecodeWidth: params.maxDecodeWidth,
    );
    if (decoded == null) return null;

    // 部分机型 JPEG 无 EXIF 方向，解码后仍是横图，需手动转到竖屏再裁。
    if (params.rotateIfLandscape && decoded.width > decoded.height) {
      decoded = img.copyRotate(
        decoded,
        angle: params.isFrontCamera ? -90 : 90,
      );
    }

    if (params.previewWidth <= 0 ||
        params.previewHeight <= 0 ||
        params.captureWidth <= 0 ||
        params.captureHeight <= 0) {
      return null;
    }

    final _Rect cropRect = _clampRectWithinBounds(
      _mapWechatIosFrameToImageRect(
        imageWidth: decoded.width.toDouble(),
        imageHeight: decoded.height.toDouble(),
        previewLeft: params.previewLeft,
        previewTop: params.previewTop,
        previewWidth: params.previewWidth,
        previewHeight: params.previewHeight,
        captureLeft: params.captureLeft,
        captureTop: params.captureTop,
        captureWidth: params.captureWidth,
        captureHeight: params.captureHeight,
      ),
      _fromLTWH(0, 0, decoded.width.toDouble(), decoded.height.toDouble()),
    );

    return _encodeJpegCrop(decoded, cropRect, params.jpegQuality);
  } catch (_) {
    return null;
  }
}
