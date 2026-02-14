import 'package:cloud/http/api.dart';
import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/models/response.dart';

// GET https://cloud.mugroup.com/api/tenant/feedback/books?pageSize=20&anonymous=false&status=received&page=1
// 入参：  page, pageSize, status=received anonymous=false
// 返回：list，每项结构见 AdviceCollectBook
Future<ApiResponse<List<AdviceCollectBook>>> getAdviceCollectBooks(
  Map<String, dynamic>? params,
) async {
  return api.get('api/tenant/feedback/books', data: params).then(
        (res) => ApiResponse<List<AdviceCollectBook>>.fromJson(
          res.data,
          (data) {
            final list = (data as List).cast<Map<String, dynamic>>();
            return list.map(AdviceCollectBook.fromJson).toList();
          },
        ),
      );
}

//  api/tenant/feedback/books/myself?pageSize=20&page=1
// 入参： page, pageSize
// 返回：list，每项结构见 AdviceCollectBook
Future<ApiResponse<List<AdviceCollectBook>>> getAdviceCollectBooksMyself(
  Map<String, dynamic>? params,
) async {
  return api.get('api/tenant/feedback/books/myself', data: params).then(
        (res) => ApiResponse<List<AdviceCollectBook>>.fromJson(
          res.data,
          (data) {
            final list = (data as List).cast<Map<String, dynamic>>();
            return list.map(AdviceCollectBook.fromJson).toList();
          },
        ),
      );
}

// POST /api/tenant/feedback/books
// anonymous: false
// content: "测试内容11\n"

Future<ApiResponse> sendAdvice(
  Map<String, dynamic>? params,
) async {
  return api.post('api/tenant/feedback/books', data: params).then(
        (res) => ApiResponse.fromJson(
          res.data,
          (data) {
            if(res.data['code'] == 200) {
              return true;
            } else {
              return false;
            } 
          },
        ),
      );
}
