import 'dart:io';

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.envied')
abstract class Env {
  @EnviedField(varName: 'API_URL', defaultValue: 'http://localhost:8080')
  static final String _apiUrl = _Env._apiUrl;

  /// Get API URL - prioritize environment variable (for Docker), fallback to envied
  static String get apiUrl {
    return Platform.environment['API_URL'] ?? _apiUrl;
  }
}
