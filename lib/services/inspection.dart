import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud/http/api.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/inspection/inspection_import_template.dart';
import 'package:cloud/models/response.dart';
import 'package:dio/dio.dart';

Future<ApiResponse<List<Inspection>>> getInspections(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/inspection/tasks", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Inspection>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            final dfs = list.map(Inspection.fromJson).toList();
            return dfs;
          },
        ),
      );
}

Future<Inspection?> storeInspection(Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/tasks", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> showInspection(int id) async {
  return api.get("api/tenant/inspection/tasks/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

// 更新验货任务
Future<Inspection?> updateInspectionTask(
    int? id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/tasks/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Inspection.fromJson(res.data);
    },
  );
}

Future deleteInspection(int id) async {
  return api.delete("api/tenant/inspection/tasks/$id");
}

Future<Inspection?> addCollaborators(int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/inspection/tasks/$id/collaborators/add", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> removeCollaborators(
    int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/inspection/tasks/$id/collaborators/remove", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> addInspectionItems(
    int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/tasks/$id/items/add", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> importInspectionItems(int id, FormData formData) async {
  return api
      .post("api/tenant/inspection/tasks/$id/import", data: formData)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future deleteInspectionItem(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/tasks/$id/items/remove", data: data);
}

Options _inspectionBinaryExportOptions() => Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: const Duration(seconds: 60),
      headers: {Headers.acceptHeader: '*/*'},
      validateStatus: (status) => status != null && status < 500,
    );

bool _isHtmlResponseBytes(Uint8List bytes) {
  if (bytes.isEmpty) return false;
  final head = utf8
      .decode(
        bytes.length > 256 ? bytes.sublist(0, 256) : bytes,
        allowMalformed: true,
      )
      .trimLeft()
      .toLowerCase();
  return head.startsWith('<!doctype') ||
      head.startsWith('<html') ||
      head.startsWith('<!');
}

bool _looksLikeZipArchive(Uint8List bytes) {
  return bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;
}

bool _looksLikePdf(Uint8List bytes) {
  return bytes.length >= 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46;
}

String? _tryParseJsonMessage(String raw) {
  final s = raw.trim();
  if (!s.startsWith('{')) return null;
  try {
    final obj = jsonDecode(s);
    if (obj is Map) {
      final m = obj['message'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
    }
  } catch (_) {}
  return null;
}

String inspectionExportHttpErrorMessage(dynamic data, int? statusCode) {
  if (data is List<int> || data is Uint8List) {
    final bytes =
        data is Uint8List ? data : Uint8List.fromList(List<int>.from(data));
    if (_isHtmlResponseBytes(bytes)) {
      if (statusCode == 403) {
        return '无权限导出验货清单，请联系管理员开通权限';
      }
      return '导出失败${statusCode == null ? '' : ' ($statusCode)'}';
    }
    try {
      final raw = utf8.decode(bytes, allowMalformed: true).trim();
      return _tryParseJsonMessage(raw) ?? raw;
    } catch (_) {}
  }
  if (data is Map) {
    final m = data['message'];
    if (m is String && m.trim().isNotEmpty) return m.trim();
  }
  if (statusCode == 403) {
    return '无权限导出验货清单，请联系管理员开通权限';
  }
  return '导出失败${statusCode == null ? '' : ' ($statusCode)'}';
}

// 处理zip格式下载
Uint8List parseInspectionBinaryExportZipResponse(Response<dynamic> resp) {
  final statusCode = resp.statusCode;
  final data = resp.data;
  if (statusCode == null || statusCode < 200 || statusCode >= 300) {
    throw DioException(
      requestOptions: resp.requestOptions,
      response: resp,
      type: DioExceptionType.badResponse,
      message: inspectionExportHttpErrorMessage(data, statusCode),
    );
  }
  if (data == null) {
    throw Exception('Empty response');
  }
  final bytes = data is Uint8List
      ? data
      : Uint8List.fromList(List<int>.from(data as List));
  if (_isHtmlResponseBytes(bytes)) {
    throw Exception(inspectionExportHttpErrorMessage(bytes, statusCode));
  }
  if (!_looksLikeZipArchive(bytes)) {
    throw Exception('导出ZIP文件格式无效');
  }
  return bytes;
}

//处理pdf格式下载
Uint8List parseInspectionBinaryExportPDFResponse(Response<dynamic> resp) {
  final statusCode = resp.statusCode;
  final data = resp.data;
  if (statusCode == null || statusCode < 200 || statusCode >= 300) {
    throw DioException(
      requestOptions: resp.requestOptions,
      response: resp,
      type: DioExceptionType.badResponse,
      message: inspectionExportHttpErrorMessage(data, statusCode),
    );
  }
  if (data == null) {
    throw Exception('Empty response');
  }
  final bytes = data is Uint8List
      ? data
      : Uint8List.fromList(List<int>.from(data as List));
  if (_isHtmlResponseBytes(bytes)) {
    throw Exception(inspectionExportHttpErrorMessage(bytes, statusCode));
  }
  if (!_looksLikePdf(bytes)) {
    final jsonMsg =
        _tryParseJsonMessage(utf8.decode(bytes, allowMalformed: true));
    throw Exception(jsonMsg ?? '导出PDF文件格式无效');
  }
  return bytes;
}

Future<List<InspectionImportTemplate>> getInspectionImportTemplates() async {
  return api.get('api/tenant/inspection/tasks/templates').then((res) {
    final data = res.data;
    final List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      list = data['data'] as List;
    } else {
      return <InspectionImportTemplate>[];
    }

    return list
        .whereType<Map>()
        .map((item) => InspectionImportTemplate.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  });
}

Future<List<String>> getInspectionExportTemplateKeys() async {
  return api.get('api/tenant/inspection/tasks/templates').then((res) {
    final data = res.data;
    final List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      list = data['data'] as List;
    } else {
      return <String>[];
    }

    final keys = <String>[];
    for (final item in list) {
      if (item is! Map) continue;
      final key = (item['key'] ?? item['value'])?.toString().trim();
      if (key != null && key.isNotEmpty) {
        keys.add(key);
      }
    }
    return keys;
  });
}

