import 'package:cloud/config/config.dart';
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
);

final coreApi = silentCoreApi
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
