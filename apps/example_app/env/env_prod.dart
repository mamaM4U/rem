// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env_prod.g.dart';

@Envied(path: '.envied.prod')
abstract class EnvProd {
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_EMULATOR = _EnvProd.API_BASE_URL_EMULATOR;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_PHYSICAL = _EnvProd.API_BASE_URL_PHYSICAL;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_IOS = _EnvProd.API_BASE_URL_IOS;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_WEB = _EnvProd.API_BASE_URL_WEB;

  @EnviedField(defaultValue: 'false')
  static String DEMO_MODE = _EnvProd.DEMO_MODE;
}
