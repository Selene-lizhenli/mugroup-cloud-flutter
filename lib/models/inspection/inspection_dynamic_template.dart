import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_dynamic_template.freezed.dart';
part 'inspection_dynamic_template.g.dart';

@freezed
class InspectionDynamicTemplate with _$InspectionDynamicTemplate {
  factory InspectionDynamicTemplate({
    int? id,
    String? name,
    @JsonKey(name: 'inspection_scope') String? inspectionScope,
  }) = _InspectionDynamicTemplate;

  factory InspectionDynamicTemplate.fromJson(Map<String, dynamic> json) =>
      _$InspectionDynamicTemplateFromJson(json);
}
