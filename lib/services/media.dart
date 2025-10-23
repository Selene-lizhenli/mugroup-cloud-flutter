import 'dart:io';

import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

Future<TemporaryMedia> upload(
    {required File file}) async {

  final fileName = basename(file.path);
  final formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      file.path,
      filename: fileName,
    ),
  });

  return api
      .post("api/upload", data: formData)
      .then((res) => TemporaryMedia.fromJson(res.data));
}
