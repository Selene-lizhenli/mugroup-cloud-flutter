import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/delivery.dart';
import 'package:cloud/models/wms/delivery_item.dart';
import 'package:cloud/models/wms/inventory.dart';
import 'package:cloud/models/wms/transfer_item.dart';

Future<ApiResponse<List<Warehouse>>> getWarehouses() async {
  return api.get("api/tenant/wms/warehouses").then(
        (res) => ApiResponse<List<Warehouse>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Warehouse.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<Borrow>>> getBorrows(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/wms/stock/borrows", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Borrow>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Borrow.fromJson).toList();
          },
        ),
      );
}

Future<Borrow> storeBorrow(Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/wms/stock/borrows", data: data)
      .then((res) => Borrow.fromJson(res.data));
}

Future borrowIn(int borrowId, Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/borrows/$borrowId/borrow_in",
      data: data);
}

Future<Transfer?> fetchTransferByOrederNo(
  String orderNo,
) async {
  return api
      .get(
    "api/tenant/wms/stock/transfers/order_no/$orderNo",
  )
      .then((res) {
    if (res.data == null) {
      return null;
    }
    return Transfer.fromJson(res.data);
  });
}

Future<ApiResponse<List<TransferItem>>> getTransferItems(
    {required int id, Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/wms/stock/transfers/$id/items",
          queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<TransferItem>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(TransferItem.fromJson).toList();
          },
        ),
      );
}

Future addTransferItems(int transferId, Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/transfers/$transferId/add_items",
      data: data);
}

Future transferIn(int transferId, Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/transfers/$transferId/transfer_in",
      data: data);
}

Future transferInAll(int transferId) async {
  return api.post("api/tenant/wms/stock/transfers/$transferId/transfer_in_all");
}

Future transferOut(int transferId) async {
  return api.post("api/tenant/wms/stock/transfers/$transferId/transfer_out");
}

Future<Inventory> previewInventory(Map<String, dynamic>? data) async {
  final response = await api
      .post("api/tenant/wms/stock/inventories/inout/preview", data: data);
  return Inventory.fromJson(response.data);
}

Future confirmInventory(Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/inventories/inout/confirm", data: data);
}

Future confirmTransferIn(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/transfers/$id/confirm", data: data);
}

Future addDeliveryItems(int deliveryId, Map<String, dynamic>? data) async {
  return api.post("api/tenant/wms/stock/deliveries/$deliveryId/add_items",
      data: data);
}

Future fetchDelivery(Map<String, dynamic>? data) async {
  return api.get('api/tenant/wms/stock/deliveries', data: data).then((res) {
    final list = res.data['data'];
    if (list is List && list.isNotEmpty) {
      return Delivery.fromJson(list[0]);
    }
    return null;
  });
}

Future<ApiResponse<List<DeliveryItem>>> getDeliveryItems(
    {required int id, Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/wms/stock/deliveries/$id/items",
          queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<DeliveryItem>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(DeliveryItem.fromJson).toList();
          },
        ),
      );
}

Future deliveryOut(int deliveryId) async {
  return api.post("api/tenant/wms/stock/deliveries/$deliveryId/confirm");
}
