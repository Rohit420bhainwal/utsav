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
    print("serviceId: $serviceId");
    messageController = TextEditingController(
      text: "Hi $vendorName,\n"
          "I'm interested in booking your $serviceTitle "
         /* "for my event on 10-12-2026. "*/
          "Could you confirm availability and share more details along with a quotation?",
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      selectedDate.value = picked;

      // Update message dynamically
      updateMessage();
    }
  }

  void updateMessage() {
    final date = selectedDate.value != null
        ? "${selectedDate.value!.day}-${selectedDate.value!.month}-${selectedDate.value!.year}"
        : "TBD";

    final guests = guestCountController.text.isEmpty
        ? "TBD"
        : guestCountController.text;

    final budget = budgetController.text.isEmpty
        ? "Not decided"
        : budgetController.text;

    messageController.text =
    "Hi $vendorName,\n"
        "I'm interested in booking your $serviceTitle "
        "for my event on $date.\n"
        "Guest Count: $guests\n"
        "Budget: $budget\n"
        "Please share details and quotation.";
  }

  Future<void> sendLead() async {
    try {
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
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Success"),
            content: const Text(
              "Your query has been sent successfully.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog
                  Get.back(); // close message screen
                },
                child: const Text("OK"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
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
}
