import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied(requireEnvFile: true)
abstract class Config {
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Config.apiUrl;
  @EnviedField(varName: 'WEB_URL')
  static const String webUrl = _Config.webUrl;
  @EnviedField(varName: 'CORE_API_URL')
  static const String coreApiUrl = _Config.coreApiUrl;
}
