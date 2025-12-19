import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_config.freezed.dart';
part 'field_config.g.dart';

@freezed
class FieldConfig with _$FieldConfig {
  const factory FieldConfig({
    required String label,
    required String name,
    @Default(true) bool isVisible,
  }) = _FieldConfig;

  factory FieldConfig.fromJson(Map<String, dynamic> json) =>
      _$FieldConfigFromJson(json);
}
