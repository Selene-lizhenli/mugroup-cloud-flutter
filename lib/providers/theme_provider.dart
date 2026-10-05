import 'package:cloud/app/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// 主题类型枚举
enum ThemeType {
  pink, // 玫粉色主题
  blue, // 蓝色主题
}

const _themeTypeKey = 'theme_type';

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeType build() {
    // 从SharedPreferences加载保存的主题，默认为玫粉色
    final savedThemeIndex = app.prefs.getInt(_themeTypeKey);
    if (savedThemeIndex != null && 
        savedThemeIndex >= 0 && 
        savedThemeIndex < ThemeType.values.length) {
      return ThemeType.values[savedThemeIndex];
    }
    return ThemeType.pink; // 默认玫粉色
  }

  /// 设置主题
  void setTheme(ThemeType themeType) {
    state = themeType;
    // 保存到SharedPreferences
    app.prefs.setInt(_themeTypeKey, themeType.index);
  }
}

