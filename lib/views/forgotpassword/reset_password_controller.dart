import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value =
    !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
    !isConfirmPasswordVisible.value;
  }

  Future<void> resetPassword(String email) async {
    final password = passwordController.text.trim();
    final confirmPassword =
    confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter both passwords",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        "Invalid Password",
        "Password must be at least 8 characters",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Password Mismatch",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        "auth/reset-password",
        {
          "email": email,
          "newPassword": password,
        },
        withAuth: false,
      );

      print("Reset password response: $response");

      if (response["success"] == true) {
        Get.snackbar(
          "Success",
          "Password reset successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );

        // Go back to login and clear reset screens
        Get.offAllNamed(
          AppRoutes.login,
        );
      } else {
        Get.snackbar(
          "Error",
          response["message"] ??
              "Failed to reset password",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Reset password error: $e");

      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}