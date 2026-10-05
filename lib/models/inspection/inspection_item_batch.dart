import 'dart:convert';

import 'package:cloud/models/inspection/inspection_round_snapshot.dart';
import 'package:cloud/models/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_item_batch.freezed.dart';
part 'inspection_item_batch.g.dart';

@freezed
class InspectionItemBatch with _$InspectionItemBatch {
  factory InspectionItemBatch({
    int? id,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'item_id') int? itemId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'batch_no') String? batchNo,
    int? status,
    int? ctns,
    @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
    int? qty,
    @JsonKey(
      fromJson: _rawMapFromJson,
      toJson: _rawMapToJson,
    )
    Map<String, dynamic>? raw,
    String? remark,
    @JsonKey(name: 'std_barcode') String? stdBarcode,
    @JsonKey(name: 'scan_barcode') String? scanBarcode,
    List<Media>? media,
    @JsonKey(name: 'rounds', fromJson: _roundsFromJson)
    List<InspectionRoundSnapshot>? rounds,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'duplicate_count') int? duplicateCount,
    @JsonKey(name: 'batch_no_sequence') int? batchNoSequence,
    @JsonKey(name: 'inspector_name') String? inspectorName,
    int? round,
  }) = _InspectionItemBatch;

  factory InspectionItemBatch.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemBatchFromJson(json);
}

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

List<InspectionRoundSnapshot>? _roundsFromJson(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value
        .map((e) => InspectionRoundSnapshot.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        return decoded
            .map((e) =>
                InspectionRoundSnapshot.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
  }
  return null;
}
