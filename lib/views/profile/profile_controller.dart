import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;
  final customer = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ================= FETCH PROFILE =================
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
      await _apiService.get("customer/profile", withAuth: true);

      if (response["success"] == true) {
        customer.value = response["customer"];
      } else {
        errorMessage.value = "Failed to load profile";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PICK & UPDATE IMAGE =================
  Future<void> pickAndUpdateImage() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      isLoading.value = true;

      final response = await _apiService.multipartPut(
        "customer/profile",
        fields: {}, // no text update
        files: [File(pickedFile.path)],
        fileKey: "avatar",
      );

      if (response["success"] == true) {
        await fetchProfile(); // refresh UI
        Get.snackbar("Success", "Profile image updated");
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}