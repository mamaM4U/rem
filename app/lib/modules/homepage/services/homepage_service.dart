import 'dart:async';
import 'package:dio/dio.dart';
import 'package:arona/helpers/dev_print.dart';
import 'package:arona/helpers/utils/api.dart';

class HomepageService {
  Future<List?> getHomepageData({String? query}) async {
    try {
      Response<Map<String, dynamic>> response = await dio.get('/todos');
      if (response.data != null && response.data!['todos'] != null) {
        return response.data!['todos'];
      }
      return null;
    } catch (e) {
      devPrint(e);
      return null;
    }
  }
}
