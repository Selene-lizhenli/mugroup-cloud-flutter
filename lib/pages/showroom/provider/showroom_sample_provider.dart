import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart' as showroom_service;
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Showroom 样品接口包装：在 `services/sample.dart` 之上统一附加 `X-Tenant-ID`（来自路由 `x_tenant_id`）。
class ShowroomSampleApi {
  const ShowroomSampleApi();

  static Map<String, dynamic>? _headersFromXTenantId(String? xTenantId) {
    final trimmed = xTenantId?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return <String, dynamic>{'X-Tenant-ID': trimmed};
  }

  Future<Sample?> getSample(
    int id, {
    String? xTenantId,
  }) {
    return showroom_service.getSample(
      id,
      extraHeaders: _headersFromXTenantId(xTenantId),
    );
  }

  Future<ApiResponse<List<Sample>>> getSampleSimilars({
    required int id,
    Map<String, dynamic>? queryParameters,
    String? xTenantId,
  }) {
    return showroom_service.getSampleSimilars(
      id: id,
      queryParameters: queryParameters,
      extraHeaders: _headersFromXTenantId(xTenantId),
    );
  }
}

final showroomSampleApiProvider = Provider<ShowroomSampleApi>((ref) {
  return const ShowroomSampleApi();
});
