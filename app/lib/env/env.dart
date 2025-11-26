// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.envied')
abstract class Env {
  @EnviedField(obfuscate: true)
  static String API_BASE_URL = _Env.API_BASE_URL;
  @EnviedField(obfuscate: true)
  static String API_BASE_URL_IOS = _Env.API_BASE_URL_IOS;
}
