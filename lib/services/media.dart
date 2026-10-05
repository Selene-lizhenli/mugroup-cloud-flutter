import 'dart:io';
import 'dart:math';

import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';

Future<TemporaryMedia> upload({
  required File file,
  int maxRetries = 2,
  int quality = 80,
  int maxWidth = 1920,
}) async {
  File uploadFile = file;

  try {
    if (quality < 98) {
      final originalSize = await file.length();
      if (originalSize > 500 * 1024) {
        final compressed = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          '${file.absolute.path}_compressed.jpg',
          quality: quality,
          minWidth: maxWidth,
          format: CompressFormat.jpeg,
        );
        if (compressed != null) {
          final compressedSize = await compressed.length();
          if (compressedSize > 0 && compressedSize < originalSize) {
            uploadFile = File(compressed.path);
          }
        }
      }
    }
  } catch (_) {}

  final fileName = basename(file.path);

  int attempt = 0;
  while (true) {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          uploadFile.path,
          filename: fileName,
        ),
      });

      final res = await api.post(
        "api/upload",
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );
      return TemporaryMedia.fromJson(res.data);
    } catch (e) {
      attempt++;
      if (attempt > maxRetries) rethrow;
      final delay = Duration(milliseconds: 500 * pow(2, attempt - 1).toInt());
      await Future.delayed(delay);
    }
  }
}

Future deleteMedia(int id, Map<String, dynamic>? data) async {
  return api.delete("api/tenant/files/medias/$id", data: data);
}
