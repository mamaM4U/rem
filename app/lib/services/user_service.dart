import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

import 'api_service.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  Future<BaseResponse<User>> getUserProfile() async {
    try {
      final response = await _apiService.dio.get<Map<String, dynamic>>(
        '/user',
      );

      final baseResponse = BaseResponse<User>.fromJson(
        response.data!,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      return baseResponse;
    } on DioException catch (e) {
      return BaseResponse<User>.error(
        message: e.response?.data['message'] ?? 'Failed to fetch user profile',
      );
    } catch (e) {
      return BaseResponse<User>.error(
        message: 'An unexpected error occurred',
      );
    }
  }
}
