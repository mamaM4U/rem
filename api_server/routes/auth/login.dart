import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:plana/repositories/user_repository.dart';
import 'package:shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final loginRequest = LoginRequest.fromJson(body);

    // Find user
    final userData = await userRepository.findByEmail(loginRequest.email);
    if (userData == null) {
      final errorResponse = BaseResponse<AuthResponse>.error(
        message: 'Invalid credentials',
      );
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    final hashedPassword = userData['password_hash']! as String;

    // Verify password
    if (!userRepository.verifyPassword(loginRequest.password, hashedPassword)) {
      final errorResponse = BaseResponse<AuthResponse>.error(
        message: 'Invalid credentials',
      );
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: errorResponse.toJson((data) => data?.toJson() ?? {}),
      );
    }

    // Generate JWT
    final jwt = JWT({
      'userId': userData['id'],
      'email': userData['email'],
    });

    final token = jwt.sign(SecretKey('your-secret-key-change-in-production'));

    final user = userRepository.toUser(userData);

    final authResponse = AuthResponse(
      token: token,
      user: user,
    );

    final successResponse = BaseResponse<AuthResponse>.success(
      data: authResponse,
      message: 'Login successful',
    );

    return Response.json(
      body: successResponse.toJson((data) => data?.toJson() ?? {}),
    );
  } catch (e) {
    final errorResponse = BaseResponse<AuthResponse>.error(
      message: 'Login failed: $e',
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: errorResponse.toJson((data) => data!.toJson()),
    );
  }
}
