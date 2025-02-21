import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/sample.dart';

Future<ApiResponse<List<Sample>>> getSamples() async {
  return api.get("api/tenant/showroom/samples").then(
        (res) => ApiResponse<List<Sample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Sample.fromJson).toList();
          },
        ),
      );
}
