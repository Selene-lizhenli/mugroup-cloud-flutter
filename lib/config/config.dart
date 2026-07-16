import 'package:envied/envied.dart';

part 'config.g.dart';

/// Build-time environment switch.
/// - Dev/Test (default): uses `.env`
/// - Production: uses `.env.cloud` by passing `--dart-define=IS_PROD=true`
const bool kIsProdEnv = true;

@Envied(
  path: '.env',
  requireEnvFile: true,
)
abstract class DevConfig {
  @EnviedField(varName: 'CORE_API_URL')
  static const String coreApiUrl = _DevConfig.coreApiUrl;
}

@Envied(
  path: '.env.cloud',
  requireEnvFile: true,
)
abstract class ProdConfig {
  @EnviedField(varName: 'CORE_API_URL')
  static const String coreApiUrl = _ProdConfig.coreApiUrl;
}

/// Public facade used across the app.
abstract class Config {
  static const String coreApiUrl =
      kIsProdEnv ? ProdConfig.coreApiUrl : DevConfig.coreApiUrl;
}


// 打包/运行命令

// 测试环境（默认用 .env）
// flutter run  或  flutter build apk --release

// 生产环境（用 .env.cloud）
// flutter build apk --release --dart-define=IS_PROD=true