import 'package:cloud/app/app.dart';
import 'package:cloud/providers/core_provider.dart';
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
    connectTimeout: const Duration(seconds: 120),
    headers: {
      Headers.acceptHeader: 'application/json',
    },
  ),
)
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final core = app.container.read(coreProvider).value;
      final tenant = core?.currentTenant;
      final baseUrl = tenant?.baseUrl;

      if (baseUrl != null) {
        options.baseUrl = baseUrl;
      }
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
