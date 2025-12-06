import 'package:cloud/http/api.dart';
import 'package:cloud/models/log.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/supply/cert.dart';
import 'package:cloud/models/supply/contact.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/models/supply/supplier_cert.dart';
import 'package:cloud/models/supply/supplier_type.dart';

Future<ApiResponse<List<Quote>>> getSupplyQuotes(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/supply/quotes", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Quote>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Quote.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<Supplier>>> getSupplySuppliers(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/supply/suppliers", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Supplier>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Supplier.fromJson).toList();
          },
        ),
      );
}

Future<Supplier?> getSupplier(int id) async {
  return api.get("api/tenant/supply/suppliers/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Supplier.fromJson(res.data);
    },
  );
}

Future<Supplier?> storeSupplySupplier(Map<String, dynamic>? data) async {
  return api.post("api/tenant/supply/suppliers", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Supplier.fromJson(res.data);
    },
  );
}

Future<Supplier?> updateSupplySupplier(
    int id, Map<String, dynamic>? data) async {
  return api.put("api/tenant/supply/suppliers/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Supplier.fromJson(res.data);
    },
  );
}

Future<List<SupplierType>?> getAllSupplySupplierTypes() async {
  final res = await api.get(
    "api/tenant/supply/supplier/types",
    queryParameters: {'all': '0'},
  );

  if (res.data is List) {
    return (res.data as List)
        .map((e) => SupplierType.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return null;
}

Future<ApiResponse<List<Contact>>?> getSupplySupplierContacts(int id) async {
  return api
      .get(
        "api/tenant/supply/suppliers/$id/contacts",
      )
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

Future<Contact?> getSupplySupplierContact(int id) async {
  return api.get("api/tenant/supply/contacts/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Contact.fromJson(res.data);
    },
  );
}

Future<Contact?> updateSupplySupplierContact(
    int id, Map<String, dynamic>? data) async {
  return api.put("api/tenant/supply/contacts/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Contact.fromJson(res.data);
    },
  );
}

Future<Contact?> storeSupplySupplierContact(Map<String, dynamic>? data) async {
  return api.post("api/tenant/supply/contacts", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Contact.fromJson(res.data);
    },
  );
}

Future<List<SupplierCert>?> getSupplySupplierCertsById(int id) async {
  final res = await api.get("api/tenant/supply/supplier/$id/certs");

  if (res.data is List) {
    return (res.data as List)
        .map((e) => SupplierCert.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return null;
}

Future<ApiResponse<List<Cert>>?> getSupplySupplierCerts() async {
  return api
      .get(
        "api/tenant/supply/certs",
      )
      .then(
        (res) => ApiResponse<List<Cert>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Cert.fromJson).toList();
          },
        ),
      );
}

Future<Cert?> storeSupplySupplierCert(Map<String, dynamic>? data) async {
  return api.post("api/tenant/supply/certs", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Cert.fromJson(res.data);
    },
  );
}

Future<List<Log>?> getSupplySupplierActivitiesById(int id) async {
  final res = await api.get("api/tenant/supply/suppliers/$id/activities");

  if (res.data is List) {
    return (res.data as List)
        .map((e) => Log.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return null;
}

Future<Log?> storeSupplySupplierActivity(
    int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/supply/suppliers/$id/activities", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Log.fromJson(res.data);
    },
  );
}
