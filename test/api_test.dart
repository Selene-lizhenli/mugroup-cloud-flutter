import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('api tests', () async {
    final sample =
        await api.get("/samples/1").then((res) => Sample.fromJson(res.data));

    print(sample);
  });
}
