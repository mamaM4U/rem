import 'package:get/get.dart';
import 'package:shared/shared.dart';

import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService(ApiService());
  final AuthService _authService = AuthService(ApiService());

  final isLoading = true.obs;
  final homeData = Rxn<HomeData>();
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    errorMessage.value = null;

    final response = await _homeService.getHomeData();

    isLoading.value = false;

    if (response.success) {
      homeData.value = response.data;
    } else {
      errorMessage.value = response.message;
    }
  }

  Future<void> handleProfileOrLogin() async {
    final isAuthenticated = await _authService.isAuthenticated();

    if (isAuthenticated) {
      Get.toNamed('/profile');
    } else {
      Get.toNamed('/login');
    }
  }
}
