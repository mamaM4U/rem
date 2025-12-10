import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService(ApiService());

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
    // Reset form keys to avoid GlobalKey conflicts
    loginFormKey = GlobalKey<FormState>();
    registerFormKey = GlobalKey<FormState>();
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    final response = await _authService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (response.success) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Login Failed',
        response.message ?? 'Login failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    final response = await _authService.register(
      email: emailController.text.trim(),
      name: nameController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (response.success) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Registration Failed',
        response.message ?? 'Registration failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
