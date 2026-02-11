// ignore_for_file: non_constant_identifier_names
import 'env_local.dart';
import 'env_dev.dart';
import 'env_prod.dart';

abstract class Env {
  static const _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'local');

  static String get API_BASE_URL_EMULATOR => switch (_flavor) {
    'prod' => EnvProd.API_BASE_URL_EMULATOR,
    'dev' => EnvDev.API_BASE_URL_EMULATOR,
    _ => EnvLocal.API_BASE_URL_EMULATOR,
  };

  static String get API_BASE_URL_PHYSICAL => switch (_flavor) {
    'prod' => EnvProd.API_BASE_URL_PHYSICAL,
    'dev' => EnvDev.API_BASE_URL_PHYSICAL,
    _ => EnvLocal.API_BASE_URL_PHYSICAL,
  };

  static String get API_BASE_URL_IOS => switch (_flavor) {
    'prod' => EnvProd.API_BASE_URL_IOS,
    'dev' => EnvDev.API_BASE_URL_IOS,
    _ => EnvLocal.API_BASE_URL_IOS,
  };

  static String get API_BASE_URL_WEB => switch (_flavor) {
    'prod' => EnvProd.API_BASE_URL_WEB,
    'dev' => EnvDev.API_BASE_URL_WEB,
    _ => EnvLocal.API_BASE_URL_WEB,
  };

  static String get DEMO_MODE => switch (_flavor) {
    'prod' => EnvProd.DEMO_MODE,
    'dev' => EnvDev.DEMO_MODE,
    _ => EnvLocal.DEMO_MODE,
  };
}
