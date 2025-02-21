import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

final api = Dio(
  BaseOptions(
    // baseUrl: 'https://apifoxmock.com/m1/5861176-5547581-default',
    baseUrl: 'http://192.168.0.203:8080/',
    connectTimeout: const Duration(seconds: 5),
    headers: {
      Headers.acceptHeader: 'application/json',
      'origin': "https://cloud.mugroup.com"
    },
  ),
)..interceptors.add(CookieManager(CookieJar()));
