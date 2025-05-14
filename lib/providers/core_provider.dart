import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/core.dart';
import 'package:cloud/models/cloud.dart';
import 'package:cloud/models/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_provider.g.dart';

@Riverpod(keepAlive: true)
class Core extends _$Core {
  Future<Cloud> _fetch() async {
    final resp = await coreApi.get("/api/core/tenants/apps");
    final list =
        (resp.data as List).map((e) => e as Map<String, dynamic>).toList();

    final tenants = list.map((e) => Tenant.fromJson(e)).toList();
    logger.d(tenants);

    return Cloud(tenants: tenants);
  }

  @override
  FutureOr<Cloud> build() async {
    // Load initial todo list from the remote repository
    return _fetch();
  }

  void setCurrentTenantId(int? currentTenant) {
    final current = state.value;
    if (current == null) return;

    final updated = current.copyWith(currentTenantId: currentTenant);

    state = AsyncData(updated);
  }
}
