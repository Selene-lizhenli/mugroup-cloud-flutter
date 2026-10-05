import 'package:cloud/http/api.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/models/response.dart';

Future<ApiResponse<List<Company>>> getCrmCompanies(
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

Future<Company?> getCrmCompany(int id, {Map<String, dynamic>? data}) async {
  return api.get("api/tenant/crm/companies/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Company.fromJson(res.data);
    },
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

Future<ApiResponse<List<Contact>>> getCrmContacts(
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

Future<Contact?> getCrmContact(int id, {Map<String, dynamic>? data}) async {
  return api.get("api/tenant/crm/contacts/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return Contact.fromJson(res.data);
    },
  );
}

Future<Contact?> storeCrmContact(Map<String, dynamic>? data) async {
  return api.post("api/tenant/crm/contacts", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Contact.fromJson(res.data);
    },
  );
}

Future<Contact?> updateCrmContact(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/crm/contacts/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      } 
      return Contact.fromJson(res.data);
    },
  );
}
