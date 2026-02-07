// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.envied')
abstract class Env {
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_EMULATOR = _Env.API_BASE_URL_EMULATOR;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_PHYSICAL = _Env.API_BASE_URL_PHYSICAL;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_IOS = _Env.API_BASE_URL_IOS;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_WEB = _Env.API_BASE_URL_WEB;

  @EnviedField(defaultValue: 'false')
  static String DEMO_MODE = _Env.DEMO_MODE;
}
