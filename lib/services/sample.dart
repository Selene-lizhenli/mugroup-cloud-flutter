import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/sample.dart';

Future<ApiResponse<List<Sample>>> getSamples(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/showroom/samples", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Sample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Sample.fromJson).toList();
          },
        ),
      );
}

Future<Sample?> getSampleByBarcode(String barcode) async {
  return api.get("api/tenant/showroom/samples/barcode/$barcode").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Sample.fromJson(res.data);
    },
  );
}
