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

Future<ApiResponse<List<Borrow>>> getBorrows() async {
  return api.get("api/tenant/wms/stock/borrows").then(
        (res) => ApiResponse<List<Borrow>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Borrow.fromJson).toList();
          },
        ),
      );
}
