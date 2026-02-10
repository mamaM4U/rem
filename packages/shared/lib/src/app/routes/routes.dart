import 'package:get/get.dart';

import '../constants/routes.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';

List<GetPage> routes = [
  GetPage(
    name: HOME_PAGE.path,
    page: () => HOME_PAGE.page(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: LOGIN_PAGE.path,
    page: () => LOGIN_PAGE.page(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: REGISTER_PAGE.path,
    page: () => REGISTER_PAGE.page(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: PROFILE_PAGE.path,
    page: () => PROFILE_PAGE.page(),
    binding: ProfileBinding(),
  ),
];

List<GetPage> pages() {
  return routes;
}
