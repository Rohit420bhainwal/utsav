import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class LeadDetailController extends GetxController {

  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isSending = false.obs;

  var lead = {}.obs;
  var messages = <dynamic>[].obs; // 🔥 separate messages list

  final messageController = TextEditingController();

  String leadId = "";

  @override
  void onInit() {
    super.onInit();
    leadId = Get.arguments;
    fetchLeadDetails(leadId);
  }

  /// 🔥 FETCH DETAILS
  Future<void> fetchLeadDetails(String id) async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        "leads/$id",
        withAuth: true,
      );

      if (response["success"] == true) {
        lead.value = response["data"];

        /// ✅ IMPORTANT
        messages.value = response["data"]["messages"] ?? [];
      }

    } catch (e) {
      print("Lead detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 SEND MESSAGE (OPTIMIZED)
  Future<void> sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty || isSending.value) return;

    /// 🔥 INSTANT UI UPDATE (like WhatsApp)
    final tempMessage = {
      "sender": "customer",
      "text": text,
      "createdAt": DateTime.now().toIso8601String(),
    };

    messages.add(tempMessage);
    messageController.clear();

    try {
      isSending.value = true;

      await _apiService.post(
        "leads/$leadId/message",
        {"text": text},
        withAuth: true,
      );

      /// OPTIONAL: You can refresh in background if needed
      // fetchLeadDetails(leadId);

    } catch (e) {
      print("Message send error: $e");

      /// ❌ ROLLBACK IF FAILED
      messages.remove(tempMessage);

    } finally {
      isSending.value = false;
    }
  }

  /// 🔥 IMAGE URL
  String getImageUrl(String path) {
    return _apiService.getImageUrl(path);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}