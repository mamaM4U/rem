import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:arona/bindings/initial_binding.dart';
import 'package:arona/constants/colors.dart';
import 'package:arona/constants/routes.dart';
import 'package:arona/helpers/shared_preferences.dart';
import 'package:arona/routes/routes.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: SEMI_DARK_BACKGROUND_COLOR,
      statusBarColor: SEMI_DARK_BACKGROUND_COLOR,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // init shared preferences on top level of Apps
  await sharedPrefs.init();

  await initializeDateFormatting('id');
  Intl.defaultLocale = 'id_ID';

  EasyLoading.instance
    ..radius = 12
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskColor = const Color.fromARGB(40, 0, 0, 0)
    ..textColor = PRIMARY_COLOR
    ..indicatorColor = PRIMARY_COLOR
    ..backgroundColor = Colors.white
    ..progressColor = PRIMARY_COLOR;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('id'),
      getPages: pages(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY_COLOR).copyWith(
          surfaceTint: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
        )),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: PRIMARY_COLOR,
        ),
        primaryColor: PRIMARY_COLOR,
        iconTheme: const IconThemeData(
          color: FONT_SEMIDARK_COLOR,
        ),
        textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: Colors.transparent),
        unselectedWidgetColor: Colors.grey[300],
      ),
      initialBinding: InitialBindings(),
      builder: EasyLoading.init(),
      // initialRoute: sharedPrefs.getUserLoginData() == null ? LOGIN_PAGE.path : HOME_PAGE.path,
      initialRoute: HOME_PAGE.path,
    );
  }
}
