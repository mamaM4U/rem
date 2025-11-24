import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:arona/constants/http.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('\n');
    debugPrint(
      '--> ${options.method.toUpperCase()} ${'${options.baseUrl}${options.path}'}',
    );
    debugPrint('Headers:');

    // options.headers['Authorization'] = 'Bearer ${Token.getToken()}';
    options.headers.forEach((k, dynamic v) => debugPrint('$k: $v'));
    // if (options.queryParameters != null) {
    //   debugPrint('queryParameters:');
    //   options.queryParameters.forEach((k, dynamic v) => debugPrint('$k: $v'));
    // }
    debugPrint('queryParameters:');
    options.queryParameters.forEach((k, dynamic v) => debugPrint('$k: $v'));
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    debugPrint('--> END ${options.method.toUpperCase()}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('\n');
    debugPrint(
      '<-- ${err.message} ${err.response != null ? err.response!.realUri.path : 'Unknown Path'}',
    );
    debugPrint(
      '${err.response != null ? err.response!.data : 'Unknown Error'}',
    );
    debugPrint('<-- End error');

    if (err.response?.statusCode == HTTP.unAuthorized) {
      // reset the app
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('\n\n');
    debugPrint(
      '<--- HTTP CODE : ${response.statusCode} URL : ${response.realUri.path}',
    );
    debugPrint('Headers: ');
    debugPrint('<--- END HTTP');

    super.onResponse(response, handler);
  }
}
