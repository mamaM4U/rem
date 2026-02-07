import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared/shared.dart';

import '../helpers/demo/demo_data.dart';
import '../helpers/demo/demo_mode.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  AuthService(this._apiService) : _secureStorage = const FlutterSecureStorage();

  Future<BaseResponse<AuthResponse>> register({required String email, required String name, required String password}) async {
    // Demo mode: simulate registration
    if (DemoMode.isEnabled) {
      await DemoData.simulateNetworkDelay();
      return BaseResponse<AuthResponse>.error(message: 'Registration disabled in demo mode. Use demo credentials.');
    }

    try {
      final response = await _apiService.dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {'email': email, 'name': name, 'password': password},
      );

      final baseResponse = BaseResponse<AuthResponse>.fromJson(
        response.data!,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );

      // Save token and user ID if successful
      if (baseResponse.success && baseResponse.data != null) {
        await _saveAuthData(baseResponse.data!);
      }

      return baseResponse;
    } on DioException catch (e) {
      return BaseResponse<AuthResponse>.error(message: e.response?.data['message'] ?? 'Registration failed');
    } catch (e) {
      return BaseResponse<AuthResponse>.error(message: 'An unexpected error occurred');
    }
  }

  Future<BaseResponse<AuthResponse>> login({required String email, required String password}) async {
    // Demo mode: validate demo credentials
    if (DemoMode.isEnabled) {
      await DemoData.simulateNetworkDelay();
      if (DemoMode.isValidDemoCredentials(email, password)) {
        final authResponse = DemoData.demoAuthResponse;
        await _saveAuthData(authResponse);
        return BaseResponse<AuthResponse>.success(data: authResponse, message: 'Welcome to Demo Mode!');
      } else {
        return BaseResponse<AuthResponse>.error(message: 'Invalid demo credentials. Use demo@example.com / demo123');
      }
    }

    try {
      final response = await _apiService.dio.post<Map<String, dynamic>>('/auth/login', data: {'email': email, 'password': password});

      final baseResponse = BaseResponse<AuthResponse>.fromJson(
        response.data!,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );

      // Save token and user ID if successful
      if (baseResponse.success && baseResponse.data != null) {
        await _saveAuthData(baseResponse.data!);
      }

      return baseResponse;
    } on DioException catch (e) {
      return BaseResponse<AuthResponse>.error(message: e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      return BaseResponse<AuthResponse>.error(message: 'An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userIdKey);
    _apiService.clearAuthToken();
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _secureStorage.write(key: _tokenKey, value: authResponse.token);
    await _secureStorage.write(key: _userIdKey, value: authResponse.user.id);
    _apiService.setAuthToken(authResponse.token);
  }
}
