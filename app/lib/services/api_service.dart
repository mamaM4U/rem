import 'dart:io';

import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';

import '../env/env.dart';

class ApiService {
  late final Dio _dio;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Use 10.0.2.2 for Android emulator, localhost for iOS/web
  static String get baseUrl {
    if (Platform.isAndroid) {
      return Env.API_BASE_URL;
    }
    return Env.API_BASE_URL_IOS;
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
