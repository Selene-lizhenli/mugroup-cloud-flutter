import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/quotation_sample.dart';

class ExportResult {
  final bool success;
  final String? message;

  ExportResult({required this.success, this.message});
}

Future<ExportResult> exportQuotationFile(
  int id,
  Map<String, dynamic> data,
) async {
  final res = await api.post(
    "api/tenant/showroom/quotations/$id/send",
    data: data,
  );

  // 情况 ：后端只返回成功
  return ExportResult(
    success: res.statusCode == 200,
    message: res.statusMessage as String,
  );
}

Future<ApiResponse<List<QuotationSample>>> getQuotationProductListByProductId(
    int id, Map<String, dynamic>? data) async {
  return api
      .get("api/tenant/showroom/quotations/$id/products", data: data)
      .then(
        (res) => ApiResponse<List<QuotationSample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(QuotationSample.fromJson).toList();
          },
        ),
      ); 
}

Future<QuotationList> getQuotationListById(int id) async {
  return api.get("api/tenant/showroom/quotations/$id").then(
    (res) {
      logger.d('报价单详情接口返回：${res.data}');
      res.data as Map<String, dynamic>;
      return QuotationList.fromJson(res.data);
    },
  );
}

Future<List<QuoteSupplierGroup>> getQuotationSupplierListById(int id) async {
  final res = await api.get(
    "api/tenant/showroom/quotations/$id/group_by_supplier",
  );
  // logger.d('供应商接口返回：${res.data}');
  final data = res.data as List;
  final dataRes = data
      .map((e) => QuoteSupplierGroup.fromJson(e as Map<String, dynamic>))
      .toList();
  // logger.d('供应商接口返回22222：${dataRes}');

  return dataRes;
}

Future<ApiResponse<List<QuotationList>>> getShowroomQuotation(
    Map<String, dynamic>? data) async {
  return api.get("api/tenant/showroom/quotations", data: data).then(
        (res) => ApiResponse<List<QuotationList>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(QuotationList.fromJson).toList();
          },
        ),
      );
}

Future<void> deleteQuotation(int id) async {
  
  await api.delete("api/tenant/showroom/quotations/$id");
  
}

// 移除样品明细中的商品
Future removeQuotationSamples(Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/showroom/quotations/quotationSamples/remove",
          data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return res;
    },
  );
}

// 添加b报价单样品明细中的商品
Future addQuotationSamples(Map<String, Object?>? data) async {
  return api
      .post("api/tenant/showroom/quotations/quotationSamples/add", data: data)
      .then(
    (res) {
      if (res.statusCode == 200 && res.statusMessage == "OK") {
        return true;
      }
      return false;
    },
  );
}

Future<QuotationList?> addQuoteCollaborators(
    int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/showroom/quotations/$id/collaborators/add", data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return QuotationList.fromJson(res.data);
    },
  );
}

Future<QuotationList?> removeQuoteCollaborators(
    int id, Map<String, dynamic>? data) async {
  return api
      .post("api/tenant/showroom/quotations/$id/collaborators/remove",
          data: data)
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }

      return QuotationList.fromJson(res.data);
    },
  );
}

Future updateShowroomQuotationSample(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/quotationSamples/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return false;
      }
      return true;
    },
  );
}
