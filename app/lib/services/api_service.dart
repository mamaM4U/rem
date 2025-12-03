import 'dart:io';

import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';

import '../env/env.dart';
import '../helpers/utils/device_detector.dart';

class ApiService {
  late final Dio _dio;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

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

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      RequestsInspectorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  String? getAuthToken() {
    return _dio.options.headers['Authorization'] as String?;
  }
}
