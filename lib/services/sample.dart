import 'dart:math';

import 'package:cloud/constants/core.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/category.dart';
import 'package:cloud/models/sample/quotation.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:dio/dio.dart';

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

Future batchStoreShowroomSample(Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/samples/batchStore", data: data);
}

Future<ApiResponse<List<Sample>>> getSamples(
    {Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders}) async {
  return api
      .get(
        "api/tenant/showroom/samples",
        queryParameters: queryParameters,
        options: (extraHeaders == null || extraHeaders.isEmpty)
            ? null
            : Options(headers: extraHeaders),
      )
      .then(
        (res) => ApiResponse<List<Sample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            if (extraHeaders != null &&
                extraHeaders['X-Tenant-ID']?.toString().isNotEmpty == true) {
              return list
                  .map((e) => Sample.fromJson(<String, Object?>{
                        ...e,
                        'xTenantId': extraHeaders['X-Tenant-ID'],
                      }))
                  .toList();
            }
            return list.map(Sample.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<Sample>>> getSampleSimilars({
  required int id,
  Map<String, dynamic>? queryParameters,
  Map<String, dynamic>? extraHeaders,
}) async {
  return api
      .get(
        "api/tenant/showroom/samples/$id/similars",
        queryParameters: queryParameters,
        options: (extraHeaders == null || extraHeaders.isEmpty)
            ? null
            : Options(headers: extraHeaders),
      )
      .then(
        (res) => ApiResponse<List<Sample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();

            if (extraHeaders != null &&
                extraHeaders['X-Tenant-ID']?.toString().isNotEmpty == true) {
              final handledList = list
                  .map((e) => Sample.fromJson(<String, Object?>{
                        ...e,
                        'xTenantId': extraHeaders['X-Tenant-ID'],
                      }))
                  .toList();
              return handledList;
            }
            return list.map(Sample.fromJson).toList();
          },
        ),
      );
}

Future<Sample?> getSample(
  int id, {
  Map<String, dynamic>? extraHeaders,
}) async {
  return api
      .get(
    "api/tenant/showroom/samples/$id",
    options: (extraHeaders == null || extraHeaders.isEmpty)
        ? null
        : Options(headers: extraHeaders),
  )
      .then(
    (res) {
      if (res.data == null) {
        return null;
      }
      if (extraHeaders != null &&
          extraHeaders['X-Tenant-ID']?.toString().isNotEmpty == true) {
        return Sample.fromJson(<String, Object?>{
          ...(res.data as Map<String, dynamic>),
          'xTenantId': extraHeaders['X-Tenant-ID'],
        });
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

Future<Sample?> getSampleByBarcode(
  String barcode, {
  Map<String, dynamic>? extraHeaders,
}) async {
  return api
      .get(
    "api/tenant/showroom/samples/barcode/$barcode",
    options: (extraHeaders == null || extraHeaders.isEmpty)
        ? null
        : Options(headers: extraHeaders),
  )
      .then(
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

/// 提交报价单审批（创建成功后调用）。
Future<void> submitShowroomQuotationApproval(
  int quotationId, {
  String? note,
}) async {
  await api.post(
    "api/tenant/showroom/quotations/$quotationId/submit-approval",
    data: {'note': note ?? ''},
  );
}

// 更新报价单
Future updateShowroomQuotation(String id, Map<String, dynamic>? data) async {
  return api.post("api/tenant/showroom/quotations/$id", data: data).then(
    (res) {
      if (res.data == null) {
        return false;
      }
      return true;
    },
  );
}

//获取样品间的报价单的详情
Future<ApiResponse<List<SingleStationSample>>> getShowroomQuotationDetail(
    Map<String, dynamic>? data) async {
  return api.get("api/tenant/showroom/quotationSamples", data: data).then(
        (res) => ApiResponse<List<SingleStationSample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(SingleStationSample.fromJson).toList();
          },
        ),
      );
}

// 获取接口返回的报价单模版
// api/tenant/showroom/quotations/export_template/available
Future<ApiResponse<List<ExportTemplate>>>
    getShowroomQuotationExportTemplate() async {
  return api
      .get(
    "api/tenant/showroom/quotations/export_template/available",
  )
      .then(
    (res) {
      final data = res.data;

      // Some endpoints return raw `List` instead of `{ data: ..., meta: ... }`.
      if (data is List) {
        final list = data.cast<Map<String, dynamic>>();
        return ApiResponse<List<ExportTemplate>>.data(
          list.map(ExportTemplate.fromJson).toList(),
          null,
        );
      }

      return ApiResponse<List<ExportTemplate>>.fromJson(
        data as Map<String, dynamic>,
        (data) {
          final list = (data as List).cast<Map<String, dynamic>>();
          return list.map(ExportTemplate.fromJson).toList();
        },
      );
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

/// 获取产品分类统计数据（包含 count）。私有样品间可传 [xTenantId] 以带上 `X-Tenant-ID`。
Future<List<Category>?> getAllShowroomCategories({int? xTenantId}) async {

  final Map<String, dynamic>? extraHeaders = xTenantId != null
      ? <String, dynamic>{'X-Tenant-ID': xTenantId.toString()}
      : null;
  
  final res = await api.get(
    "api/tenant/showroom/categories",
    queryParameters: {'all': '0', "with_products_count": true},
    options: (extraHeaders == null || extraHeaders.isEmpty)
        ? null
        : Options(headers: extraHeaders),
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
