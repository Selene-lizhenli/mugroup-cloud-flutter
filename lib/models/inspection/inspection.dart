import 'dart:convert';

import 'package:cloud/models/inspection/inspection_dynamic_template.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

@freezed
class Inspection with _$Inspection {
  factory Inspection(
    int? id,
    int? type,
    String? name,
    String? remark,
    String? notes,
    int? status,
    User? user,
    List<User>? collaborators,
    List<InspectionItem>? items,
    List<Media>? media,
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
    @JsonKey(name: 'inspection_dynamic_template')
    InspectionDynamicTemplate? inspectionDynamicTemplate,
    @JsonKey(name: 'created_at') String? createdAt,
  ) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
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
