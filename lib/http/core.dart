import 'package:cloud/config/config.dart';
import 'package:cloud/http/locale_header.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final silentCoreApi = Dio(
  BaseOptions(
    baseUrl: Config.coreApiUrl,
    connectTimeout: const Duration(seconds: 120),
    headers: {
      Headers.acceptHeader: 'application/json',
    },
  ),
)
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      applyAcceptLanguageHeader(options);
      handler.next(options);
    },
  ));

final coreApi = silentCoreApi
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      handler.next(options);
    },
    onError: (error, handler) {
      var err = error;
      if (error.type == DioExceptionType.connectionError) {
        err = error.copyWith(message: '网络错误，检查网络');
      }

      final response = error.response;

      do {
        if (response?.statusCode != null && response!.statusCode! >= 300) {
          final messaage = response.data['message'] ?? "未知错误";
          EasyLoading.showError(messaage);
          break;
        }

        if (error.message != null) {
          EasyLoading.showError(err.message!);
        }
      } while (false);

      return handler.next(err);
    },
  ));
