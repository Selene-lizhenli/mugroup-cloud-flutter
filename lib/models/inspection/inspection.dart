import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

@freezed
class Inspection with _$Inspection {
  factory Inspection(
    int? id,
    String? name,
  ) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}
