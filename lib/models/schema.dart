import 'package:freezed_annotation/freezed_annotation.dart';

part 'schema.freezed.dart';
part 'schema.g.dart';

@freezed
class SchemaOption with _$SchemaOption {
  const factory SchemaOption({
    required dynamic id,
    dynamic index,
    required String value,
    required String label,
  }) = _SchemaOption;

  factory SchemaOption.fromJson(Map<String, dynamic> json) =>
      _$SchemaOptionFromJson(json);
}

@freezed
class SchemaProps with _$SchemaProps {
  const factory SchemaProps({
    @Default(false) bool tableSearch,
    @Default(false) bool showSearch,
    List<SchemaOption>? options,
  }) = _SchemaProps;

  factory SchemaProps.fromJson(Map<String, dynamic> json) =>
      _$SchemaPropsFromJson(json);
}

@freezed
class Schema with _$Schema {
  const factory Schema({
    required int id,
    required int order,
    required String table,
    required String name,
    required String title,
    required String type,
    required String widget,
    @JsonKey(name: 'required', defaultValue: false) required bool isRequired,
    SchemaProps? props,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'new', defaultValue: false) required bool isNew,
    @Default(false) bool hidden,
    String? extra,
    String? description,
    String? tooltip,
    @JsonKey(name: 'hidden_in_table', defaultValue: false)
    required bool hiddenInTable,
    @JsonKey(name: 'is_external', defaultValue: false) required bool isExternal,
    int? cellSpan,
    bool? readOnly,
  }) = _Schema;

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
}
