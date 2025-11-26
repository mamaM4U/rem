// ignore_for_file: non_constant_identifier_names
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.envied')
abstract class Env {
  @EnviedField(obfuscate: true)
  static String DATABASE_HOST = _Env.DATABASE_HOST;

  @EnviedField(obfuscate: true)
  static int DATABASE_PORT = _Env.DATABASE_PORT;

  @EnviedField(obfuscate: true)
  static String DATABASE_NAME = _Env.DATABASE_NAME;

  @EnviedField(obfuscate: true)
  static String DATABASE_USER = _Env.DATABASE_USER;

  @EnviedField(obfuscate: true)
  static String DATABASE_PASSWORD = _Env.DATABASE_PASSWORD;

  @EnviedField(obfuscate: true)
  static String JWT_SECRET = _Env.JWT_SECRET;
}
