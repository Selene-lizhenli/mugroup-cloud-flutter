import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied(requireEnvFile: true)
abstract class Config {
  @EnviedField(varName: 'CORE_API_URL')
  static const String coreApiUrl = _Config.coreApiUrl;
}
