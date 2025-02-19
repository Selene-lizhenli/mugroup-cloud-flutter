import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sample detail', () async {
    final sample =
        await api.get("/samples/1").then((res) => Sample.fromJson(res.data));

    logger.d(sample);
  });

  test('sample list', () async {
    final resp = await api.get("/samples").then(
          (res) => ApiResponse<List<Sample>>.fromJson(
            res.data,
            (data) {
              var list = (data as List).cast<Map<String, dynamic>>();
              return list.map(Sample.fromJson).toList();
            },
          ),
        );

    logger.d(resp);
  });
}
