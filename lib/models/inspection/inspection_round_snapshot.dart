import 'package:cloud/models/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_round_snapshot.freezed.dart';
part 'inspection_round_snapshot.g.dart';

@freezed
class InspectionRoundSnapshot with _$InspectionRoundSnapshot {
  factory InspectionRoundSnapshot({
    int? round,
    int? status,
    String? remark,
    @JsonKey(name: 'media_snapshot') List<Media>? mediaSnapshot,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'inspector_name') String? inspectorName,
  }) = _InspectionRoundSnapshot;

  factory InspectionRoundSnapshot.fromJson(Map<String, dynamic> json) =>
      _$InspectionRoundSnapshotFromJson(json);
}
