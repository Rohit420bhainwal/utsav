import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class LeadDetailController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isSending = false.obs;
  var isSubmittingReview = false.obs;

  var lead = {}.obs;
  var messages = <dynamic>[].obs;

  /// 🔥 REVIEW
  var userReview = Rxn<Map>();
  var selectedRating = 0.0.obs;
  var reviewText = "".obs;

  final messageController = TextEditingController();

  String leadId = "";

  @override
  void onInit() {
    super.onInit();
    leadId = Get.arguments?.toString() ?? "";
    fetchLeadDetails(leadId);
    fetchUserReview();
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
        messages.value = response["data"]["messages"] ?? [];
      }
    } catch (e) {
      print("Lead detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 FETCH REVIEW
  Future<void> fetchUserReview() async {
    try {
      final res = await _apiService.get(
        "reviews/lead/$leadId",
        withAuth: true,
      );

      if (res["success"] == true) {
        if (res["hasReview"] == true) {
          userReview.value = res["data"];
        } else {
          userReview.value = null;
        }
      }
    } catch (e) {
      print("Review fetch error: $e");
    }
  }

  Future<void> submitReview() async {
    final review = reviewText.value.trim();

    /// 🔥 Validate rating
    if (selectedRating.value == 0) {
      Get.dialog(
        AlertDialog(
          title: const Text("Rating Required"),
          content: const Text(
            "Please select a star rating before submitting your review.",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      return;
    }

    /// 🔥 Validate review
    if (review.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text("Review Required"),
          content: const Text(
            "Please write a review before submitting. "
                "Share a few words about your experience.",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      return;
    }

    try {
      isSubmittingReview.value = true;

      final res = await _apiService.post(
        "reviews",
        {
          "leadId": leadId,
          "rating": selectedRating.value.toInt(),
          "review": review,
        },
        withAuth: true,
      );

      if (res["success"] == true) {
        userReview.value = res["data"];

        Get.snackbar(
          "Success",
          "Review submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Submit review error: $e");
    } finally {
      isSubmittingReview.value = false;
    }
  }

  // /// 🔥 SUBMIT REVIEW
  // Future<void> submitReview() async {
  //   try {
  //     isSubmittingReview.value = true;
  //
  //     final res = await _apiService.post(
  //       "reviews",
  //       {
  //         "leadId": leadId,
  //         "rating": selectedRating.value.toInt(),
  //         "review": reviewText.value,
  //       },
  //       withAuth: true,
  //     );
  //
  //     if (res["success"] == true) {
  //       userReview.value = res["data"];
  //       Get.snackbar("Success", "Review submitted");
  //     }
  //   } catch (e) {
  //     print("Submit review error: $e");
  //   } finally {
  //     isSubmittingReview.value = false;
  //   }
  // }

  /// 🔥 SEND MESSAGE
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

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
    } catch (e) {
      messages.remove(tempMessage);
    } finally {
      isSending.value = false;
    }
  }

  String getImageUrl(String path) {
    return _apiService.getImageUrl(path);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      final dt = DateTime.parse(date);
      return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}";
    } catch (e) {
      return "-";
    }
  }
}