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
    List<Media>? media,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'sample_id') int? sampleId,
    @JsonKey(name: 'item_no') String? itemNo,
    @JsonKey(name: 'unit_per_ctn') int? unitPerCtn,
    @JsonKey(name: 'created_at') String? createdAt,
  ) = _InspectionItem;

  factory InspectionItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemFromJson(json);
}
