import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/env.dart';
import '../models/api_response.dart';
import '../models/home_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String get baseUrl => Env.apiUrl;

  Future<ApiResponse<HomeData>> getHomeData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse.fromJson(json, HomeData.fromJson);
      } else {
        return ApiResponse(
          success: false,
          message: 'Failed to load data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: $e',
      );
    }
  }
}
