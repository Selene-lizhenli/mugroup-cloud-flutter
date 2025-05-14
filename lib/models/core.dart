import 'package:freezed_annotation/freezed_annotation.dart';

part 'core.freezed.dart';
part 'core.g.dart';

@freezed
abstract class Tenant with _$Tenant {
  factory Tenant({
    int? id,
    String? title,
    @JsonKey(name: 'base_url') String? baseUrl,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
