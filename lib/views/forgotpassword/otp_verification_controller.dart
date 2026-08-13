import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import 'reset_password_screen.dart';

class OtpVerificationController extends GetxController {
  final ApiService _apiService = ApiService();

  final otpController = TextEditingController();

  final isLoading = false.obs;

  Future<void> verifyOtp(String email) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter OTP",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        "Invalid OTP",
        "Please enter a valid 6 digit OTP",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        "auth/verify-forgot-password-otp",
        {
          "email": email,
          "otp": otp,
        },
        withAuth: false,
      );

      print("Verify OTP response: $response");

      if (response["success"] == true) {
        Get.snackbar(
          "Success",
          "OTP verified successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(
              () => ResetPasswordScreen(
            email: email,
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          response["message"] ?? "Invalid OTP",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Verify OTP error: $e");

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
    otpController.dispose();
    super.onClose();
  }
}