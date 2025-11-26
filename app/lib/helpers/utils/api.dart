import 'dart:io';

import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:arona/env/env.dart';
import 'package:arona/helpers/utils/logging_interceptor.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  // Use 10.0.2.2 for Android emulator, localhost for iOS/web
  static String get baseUrl {
    if (Platform.isAndroid) {
      return Env.API_BASE_URL;
    }
    return Env.API_BASE_URL_IOS;
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
