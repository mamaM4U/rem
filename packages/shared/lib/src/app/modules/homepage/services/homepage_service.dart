import 'dart:async';
import 'package:dio/dio.dart';
import '../../../helpers/dev_print.dart';
import '../../../helpers/utils/api.dart';
import '../../../helpers/demo/demo_data.dart';
import '../../../helpers/demo/demo_mode.dart';

class HomepageService {
  Future<List?> getHomepageData({String? query}) async {
    // Demo mode: return mock todos
    if (DemoMode.isEnabled) {
      await DemoData.simulateNetworkDelay();
      return DemoData.demoTodos;
    }

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
