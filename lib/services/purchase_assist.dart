 
 
import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart'; 

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

// GET api/tenant/product-comparison/task-detail/:id
// 比价助手 - 任务详情（批量图搜结果列表）
// 返回：list，每项结构见 PurchaseAssistTaskDetailItem
Future<ApiResponse<List<PurchaseAssistTaskDetailItem>>>
    getProductComparisonTaskDetail(int taskId) async {
  return api.get('api/tenant/product-comparison/task-detail/$taskId').then(
        (res) => ApiResponse<List<PurchaseAssistTaskDetailItem>>.fromJson(
          res.data,
          (data) {
            final list = (data as List).cast<Map<String, dynamic>>();
            return list.map(PurchaseAssistTaskDetailItem.fromJson).toList();
          },
        ),
      );
}
