// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.envied')
abstract class Env {
  @EnviedField(obfuscate: true)
  static String API_URL = _Env.API_URL;
  @EnviedField(obfuscate: true)
  static String APP_TOKEN = _Env.APP_TOKEN;
}
