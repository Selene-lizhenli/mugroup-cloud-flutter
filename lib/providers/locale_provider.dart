import 'package:cloud/app/app.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

enum AppLanguage {
  zh,
  en,
}

const _localeKey = 'app_locale';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    final saved = app.prefs.getString(_localeKey);
    if (saved == AppLanguage.en.name) {
      return const Locale('en');
    }
    return const Locale('zh');
  }

  AppLanguage get currentLanguage {
    return state.languageCode == 'en' ? AppLanguage.en : AppLanguage.zh;
  }

  void setLanguage(AppLanguage language) {
    final locale = language == AppLanguage.en
        ? const Locale('en')
        : const Locale('zh');
    state = locale;
    app.prefs.setString(_localeKey, language.name);
  }
}
