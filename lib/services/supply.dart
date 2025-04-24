import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/supply/quote.dart';

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
