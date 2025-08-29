import 'dart:convert';

import 'package:cloud/app/app.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final cookieJar = PersistCookieJar(
  storage: FileStorage(app.temporaryDirectory.path),
);

String generateSalt(String api, int time) {
  final content = base64Encode(utf8.encode('$api$time'));

  final toHash = "${content}MUGROUP";

  final hash = md5.convert(utf8.encode(toHash)).toString();

  return hash.toUpperCase().substring(0, 8);
}

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
  ))
  // 请求加签
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final time = DateTime.now().millisecondsSinceEpoch;
      final api = options.path;
      final query = options.uri.query;

      var body = "";
      if (options.data is! FormData) {
        final transformer = BackgroundTransformer();
        body = await transformer.transformRequest(options);
      }

      final message = base64Encode(utf8.encode(body + query));

      final salt = generateSalt(api, time);

      final sign =
          Hmac(sha512, utf8.encode(base64.encode(utf8.encode(api + salt))))
              .convert(utf8.encode(message))
              .toString()
              .toLowerCase();

      options.headers['Mu-Sign'] = '$salt.${sign.substring(0, 30)}';
      options.headers['Mu-Sign-Version'] = '1';
      options.headers['Mu-Sign-Time'] = time.toString();

      handler.next(options);
    },
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
