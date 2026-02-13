import 'package:cloud/http/api.dart';
import 'package:cloud/models/purchase_assist/meta.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/models/response.dart';

// POST api/tenant/multi-platform/search
// 比价助手 - 多平台搜索产品列表
// 入参：keywords, page, pageSize, platform
// 返回：list，每项结构见 PurchaseAssistSearchProduct
Future<List<PurchaseAssistSearchProduct>> getMultiPlatformSearch(
  Map<String, dynamic>? params,
) async {
  return api.post('api/tenant/multi-platform/search', data: params).then(
    (data) {
      final outerList = data.data as List;
      final list = outerList.cast<Map<String, dynamic>>();
      return list.map(PurchaseAssistSearchProduct.fromJson).toList();
    },
  );
}

// GET api/tenant/product-comparison/tasks?pageSize=20&page=1
// 比价助手 - 任务列表
// 返回：list，每项结构见 PurchaseAssistTaskListItem
Future<ApiResponse<List<PurchaseAssistTaskListItem>>> getProductComparisonTasks(
  Map<String, dynamic>? params,
) async {
  return api.get('api/tenant/product-comparison/tasks', data: params).then(
        (res) => ApiResponse<List<PurchaseAssistTaskListItem>>.fromJson(
          res.data,
          (data) {
            final list = (data as List).cast<Map<String, dynamic>>();
            return list.map(PurchaseAssistTaskListItem.fromJson).toList();
          },
        ),
      );
}

/// 任务详情返回结构
class TaskDetailResponse {
  const TaskDetailResponse({
    required this.data,
    this.meta,
  });

  final List<PurchaseAssistTaskDetailItem> data;
  final PurchaseAssistMeta? meta;
}

// GET api/tenant/product-comparison/tasks/:id/details?page=1&pageSize=10
// 比价助手 - 任务详情（批量图搜结果列表）
// 返回：data 为 list（每项 PurchaseAssistTaskDetailItem），meta 含 platform、pagination
Future<TaskDetailResponse> getProductComparisonTaskDetail(int taskId) async {
  final res = await api.get(
    'api/tenant/product-comparison/tasks/$taskId/details',
  );
  final body = res.data as Map<String, dynamic>;
  
  // 解析 data
  final dataList = (body['data'] as List)
      .cast<Map<String, dynamic>>()
      .map((e) => PurchaseAssistTaskDetailItem.fromJson(e))
      .toList();
  
  // 解析 meta
  PurchaseAssistMeta? meta;
  if (body['meta'] != null) {
    try {
      meta = PurchaseAssistMeta.fromJson(
        body['meta'] as Map<String, dynamic>,
      );
    } catch (_) {
      meta = null;
    }
  }
  
  return TaskDetailResponse(data: dataList, meta: meta);
}
