 
import 'package:freezed_annotation/freezed_annotation.dart';
 
part 'export_template.freezed.dart';
part 'export_template.g.dart';

@freezed
class ExportTemplate with _$ExportTemplate {
  factory ExportTemplate({
    int? id,
    String? key,
    String? label, 
  }) = _ExportTemplate;

  factory ExportTemplate.fromJson(Map<String, dynamic> json) =>
      _$ExportTemplateFromJson(json);
}

