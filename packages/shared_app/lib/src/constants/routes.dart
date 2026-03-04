// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/views/profile_view.dart';

typedef GetPageBuilder = Widget Function();

// Home Route
AppRoute HOME_PAGE = AppRoute(path: '/home', page: () => const HomeView());

// Auth Routes
AppRoute LOGIN_PAGE = AppRoute(path: '/login', page: () => const LoginView());
AppRoute REGISTER_PAGE = AppRoute(path: '/register', page: () => const RegisterView());

// Profile Route
AppRoute PROFILE_PAGE = AppRoute(path: '/profile', page: () => const ProfileView());

class AppRoute {
  final String path;
  final GetPageBuilder page;
  final String basePath;

  AppRoute({required this.path, required this.page}) : basePath = getBasePath(path);

  static String getBasePath(String path) {
    List listPath = path.split('/:');
    return listPath[0];
  }
}
