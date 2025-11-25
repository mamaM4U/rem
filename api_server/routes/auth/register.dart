import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:plana/repositories/user_repository.dart';
import 'package:shared/shared.dart';
import 'package:validators2/validators2.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final registerRequest = RegisterRequest.fromJson(body);

    // Validate email format
    if (!isEmail(registerRequest.email)) {
      final errorResponse = BaseResponse<AuthResponse>.error(
        message: 'Invalid email format',
      );
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    // Validate password length
    if (registerRequest.password.length < 6) {
      final errorResponse = BaseResponse<AuthResponse>.error(
        message: 'Password must be at least 6 characters',
      );
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    // Check if user exists
    final existingUser = await userRepository.findByEmail(
      registerRequest.email,
    );
    if (existingUser != null) {
      final errorResponse = BaseResponse<AuthResponse>.error(
        message: 'Email already exists',
      );
      return Response.json(
        statusCode: HttpStatus.conflict,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    // Create user
    final user = await userRepository.create(
      email: registerRequest.email,
      name: registerRequest.name,
      password: registerRequest.password,
    );

    // Generate JWT
    final jwt = JWT({
      'userId': user.id,
      'email': user.email,
    });

    final token = jwt.sign(SecretKey('your-secret-key-change-in-production'));

    final authResponse = AuthResponse(
      token: token,
      user: user,
    );

    final successResponse = BaseResponse<AuthResponse>.success(
      data: authResponse,
      message: 'Registration successful',
    );

    return Response.json(
      statusCode: HttpStatus.created,
      body: successResponse.toJson((data) => data?.toJson() ?? {}),
    );
  } catch (e) {
    final errorResponse = BaseResponse<AuthResponse>.error(
      message: 'Registration failed: $e',
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: errorResponse.toJson((data) => data?.toJson()),
    );
  }
}
