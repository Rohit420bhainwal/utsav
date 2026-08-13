import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class EditProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final isUpdating = false.obs;
  final hasChanges = false.obs;

  late Map<String, dynamic> customer;

  late String originalName;
  late String originalEmail;
  late String originalPhone;

  @override
  void onInit() {
    super.onInit();

    customer = Get.arguments as Map<String, dynamic>;

    originalName = customer["name"] ?? "";
    originalEmail = customer["email"] ?? "";
    originalPhone = customer["phone"] ?? "";

    nameController.text = originalName;
    emailController.text = originalEmail;
    phoneController.text = originalPhone;

    /// Listen for changes
    nameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);

    /// Initial validation
    _checkForChanges();
  }

  bool get isFormValid {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    // Name validation
    if (name.isEmpty) {
      return false;
    }

    // Email validation
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      return false;
    }

    // Phone validation
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return false;
    }

    return true;
  }

  void _checkForChanges() {
    final hasValueChanged =
        nameController.text.trim() != originalName ||
            emailController.text.trim() != originalEmail ||
            phoneController.text.trim() != originalPhone;

    hasChanges.value = hasValueChanged && isFormValid;
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;

      final response = await _apiService.put(
        "customer/profile",
        {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
        },
        withAuth: true,
      );

      if (response["success"] == true) {
        Get.back(result: response["customer"]);
      } else {
        Get.snackbar("Error", "Profile update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}