import 'package:cloud/app/app.dart';
import 'package:cloud/config/config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final cookieJar = PersistCookieJar(
  storage: FileStorage(app.temporaryDirectory.path),
);

final silentApi = Dio(
  BaseOptions(
    // baseUrl: 'https://apifoxmock.com/m1/5861176-5547581-default',
    // baseUrl: Config.apiUrl,
    connectTimeout: const Duration(seconds: 120),
    headers: {
      Headers.acceptHeader: 'application/json',
    },
  ),
)
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      options.baseUrl = Config.apiUrl;
      options.headers['origin'] = options.uri.origin;
      var cookies = await cookieJar.loadForRequest(options.uri);
      var csrfToken =
          cookies.firstWhereOrNull((c) => c.name == 'XSRF-TOKEN')?.value;

      if (csrfToken != null) {
        options.headers['X-XSRF-TOKEN'] = Uri.decodeComponent(csrfToken);
      }
      handler.next(options);
    },
    onError: (error, handler) {
      return handler.next(error);
    },
  ))
  ..interceptors.add(CookieManager(
    cookieJar,
  ));

final api = silentApi.clone()
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      handler.next(options);
    },
    onError: (error, handler) {
      final response = error.response;

      do {
        if (response?.statusCode != null && response!.statusCode! >= 300) {
          final messaage = response.data['message'] ?? "未知错误";
          EasyLoading.showError(messaage);
          break;
        }

        if (error.message != null) {
          EasyLoading.showError(error.message!);
        }
      } while (false);

      return handler.next(error);
    },
  ));
