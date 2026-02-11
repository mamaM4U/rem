// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env_dev.g.dart';

@Envied(path: '.envied.dev')
abstract class EnvDev {
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_EMULATOR = _EnvDev.API_BASE_URL_EMULATOR;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_PHYSICAL = _EnvDev.API_BASE_URL_PHYSICAL;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_IOS = _EnvDev.API_BASE_URL_IOS;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_WEB = _EnvDev.API_BASE_URL_WEB;

  @EnviedField(defaultValue: 'false')
  static String DEMO_MODE = _EnvDev.DEMO_MODE;
}
