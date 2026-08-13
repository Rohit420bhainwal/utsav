import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  final emailController = TextEditingController();

  final isLoading = false.obs;
  final isEmailValid = false.obs;

  void validateEmail(String value) {
    isEmailValid.value = GetUtils.isEmail(value.trim());
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        "auth/forgot-password",
        {
          "email": email,
        },
        withAuth: false,
      );

      print("Forgot password response: $response");

      if (response["success"] == true) {
        Get.snackbar(
          "Success",
          "OTP sent to your email",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(
              () => OtpVerificationScreen(
            email: email,
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          response["message"] ?? "Failed to send OTP",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Forgot password error: $e");

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
    emailController.dispose();
    super.onClose();
  }
}