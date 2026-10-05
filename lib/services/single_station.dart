import 'dart:convert';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/models/single_station/single_station_products.dart';

Future<ApiResponse<List<SingleStationItem>>> getSingleStationList(
    Map<String, dynamic>? data) async {
  // pageSize=20&name_cn=%E6%B5%8B&page=1
  return api.get("api/tenant/station/samples", data: data).then(
        (res) => ApiResponse<List<SingleStationItem>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(SingleStationItem.fromJson).toList();
          },
        ),
      );
}

// 询盘列表
Future<ApiResponse<List<SingleStationInquiries>>> getInquiriesList(
    Map<String, dynamic>? data) async {
  // pageSize=20&name=x&page=1
  return api.get("api/tenant/showroom/inquiries", data: data).then(
        (res) => ApiResponse<List<SingleStationInquiries>>.fromJson(
          res.data,
          (data) {
            // 接口返回为一个外层 List，这里只取第一项作为实际数据列表
            final outerList = data as List;
            if (outerList.isNotEmpty) {
              logger.d(
                  'getInquiriesList 第一项: ${const JsonEncoder.withIndent('  ').convert(outerList[0])}');
            }
            final list = outerList.cast<Map<String, dynamic>>();
            return list.map(SingleStationInquiries.fromJson).toList();
          },
        ),
      );
}

// 独立站 产品列表
Future<ApiResponse<List<SingleStationSample>>> getStationSamplesList(
    Map<String, dynamic>? data) async {
  // pageSize=20&name=x&page=1
  return api.get("api/tenant/station/samples/station_samples", data: data).then(
        (res) => ApiResponse<List<SingleStationSample>>.fromJson(
          res.data,
          (data) {
            final rawList = data as List;
            if (rawList.isNotEmpty) {
              logger.d(
                  'getStationSamplesList 第一项: ${const JsonEncoder.withIndent('  ').convert(rawList[0])}');
            }
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(SingleStationSample.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<SingleStationSample>>> getInquiriesProductList(
    Map<String, dynamic>? data) async {
  // pageSize=20&inquiry_id=197&page=1
  return api.get("api/tenant/showroom/inquiry_samples", data: data).then(
        (res) => ApiResponse<List<SingleStationSample>>.fromJson(
          res.data,
          (data) {
            final rawList = data as List;
            if (rawList.isNotEmpty) {
              logger.d(
                  'getStationSamplesList 第一项: ${const JsonEncoder.withIndent('  ').convert(rawList[0])}');
            }
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(SingleStationSample.fromJson).toList();
          },
        ),
      );
}
