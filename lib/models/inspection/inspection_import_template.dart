import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_import_template.freezed.dart';
part 'inspection_import_template.g.dart';

@freezed
class InspectionImportTemplate with _$InspectionImportTemplate {
  const factory InspectionImportTemplate({ 
    String? label,
    String? value,
  }) = _InspectionImportTemplate;

  factory InspectionImportTemplate.fromJson(Map<String, dynamic> json) =>
      _$InspectionImportTemplateFromJson(json);
}
