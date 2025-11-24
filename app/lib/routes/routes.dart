import 'package:get/get.dart';
import 'package:arona/constants/routes.dart';

List<GetPage> routes = [
  GetPage(
    name: HOME_PAGE.path,
    page: () => HOME_PAGE.page(),
  ),
];

List<GetPage> pages() {
  return routes;
}
