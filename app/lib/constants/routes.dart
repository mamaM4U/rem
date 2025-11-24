// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:arona/modules/homepage/pages/home_page.dart';

typedef GetPageBuilder = Widget Function();

Route HOME_PAGE = Route(path: '/home', page: () => HomePage());

class Route {
  final String path;
  final GetPageBuilder page;
  final String basePath;

  Route({
    required this.path,
    required this.page,
  }) : basePath = getBasePath(path);

  static String getBasePath(String path) {
    List listPath = path.split('/:');
    return listPath[0];
  }
}
