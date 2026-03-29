import 'package:get/get.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

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

      // TODO: Replace with real API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar('Success', 'Registration successful');
      // Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }
}
