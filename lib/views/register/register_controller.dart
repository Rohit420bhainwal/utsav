import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final ApiService _apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register({
    required String name,
    required String mobile,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        "auth/register",
        {
          "name": name,
          "phone": mobile,
          "email": email,
          "password": password,
          "role": "customer"
        },
        withAuth: false,
      );

      if (response["success"] == true) {
        Get.snackbar("OTP Sent", "Check your email for OTP");

        /// ✅ GO TO VERIFY OTP SCREEN
        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {
            "email": email,
            "fromRegister": true, // 🔥 IMPORTANT FLAG
          },
        );
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }
}