Future<List<Map<String, dynamic>>> getInspectionTemplateKeys() async {
  return api.get('api/tenant/inspection/dynamic/templates?all=1').then((res) {
    final data = res.data;
    final List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      list = data['data'] as List;
    } else {
      return [];
    }

    final keys = <Map<String, dynamic>>[];
    for (final item in list) {
      if (item is! Map) continue;
      final id = item['id']?.toString().trim();
      final name = item['name']?.toString().trim();
      if (id != null && id.isNotEmpty) {
        keys.add({'id': id, 'name': name, "schema": item['schema_json']});
      }
    }
    return keys;
  });
}

Future<Uint8List> exportInspectionImage(int id, {bool? isWithFolder}) async {
  final type = isWithFolder == true ? '' : 'flat';
  final resp = await api.get<dynamic>(
    'api/tenant/inspection/tasks/$id/exportImages?type=$type',
    options: _inspectionBinaryExportOptions(),
  );
  return parseInspectionBinaryExportZipResponse(resp);
}

Future<Uint8List> exportInspectionImageWithSkus(int id, List<int> itemIds,
    {bool? isWithFolder}) async {
  final type = isWithFolder == true ? '' : 'flat';
  final queryParts = <String>[];
  if (type.isNotEmpty) queryParts.add('type=$type');
  for (final itemId in itemIds) {
    queryParts.add('item_ids[]=$itemId');
  }
  final queryString = queryParts.join('&');
  final resp = await api.get<dynamic>(
    'api/tenant/inspection/tasks/$id/exportImages?$queryString',
    options: _inspectionBinaryExportOptions(),
  );
  return parseInspectionBinaryExportZipResponse(resp);
}

// 导出多个验货报告 (自定义搭建 且 按照sku进行验货)
Future<Uint8List> exportBatchInspectionCustomReport(
    {required List itemIds}) async {
  final resp = await api.post<dynamic>(
    'api/tenant/inspection/items/dynamic-reports',
    data: {"item_ids": itemIds},
    options: _inspectionBinaryExportOptions(),
  );
  return parseInspectionBinaryExportZipResponse(resp);
}

// 导出单个验货报告(自定义搭建 且 按照sku进行验货)
// itemId: 单个验货sku的id
Future<Uint8List> exportSingleInspectionCustomReport(int itemId,
    {bool? isWithFolder}) async {
  final resp = await api.get<dynamic>(
    'api/tenant/inspection/items/$itemId/dynamic-report',
    options: _inspectionBinaryExportOptions(),
  );
  return parseInspectionBinaryExportPDFResponse(resp);
}

// 导出验货报告 (自定义搭建 且 按照一个任务进行验货)
Future<Uint8List> exporInspectionCustomReportByTask(
  int id,
) async {
  final resp = await api.get<dynamic>(
    'api/tenant/inspection/tasks/$id/dynamic-report',
    options: _inspectionBinaryExportOptions(),
  );
  return parseInspectionBinaryExportPDFResponse(resp);
}

Future<InspectionItem?> showInspectionItem(int id) async {
  return api.get("api/tenant/inspection/items/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return InspectionItem.fromJson(res.data);
    },
  );
}

// 这个是 一个sku一个验货报告 的情况下的提交验货媒体逻辑
Future<InspectionItem?> updateInspectionItem(
    int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/items/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return InspectionItem.fromJson(res.data);
    },
  );
}

// 这个是 一个合同一个验货报告 的情况下的提交验货媒体逻辑
Future<bool> submitInspectionTask(int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/inspection/tasks/$id/dynamic-record", data: data)
      .then(
    (res) {
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    },
  );
}
