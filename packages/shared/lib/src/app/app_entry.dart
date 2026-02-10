import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'constants/routes.dart';
import 'helpers/utils/device_detector.dart';
import 'routes/routes.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

/// Initialize the app (device detection, API service, auth)
Future<void> initApp() async {
  // Initialize device detection (must be before ApiService)
  await DeviceDetector.init();

  // Initialize ApiService and load saved token
  final apiService = ApiService();
  final authService = AuthService(apiService);
  final token = await authService.getToken();
  if (token != null) {
    apiService.setAuthToken(token);
  }
}

/// Main app widget - wraps GetMaterialApp with RequestsInspector
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RequestsInspector(
      showInspectorOn: ShowInspectorOn.LongPress,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rem App',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        initialRoute: HOME_PAGE.path,
        getPages: pages(),
      ),
    );
  }
}
