import 'dart:io';

import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../../env/env.dart';
import '../../helpers/utils/logging_interceptor.dart';
import '../../helpers/utils/device_detector.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  /// Get the appropriate base URL based on platform and device type
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Check if it's emulator or physical device
      if (DeviceDetector.isAndroidEmulator()) {
        return Env.API_BASE_URL_EMULATOR; // 10.0.2.2:8080
      } else {
        return Env.API_BASE_URL_PHYSICAL; // Your LAN IP
      }
    } else if (Platform.isIOS) {
      return Env.API_BASE_URL_IOS; // localhost for iOS simulator
    } else {
      return Env.API_BASE_URL_WEB; // localhost for web/desktop
    }
  }

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.addAll([
      RequestsInspectorInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}

final Dio dio = Api().dio;
