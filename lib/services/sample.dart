import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/quotation.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/sample/sample.dart';

Future<ApiResponse<List<Sample>>> getSamples(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/showroom/samples", queryParameters: queryParameters)
      .then(
        (res) => ApiResponse<List<Sample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(Sample.fromJson).toList();
          },
        ),
      );
}

Future<Sample?> getSampleByBarcode(String barcode) async {
  return api.get("api/tenant/showroom/samples/barcode/$barcode").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Sample.fromJson(res.data);
    },
  );
}

Future<Quotation?> storeShowroomQuotation(Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/quotations", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Quotation.fromJson(res.data);
    },
  );
}

Future<Quotation?> getShowroomQuotationByQuoteNo(String quoteNo) async {
  return api.get("api/tenant/showroom/quotations/quote_no/$quoteNo").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Quotation.fromJson(res.data);
    },
  );
}

Future<ApiResponse<List<QuotationSample>>> getQuotationSamples(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/showroom/quotationSamples",
          queryParameters: queryParameters)
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
