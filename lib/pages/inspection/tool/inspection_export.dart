import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

String? _tryParseInspectionExportJsonMessage(String raw) {
  final s = raw.trim();
  if (s.isEmpty || !s.startsWith('{')) return null;
  try {
    final obj = jsonDecode(s);
    if (obj is Map) {
      final m = obj['message'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
    }
  } catch (_) {}
  return null;
}

String? _extractInspectionExportResponseMessage(
  DioException e, {
  required String action,
}) {
  final data = e.response?.data;
  if (data is Map) {
    final m = data['message'];
    if (m is String && m.trim().isNotEmpty) return m.trim();
  }
  if (data is String) {
    return _tryParseInspectionExportJsonMessage(data) ?? data.trim();
  }
  if (data is List<int> || data is Uint8List) {
    final bytes =
        data is Uint8List ? data : Uint8List.fromList(List<int>.from(data));
    if (bytes.isNotEmpty) {
      final head = utf8
          .decode(
            bytes.length > 256 ? bytes.sublist(0, 256) : bytes,
            allowMalformed: true,
          )
          .trimLeft()
          .toLowerCase();
      if (head.startsWith('<!') || head.startsWith('<html')) {
        if (e.response?.statusCode == 403) {
          return '无权限$action，请联系管理员开通权限';
        }
        return '$action失败';
      }
    }
    try {
      final raw = utf8.decode(bytes, allowMalformed: true).trim();
      final jsonMsg = _tryParseInspectionExportJsonMessage(raw);
      if (jsonMsg != null) return jsonMsg;
      if (raw.length > 80) return '$action失败';
      if (raw.isNotEmpty) return raw;
    } catch (_) {}
  }
  return null;
}

String inspectionExportErrorMessage(Object e, {required String action}) {
  if (e is DioException) {
    final msg = e.message?.trim();
    if (msg != null && msg.isNotEmpty && !msg.contains('<!DOCTYPE')) {
      return msg;
    }
    final status = e.response?.statusCode;
    final serverMsg =
        _extractInspectionExportResponseMessage(e, action: action);
    if (status == 403) {
      return serverMsg ?? '无权限$action，请联系管理员开通权限';
    }
    if (serverMsg != null && serverMsg.isNotEmpty) {
      return serverMsg;
    }
    return '$action失败';
  }
  if (e is Exception) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    if (msg.isNotEmpty && !msg.contains('<!DOCTYPE')) return msg;
  }
  return '$action失败';
}

Future<void> exportInspectionImagePackage(
  BuildContext context,
  int inspectionId,
  bool? isWithFolder, {
  VoidCallback? onDownloadComplete,
}) async {
  EasyLoading.show(status: '正在下载图片包...');

  try {
    final bytes =
        await exportInspectionImage(inspectionId, isWithFolder: isWithFolder);

    final directory = await getTemporaryDirectory();
    final fileName =
        '验货图片_${inspectionId}_${DateTime.now().millisecondsSinceEpoch}.zip';
    final filePath = '${directory.path}/$fileName';

    await File(filePath).writeAsBytes(bytes);

    EasyLoading.dismiss();
    onDownloadComplete?.call();

    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(
      [XFile(filePath)],
      text: '这是验货任务 $inspectionId 的图片压缩包',
      subject: fileName,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    EasyLoading.showError(
      inspectionExportErrorMessage(e, action: '下载图片包'),
    );
  }
}

Future<void> exportInspectionImagePackageWithSelectedSkus(
  BuildContext context,
  int inspectionId,
  List<int> itemIds, {
  bool? isWithFolder,
  VoidCallback? onDownloadComplete,
}) async {
  EasyLoading.show(status: '正在下载图片包...');

  try {
    final bytes = await exportInspectionImageWithSkus(
      inspectionId,
      itemIds,
      isWithFolder: isWithFolder,
    );

    final directory = await getTemporaryDirectory();
    final fileName =
        '验货图片_${inspectionId}_${DateTime.now().millisecondsSinceEpoch}.zip';
    final filePath = '${directory.path}/$fileName';

    await File(filePath).writeAsBytes(bytes);

    EasyLoading.dismiss();
    onDownloadComplete?.call();

    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(
      [XFile(filePath)],
      text: '这是验货任务 $inspectionId 的图片压缩包',
      subject: fileName,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    EasyLoading.showError(
      inspectionExportErrorMessage(e, action: '下载图片包'),
    );
  }
}

Future<void> exportInspectionCustomReport(
  BuildContext context,
  int inspectionId,
  List selectedSku, {
  bool reportPerSku = false,
  VoidCallback? onDownloadComplete,
}) async {
  EasyLoading.show(status: '正在下载验货报告...');
  try {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (reportPerSku && selectedSku.length > 1) {
      final files = <XFile>[];
      for (var i = 0; i < selectedSku.length; i++) {
        final itemId = selectedSku[i];
        EasyLoading.show(
          status: '正在下载验货报告 (${i + 1}/${selectedSku.length})...',
        );
        final bytes = await exportSingleInspectionCustomReport(itemId);
        final fileName = '验货报告${inspectionId}_${itemId}_$timestamp.pdf';
        final filePath = '${directory.path}/$fileName';
        await File(filePath).writeAsBytes(bytes);
        files.add(XFile(filePath));
      }
      EasyLoading.dismiss();
      onDownloadComplete?.call();
      if (!context.mounted) return;
      final box = context.findRenderObject() as RenderBox?;

      await Share.shareXFiles(
        files,
        text: '这是您导出的验货报告',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      return;
    }

    final Uint8List bytes;
    if (selectedSku.length == 1) {
      bytes = await exportSingleInspectionCustomReport(selectedSku.first);
    } else {
      bytes = await exportBatchInspectionCustomReport(itemIds: selectedSku);
    }
    final fileName =
        '验货报告${inspectionId}_(${selectedSku.first}-${selectedSku.last})_$timestamp.${selectedSku.length == 1 ? 'pdf' : 'zip'}';

    final filePath = '${directory.path}/$fileName';

    await File(filePath).writeAsBytes(bytes);
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(
      [XFile(filePath)],
      text: '这是您导出的验货报告',
      subject: fileName,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    EasyLoading.showError(
      inspectionExportErrorMessage(e, action: '下载验货报告'),
    );
  }
}

Future<void> exportInspectionCustomReportByTask(
  BuildContext context,
  int inspectionId, {
  VoidCallback? onDownloadComplete,
}) async {
  EasyLoading.show(status: '正在下载验货报告...');
  try {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final Uint8List bytes;

    bytes = await exporInspectionCustomReportByTask(inspectionId);

    final fileName = '验货报告_${inspectionId}_($timestamp).pdf';

    final filePath = '${directory.path}/$fileName';

    await File(filePath).writeAsBytes(bytes);
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(
      [XFile(filePath)],
      text: '这是您导出的验货报告',
      subject: fileName,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  } catch (e) {
    EasyLoading.dismiss();
    onDownloadComplete?.call();
    EasyLoading.showError(
      inspectionExportErrorMessage(e, action: '下载验货报告'),
    );
  }
}
