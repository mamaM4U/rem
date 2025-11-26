import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'constants/routes.dart';
import 'routes/routes.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize ApiService and load saved token
  final apiService = ApiService();
  final authService = AuthService(apiService);
  final token = await authService.getToken();
  if (token != null) {
    apiService.setAuthToken(token);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RequestsInspector(
      showInspectorOn: ShowInspectorOn.LongPress,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rem App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: HOME_PAGE.path,
        getPages: pages(),
      ),
    );
  }
}
