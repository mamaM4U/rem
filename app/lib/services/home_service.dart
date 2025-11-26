import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

import 'api_service.dart';

class HomeService {
  final ApiService _apiService;

  HomeService(this._apiService);

  Future<BaseResponse<HomeData>> getHomeData() async {
    try {
      final response = await _apiService.dio.get<Map<String, dynamic>>(
        '/home',
      );

      final baseResponse = BaseResponse<HomeData>.fromJson(
        response.data!,
        (json) => HomeData.fromJson(json as Map<String, dynamic>),
      );

      return baseResponse;
    } on DioException catch (e) {
      return BaseResponse<HomeData>.error(
        message: e.response?.data['message'] ?? 'Failed to fetch home data',
      );
    } catch (e) {
      return BaseResponse<HomeData>.error(
        message: 'An unexpected error occurred',
      );
    }
  }
}
