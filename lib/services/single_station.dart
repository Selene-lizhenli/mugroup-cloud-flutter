import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/single_station/single_station_item.dart';

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

Future<ApiResponse<List<QuotationSample>>> getInquiriesList(
    Map<String, dynamic>? data) async {
  // pageSize=20&name=x&page=1
  return api.get("api/tenant/showroom/inquiries", data: data).then(
        (res) => ApiResponse<List<QuotationSample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(QuotationSample.fromJson).toList();
          },
        ),
      );
}

Future<ApiResponse<List<QuotationSample>>> getStationSamplesList(
    Map<String, dynamic>? data) async {
  // pageSize=20&name=x&page=1
  return api.get("api/tenant/station/samples/station_samples", data: data).then(
        (res) => ApiResponse<List<QuotationSample>>.fromJson(
          res.data,
          (data) {
            var list = (data as List).cast<Map<String, dynamic>>();
            return list.map(QuotationSample.fromJson).toList();
          },
        ),
      );
}
 