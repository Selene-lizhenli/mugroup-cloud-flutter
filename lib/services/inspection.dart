import 'package:cloud/http/api.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/models/response.dart';

Future<ApiResponse<List<Inspection>>> getInspections(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/inspection/tasks", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Inspection>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Inspection.fromJson).toList();
          },
        ),
      );
}

Future<Inspection?> storeInspection(Map<String, dynamic>? data) async {
  return api.post("api/tenant/inspection/tasks", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> showInspection(int id) async {
  return api.get("api/tenant/inspection/tasks/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> addCollaborators(int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/inspection/tasks/$id/collaborators/add", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}

Future<Inspection?> removeCollaborators(
    int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/inspection/tasks/$id/collaborators/remove", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Inspection.fromJson(res.data);
    },
  );
}
