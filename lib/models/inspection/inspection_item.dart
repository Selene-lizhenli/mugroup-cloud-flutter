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
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'sample_id') String? sampleId,
    @JsonKey(name: 'item_no') String? itemNo,
    @JsonKey(name: 'unit_per_ctn') String? unitPerCtn,
    @JsonKey(name: 'created_at') String? createdAt,
  ) = _InspectionItem;

  factory InspectionItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemFromJson(json);
}
