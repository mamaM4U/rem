// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env_local.g.dart';

@Envied(path: 'packages/shared/lib/src/app/.envied.local')
abstract class EnvLocal {
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_EMULATOR = _EnvLocal.API_BASE_URL_EMULATOR;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_PHYSICAL = _EnvLocal.API_BASE_URL_PHYSICAL;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_IOS = _EnvLocal.API_BASE_URL_IOS;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_WEB = _EnvLocal.API_BASE_URL_WEB;

  @EnviedField(defaultValue: 'false')
  static String DEMO_MODE = _EnvLocal.DEMO_MODE;
}
