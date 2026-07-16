import 'dart:convert';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/cx_inventory/cx.inventory.dart';
import 'package:cloud/models/response.dart';

// https://cloud.mugroup.com/api/tenant/changxiang/inventory?pageSize=20&PurchaseOrderNo=2304102&tab=high&page=1
// PurchaseOrderNo 是采购单号

// 列表
Future<ApiResponse<List<CxInventoryType>>> getInventoryList(
    Map<String, dynamic>? data) async {
  return api.get("api/tenant/changxiang/inventory", data: data).then(
        (res) => ApiResponse<List<CxInventoryType>>.fromJson(
          res.data,
          (data) {
            // 接口返回为一个外层 List，这里只取第一项作为实际数据列表
            final outerList = data as List;
            if (outerList.isNotEmpty) {
              logger.d(
                  'getInquiriesList 第一项: ${const JsonEncoder.withIndent('  ').convert(outerList[0])}');
            }
            final list = outerList.cast<Map<String, dynamic>>();
            return list.map(CxInventoryType.fromJson).toList();
          },
        ),
      );
}
