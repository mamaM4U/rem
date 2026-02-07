import 'package:get/get.dart';
import 'package:shared/shared.dart';

import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService = UserService(ApiService());
  final AuthService _authService = AuthService(ApiService());

  final isLoading = true.obs;
  final user = Rxn<User>();
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    errorMessage.value = null;

    final response = await _userService.getUserProfile();

    isLoading.value = false;

    if (response.success) {
      user.value = response.data;
    } else {
      errorMessage.value = response.message;
    }
  }

  Future<void> handleLogout() async {
    await _authService.logout();
    Get.offAllNamed('/home');
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
