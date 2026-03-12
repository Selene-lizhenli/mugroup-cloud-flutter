import 'package:cloud/models/inspection/inspection_item.dart';
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
    User? user,
    List<User>? collaborators,
    List<InspectionItem>? items,
    @JsonKey(name: 'created_at') String? createdAt,
  ) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}
