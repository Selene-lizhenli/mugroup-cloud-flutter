import 'package:cloud/models/core.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloud.freezed.dart';
part 'cloud.g.dart';

@freezed
abstract class Cloud with _$Cloud {
  const Cloud._();

  factory Cloud({
    int? currentTenantId,
    required List<Tenant> tenants,
    String? prePath,
  }) = _Cloud;

  factory Cloud.fromJson(Map<String, dynamic> json) => _$CloudFromJson(json);

  Tenant? get currentTenant {
    final selectId = currentTenantId ?? 6;
    return tenants.firstWhereOrNull((item) => item.id == selectId);
  }
}
