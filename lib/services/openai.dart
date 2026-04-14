import 'package:cloud/http/api.dart';
import 'package:cloud/models/company_card_data.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:dio/dio.dart';

Future translate(Map<String, dynamic>? data) async {
  return api.post("api/tenant/openai/translate", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return res.data;
    },
  );
}

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

Future<CompanyCardData?> identifyCompanyCard(Map<String, dynamic>? data) async {
  return api.post("api/tenant/openai/identifyCompanyCard", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return CompanyCardData.fromJson(res.data);
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

Future identifySupplierShopCard(Map<String, dynamic>? data) async {
  return api.post("api/tenant/openai/identifyStall", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Map<String, dynamic>.from(res.data);
    },
  );
}
