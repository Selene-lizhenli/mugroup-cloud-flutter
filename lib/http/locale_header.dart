import 'package:cloud/app/app.dart';
import 'package:cloud/providers/locale_provider.dart';
import 'package:dio/dio.dart';

void applyAcceptLanguageHeader(RequestOptions options) {
  final locale = app.container.read(appLocaleProvider);
  if (locale.languageCode == 'en') {
    options.headers['accept-language'] = 'en';
  } else {
    options.headers.remove('accept-language');
  }
}
