import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class MessageController extends GetxController {
  final ApiService _apiService = ApiService();

  final String serviceId;
  final String serviceTitle;
  final String vendorName;

  MessageController({
    required this.serviceId,
    required this.serviceTitle,
    required this.vendorName,
  });

  var isSending = false.obs;

  late TextEditingController messageController;
  var selectedDate = Rxn<DateTime>();

  var guestCountController = TextEditingController();
  var budgetController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    messageController = TextEditingController();
    updateMessage();
  }

  /// 📅 Pick Date
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDate.value = picked;
      updateMessage();
    }
  }

  /// 🔄 Update Message Preview
  void updateMessage() {
    final date = selectedDate.value != null
        ? "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}"
        : "Not decided yet";

    final guests = guestCountController.text.isEmpty
        ? "Not decided"
        : guestCountController.text;

    final budget = budgetController.text.isEmpty
        ? "Flexible"
        : budgetController.text;

    messageController.text =
    "Hi,\n\n"
        "I’m interested in your *$serviceTitle* service.\n\n"
        "📅 Event Date: $date\n"
        "👥 Guests: $guests\n"
        "💰 Budget: $budget\n\n"
        "Please share availability and quotation.\n\n"
        "Thanks!";
  }

  /// 🚀 Send Lead
  Future<void> sendLead() async {
    try {
      /// 🔴 BASIC VALIDATION
      if (guestCountController.text.isEmpty) {
        Get.snackbar("Required", "Please enter guest count");
        return;
      }

      isSending.value = true;

      final body = {
        "serviceId": serviceId,
        "eventType": "wedding",
        "eventDate": selectedDate.value?.toIso8601String(),
        "guestCount": int.tryParse(guestCountController.text) ?? 0,
        "budget": budgetController.text,
        "city": "Pune",
        "message": messageController.text,
      };

      final response = await _apiService.post(
        "leads",
        body,
        withAuth: true,
      );

      if (response["success"] == true) {
        _showSuccessBottomSheet();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send inquiry",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  /// ✅ SUCCESS UI (PREMIUM)
  void _showSuccessBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Icon(Icons.check_circle, color: Colors.green, size: 60),

            const SizedBox(height: 12),

            const Text(
              "Inquiry Sent Successfully 🎉",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Our team will contact you shortly.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // close sheet
                  Get.back(); // close screen
                },
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
    );
  }
}