import 'package:cloud/http/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('api tests', () async {
    final response = await api.get("/pet/1");
    print(response);
  });
}
