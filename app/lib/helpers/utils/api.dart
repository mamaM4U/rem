import 'package:dio/dio.dart';
import 'package:arona/env/env.dart';
import 'package:arona/helpers/utils/logging_interceptor.dart';

class Api {
  final dio = createDio();

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: Env.API_URL,
      connectTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.addAll([LoggingInterceptor()]);

    return dio;
  }
}

final Dio dio = Api().dio;
