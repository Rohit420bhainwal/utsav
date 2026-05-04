import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

class VerifyOtpController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();

  Future<void> verifyOtp(String email) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "Please enter OTP");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        "auth/verify-otp",
        {
          "email": email,
          "otp": otp,
        },
        withAuth: true,
      );

      if (response["success"] == true) {
        Get.snackbar("Success", "Account verified");

        /// 🔥 CHECK WHERE USER CAME FROM
        final fromRegister = Get.arguments["fromRegister"] ?? false;

        if (fromRegister) {
          /// ✅ GO TO LOGIN SCREEN
          Get.offAllNamed(AppRoutes.login);
        } else {
          /// ✅ LOGIN FLOW
          await SecureStorageService.saveToken(response["token"]);
          Get.offAllNamed(AppRoutes.dashboard);
        }
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Verification failed");
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