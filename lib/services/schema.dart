import 'package:cloud/http/api.dart';
import 'package:cloud/models/schema.dart';

Future<List<Schema>?> getSchema(String schemaName) async {
  return api.get("api/tenant/schemas/$schemaName").then(
    (res) {
      if (res.data == null) {
        return null;
      }

      final dynamic rawData = res.data;
      final List<dynamic> rawJsonList = rawData;

      final List<Schema> schemaList =
          rawJsonList.whereType<Map<String, dynamic>>().map((item) {
        return Schema.fromJson(item);
      }).toList();

      return schemaList;
    },
  );
}
