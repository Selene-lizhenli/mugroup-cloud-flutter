import 'dart:convert';
import 'package:cloud/models/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_item.freezed.dart';
part 'inspection_item.g.dart';

@freezed
class InspectionItem with _$InspectionItem {
  factory InspectionItem(
    int? id,
    int? type,
    String? name,
    int? status,
    int? ctns,
    int? qty,
    String? remark,
    String? barcode,
    @JsonKey(name: 'std_barcode') String? stdBarcode,
    @JsonKey(name: 'scan_barcode') String? scanBarcode,
    String? description,
    List<Media>? media,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'sample_id') int? sampleId,
    @JsonKey(name: 'item_no') String? itemNo,
    @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(
      name: 'inspection_dynamic_template_id',
      fromJson: _inspectionDynamicTemplateIdFromJson,
      toJson: _inspectionDynamicTemplateIdToJson,
    )
    int? inspectionDynamicTemplateId,
    @JsonKey(
      name: 'inspection_dynamic_template_json',
      fromJson: _inspectionDynamicTemplateJsonFromJson,
      toJson: _inspectionDynamicTemplateJsonToJson,
    )
    Map<String, dynamic>? inspectionDynamicTemplateJson,
    @JsonKey(
      fromJson: _rawMapFromJson,
      toJson: _rawMapToJson,
    )
    Map<String, dynamic>? raw,
  ) = _InspectionItem;

  factory InspectionItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemFromJson(json);
}

int? _inspectionDynamicTemplateIdFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value.trim());
  return int.tryParse(value.toString());
}

int? _inspectionDynamicTemplateIdToJson(int? value) => value;

Map<String, dynamic>? _inspectionDynamicTemplateJsonFromJson(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }
  return null;
}

Map<String, dynamic>? _inspectionDynamicTemplateJsonToJson(
  Map<String, dynamic>? value,
) =>
    value;

Map<String, dynamic>? _rawMapFromJson(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }
  return null;
}

Map<String, dynamic>? _rawMapToJson(Map<String, dynamic>? value) => value;
