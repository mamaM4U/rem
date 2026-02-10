import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/app.dart';

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

  await initApp();
  runApp(const MyApp());
}
