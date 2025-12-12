import 'package:cloud/http/api.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/models/response.dart';

Future<ApiResponse<List<Company>>> getCompanies(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/crm/companies", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Company>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Company.fromJson).toList();
          },
        ),
      );
}

Future<Company?> storeCrmCompany(Map<String, dynamic>? data) async {
  return api.post("api/tenant/crm/companies", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Company.fromJson(res.data);
    },
  );
}

Future<Company?> showCrmCompany(int id) async {
  return api.post("api/tenant/crm/companies/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Company.fromJson(res.data);
    },
  );
}

Future<Company?> updateCrmCompany(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/crm/companies/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Company.fromJson(res.data);
    },
  );
}

Future<ApiResponse<List<Contact>>> getContacts(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/crm/contacts", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Contact>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Contact.fromJson).toList();
          },
        ),
      );
}
