import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/models/supply/supplier.dart';

Future<ApiResponse<List<Quote>>> getSupplyQuotes(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/supply/quotes", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Quote>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Quote.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<Supplier>>> getSupplySuppliers(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/supply/suppliers", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Supplier>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Supplier.fromJson).toList();
          },
        ),
      );
}

Future<Supplier?> getSupplier(int id) async {
  return api.get("api/tenant/supply/suppliers/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Supplier.fromJson(res.data);
    },
  );
}
