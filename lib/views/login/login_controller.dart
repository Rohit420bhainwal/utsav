import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final ApiService _apiService = ApiService();
  final box = GetStorage();

  // ============================================================
  // 🔐 PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ============================================================
  // 🔑 FORGOT PASSWORD
  // ============================================================

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
    // Get.snackbar(
    //   'Forgot Password',
    //   'Password reset feature is coming soon.',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 3),
    // );
  }

  // ============================================================
  // 🔐 LOGIN
  // ============================================================

  Future<void> login(
      String email,
      String password,
      ) async {
    // ------------------------------------------------------------
    // Validation
    // ------------------------------------------------------------

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "email": email.trim(),
        "password": password.trim(),
        "appType": "customer",
      };

      final response = await _apiService.post(
        "auth/login",
        body,
        withAuth: false,
      );

      print("Login response: $response");

      // ------------------------------------------------------------
      // SUCCESS
      // ------------------------------------------------------------

      if (response["success"] == true) {
        final data = response["data"];

        await SecureStorageService.saveToken(
          data["token"],
        );

        await box.write(
          "userProfile",
          data["user"],
        );

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(
          const Duration(seconds: 1),
        );

        Get.offAllNamed(
          AppRoutes.dashboard,
        );
      }

      // ------------------------------------------------------------
      // API ERROR
      // ------------------------------------------------------------

      else {
        final message =
            response["message"] ?? "Login failed";

        Get.snackbar(
          'Error',
          message.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Login error: $e");

      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}