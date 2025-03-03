import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/wms.dart';

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
