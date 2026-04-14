import 'dart:io';
import 'dart:typed_data';

import 'package:cloud/app/app.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalDownloadResult {
  final String path;
  const LocalDownloadResult(this.path);
}

Future<Directory> getBestDownloadDirectory() async {
  // iOS: getDownloadsDirectory() often resolves to a sandbox path where
  // creating "Downloads" fails with PathAccessException (EPERM). Documents is
  // always writable.
  if (Platform.isIOS) {
    return getApplicationDocumentsDirectory();
  }

  final downloads = await getDownloadsDirectory();
  if (downloads != null) return downloads;

  if (Platform.isAndroid) {
    final ext = await getExternalStorageDirectory();
    if (ext != null) return ext;
  }

  return getApplicationDocumentsDirectory();
}

String? _tryResolveAbsoluteUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final u = url.trim();
  if (u.startsWith('http://') || u.startsWith('https://')) return u;
  if (!u.startsWith('/')) return u;

  final core = app.container.read(coreProvider).value;
  final baseUrl = core?.currentTenant?.baseUrl;
  if (baseUrl == null || baseUrl.isEmpty) return u;

  return baseUrl.endsWith('/') ? '${baseUrl.substring(0, baseUrl.length - 1)}$u' : '$baseUrl$u';
}

Future<LocalDownloadResult> saveBytesToDownloads(
  Uint8List bytes, {
  required String filename,
  String? subDir,
}) async {
  final baseDir = await getBestDownloadDirectory();
  final dir = subDir == null ? baseDir : Directory(p.join(baseDir.path, subDir));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final file = File(p.join(dir.path, filename));
  await file.writeAsBytes(bytes, flush: true);
  return LocalDownloadResult(file.path);
}

Future<Uint8List> downloadUrlBytes(
  String url, {
  ProgressCallback? onReceiveProgress,
}) async {
  final resolved = _tryResolveAbsoluteUrl(url) ?? url;
  final resp = await api.get<List<int>>(
    resolved,
    options: Options(responseType: ResponseType.bytes),
    onReceiveProgress: onReceiveProgress,
  );
  final data = resp.data;
  if (data == null) {
    throw Exception('Empty response');
  }
  return Uint8List.fromList(data);
}

Future<Uint8List> downloadApiBytes(
  String path, {
  Map<String, dynamic>? queryParameters,
  ProgressCallback? onReceiveProgress,
}) async {
  final resp = await api.get<List<int>>(
    path,
    queryParameters: queryParameters,
    options: Options(responseType: ResponseType.bytes),
    onReceiveProgress: onReceiveProgress,
  );
  final data = resp.data;
  if (data == null) throw Exception('Empty response');
  return Uint8List.fromList(data);
}

