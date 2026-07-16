import 'dart:convert';
import 'dart:io';

import 'package:cloud/app/app.dart';
import 'package:cloud/http/locale_header.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final cookieJar = PersistCookieJar(
  storage: FileStorage(app.temporaryDirectory.path),
);

bool _handlingUnauthorized = false;
Future<String>? _userAgentFuture;

Future<void> _handleUnauthorized() async {
  if (_handlingUnauthorized) return;
  _handlingUnauthorized = true;

  try {
    authNotifier.logout();
    // await cookieJar.deleteAll();  // 这个会导致截图扫码登录后直接401
    app.router.replaceAll([LoginRoute()]);
  } finally {
    _handlingUnauthorized = false;
  }
}

String generateSalt(String api, int time) {
  final content = base64Encode(utf8.encode('$api$time'));

  final toHash = "${content}MUGROUP";

  final hash = md5.convert(utf8.encode(toHash)).toString();

  return hash.toUpperCase().substring(0, 8);
}

Future<String> _buildDeviceUa() async {
  final appVersion = _uaSafe(app.fullVersion);
  final system = _uaSafe(Platform.operatingSystem);
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    String kernel = 'Linux'; // 内核 安卓默认Linux

    //  判断是不是鸿蒙内核（从 systemFeatures / 系统特征）
    final bool isHarmony =
        info.systemFeatures.any((f) => f.toLowerCase().contains('harmony')) ||
            info.display.toLowerCase().contains('harmony');
    if (isHarmony) {
      kernel = 'Harmony';
    }

    final systemName = isHarmony ? 'HarmonyOS' : 'Android';
    final systemVersion = _uaSafe(info.version.release); //主版本号
    final model = _uaSafe(info.model); //设备型号 直接对应到某品牌某型号

    return 'MugroupCloud/$appVersion ($kernel; $systemName $systemVersion) Mobile/$model';
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    final iosVersion = _uaSafe(
        info.systemVersion.replaceAll('.', '_')); // 系统版本（转成 18_7 格式，保持你原来的风格）
    final realModel =
        _uaSafe(info.utsname.machine); // 真实设备型号（最精准，如 iPhone15,2 / iPad14,4）
    return 'MugroupCloud/$appVersion (${info.model}; $iosVersion) Mobile/$realModel';
  }

  final systemVersion = _uaSafe(Platform.operatingSystemVersion);
  return 'MugroupCloud/$appVersion (Other; $system $systemVersion) Mobile/other';
}

String _uaSafe(String? value, {String fallback = 'unknown'}) {
  final cleaned = (value ?? '').trim();
  if (cleaned.isEmpty) return fallback;
  return cleaned.replaceAll(RegExp(r'\s+'), '_').replaceAll('/', '_');
}

Future<String> _getGlobalUserAgent() {
  return _userAgentFuture ??= _buildDeviceUa();
}

final silentApi = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 120),
    listFormat: ListFormat.multiCompatible,
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
      options.headers['User-Agent'] = await _getGlobalUserAgent();
      applyAcceptLanguageHeader(options);
      handler.next(options);
    },
    onError: (error, handler) {
      var err = error;
      if (error.type == DioExceptionType.connectionError) {
        err = error.copyWith(message: '网络错误，检查网络');
      }
      if (error.response?.statusCode == 401) {
        _handleUnauthorized();
      }
      return handler.next(err);
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
      if (response?.statusCode == 401) {
        _handleUnauthorized();
      }

      do {
        if (response?.statusCode != null && response!.statusCode! >= 300) {
          final data = response.data;
          final String? rawMessage =
              data is Map ? data['message']?.toString() : null;
          final message = (rawMessage ?? '').trim();

          if (response.statusCode == 401 &&
              message.toLowerCase() == 'unauthenticated.') {
            EasyLoading.showError('登录失效，请重新登录');
          } else {
            EasyLoading.showError(rawMessage ?? "未知错误");
          }
          break;
        }

        if (error.message != null) {
          EasyLoading.showError(error.message!);
        }
      } while (false);

      return handler.next(error);
    },
  ));
