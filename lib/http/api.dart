import 'package:dio/dio.dart';

final api = Dio(
  BaseOptions(
    baseUrl: 'https://apifoxmock.com/m1/5861176-5547581-default',
    connectTimeout: const Duration(seconds: 5),
    headers: {Headers.acceptHeader: 'application/json'},
  ),
);
