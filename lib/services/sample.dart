import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/category.dart';
import 'package:cloud/models/sample/quotation.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/sample/sample.dart';

Future<Sample?> updateShowroomSample(int id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/samples/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Sample.fromJson(res.data);
    },
  );
}

Future<Sample?> storeShowroomSample(Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/samples", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Sample.fromJson(res.data);
    },
  );
}

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

Future<ApiResponse<List<Sample>>> getSampleSimilars({
  required int id,
  Map<String, dynamic>? queryParameters,
}) async {
  return api
      .get("api/tenant/showroom/samples/$id/similars",
          queryParameters: queryParameters)
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

Future<Sample?> getSample(int id) async {
  return api.get("api/tenant/showroom/samples/$id").then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Sample.fromJson(res.data);
    },
  );
}

Future<ApiResponse<List<Sample>>> getMarketProducts(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/showroom/market_products",
          queryParameters: queryParameters)
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

// 更新报价单
Future updateShowroomQuotation(String id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/quotations/${id}", data: data).then(
    (res) {
      if (res.data == null) {
        return false;
      }
      return true;
    },
  );
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

Future<List<Category>?> getAllShowroomCategories() async {
  final res = await api.get(
    "api/tenant/showroom/categories",
    queryParameters: {'all': '0'},
  );

  if (res.data is List) {
    return (res.data as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return null;
}

/// 统计数据项
class SampleStatisticItem {
  final String name;
  final int count;

  SampleStatisticItem({
    required this.name,
    required this.count,
  });

  factory SampleStatisticItem.fromJson(Map<String, dynamic> json) {
    // 支持 'name' 或 'value' 字段作为名称
    final name = json['name'] ?? json['value'] ?? '';
    final count = json['count'] ?? 0;
    return SampleStatisticItem(name: name, count: count);
  }
}

/// 获取样品间统计数据（按贸易国别）
Future<List<SampleStatisticItem>?> getShowroomSampleTradeCountryStats() async {
  final res = await api.get(
    "api/tenant/schemas/showroom_samples/trade_country",
  );

  if (res.data == null) {
    return null;
  }

  if (res.data is List) {
    return (res.data as List)
        .map((e) => SampleStatisticItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  return null;
}
