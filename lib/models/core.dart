import 'package:freezed_annotation/freezed_annotation.dart';

part 'core.freezed.dart';
part 'core.g.dart';

@freezed
abstract class TenantWxwork with _$TenantWxwork {
  factory TenantWxwork({
    @JsonKey(name: 'agent_id') String? agentId,
    @JsonKey(name: 'corp_id') String? corpId,
    String? schema,
  }) = _TenantWxwork;

  factory TenantWxwork.fromJson(Map<String, dynamic> json) =>
      _$TenantWxworkFromJson(json);
}

@freezed
abstract class Tenant with _$Tenant {
  factory Tenant({
    int? id,
    String? title,
    @JsonKey(name: 'login_ways') List<String>? loginWays,
    @JsonKey(name: 'base_url') String? baseUrl,
    TenantWxwork? wxwork,
    @JsonKey(name: 'app_features') List<String?>? appFeatures, 
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
