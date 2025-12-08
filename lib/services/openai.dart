import 'package:cloud/http/api.dart';

Future identifySample(Map<String, dynamic>? data) async {
  return api.post("api/tenant/openai/identifySample", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Map<String, dynamic>.from(res.data);
    },
  );
}

Future identifyCompanyCard(Map<String, dynamic>? data) async {
  return api.post("api/tenant/openai/identifyCompanyCard", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Map<String, dynamic>.from(res.data);
    },
  );
}

Future identifySupplySuppliersCard(Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/openai/identifySupplySuppliersCard", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Map<String, dynamic>.from(res.data);
    },
  );
}
