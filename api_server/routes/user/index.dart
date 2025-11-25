import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:plana/repositories/user_repository.dart';
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Get token from Authorization header
    final authHeader = context.request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      final errorResponse = BaseResponse<User>.error(
        message: 'Missing or invalid authorization token',
      );
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    final token = authHeader.substring(7);

    // Verify JWT
    try {
      final jwt = JWT.verify(
        token,
        SecretKey('your-secret-key-change-in-production'),
      );
      final payload = jwt.payload as Map<String, dynamic>;
      final email = payload['email'] as String;

      // Get user data
      final userData = await userRepository.findByEmail(email);
      if (userData == null) {
        final errorResponse = BaseResponse<User>.error(
          message: 'User not found',
        );
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: errorResponse.toJson((data) => data?.toJson() ?? {}),
        );
      }

      final user = userRepository.toUser(userData);
      final successResponse = BaseResponse<User>.success(
        data: user,
        message: 'User retrieved successfully',
      );

      return Response.json(
        body: successResponse.toJson((data) => data?.toJson() ?? {}),
      );
    } on JWTExpiredException {
      final errorResponse = BaseResponse<User>.error(
        message: 'Token expired',
      );
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    } on JWTException {
      final errorResponse = BaseResponse<User>.error(
        message: 'Invalid token',
      );
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }
  } catch (e) {
    final errorResponse = BaseResponse<User>.error(
      message: 'Failed to get user: $e',
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: errorResponse.toJson((data) => data?.toJson()),
    );
  }
}
