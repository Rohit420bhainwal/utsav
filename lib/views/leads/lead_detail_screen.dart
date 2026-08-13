import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/message_input_bar.dart';
import 'lead_detail_controller.dart';

class LeadDetailScreen extends StatelessWidget {
  LeadDetailScreen({super.key});

  final LeadDetailController controller = Get.put(LeadDetailController());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,


      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          "Lead Details",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.surface),
      ),

      /// 🔥 MAIN BODY WITH SAFE SCROLL
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final lead = controller.lead.value;
        if (lead.isEmpty) {
          return const Center(child: Text("No Data"));
        }

        final service = lead["service"] ?? {};
        final event = lead["eventDetails"] ?? {};
        final serviceDetails = service["serviceId"] ?? {};
        final images = serviceDetails["images"] ?? [];
        final messages = controller.messages;
        final status = lead["status"];
        final eventDate = event["eventDate"]?.toString() ?? "";
        print("eventDate: ${event["eventDate"]}");
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 IMAGES
                  if (images.isNotEmpty)
                    _buildCard(
                      child: SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final imageUrl =
                            controller.getImageUrl(images[index]);

                            return Container(
                              width: 240,
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  /// 🔥 SERVICE
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          service["title"] ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${service["categoryName"] ?? ""} • ${service["city"] ?? ""}",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 EVENT
                  _buildCard(
                    child: Column(
                      children: [
                        _buildRow(
                          Icons.event,
                          eventDate.length >= 10
                              ? eventDate.substring(0, 10)
                              : "Not Available",
                        ),
                        const SizedBox(height: 8),
                        _buildRow(
                          Icons.people,
                          "${event["guestCount"] ?? 0} guests",
                        ),
                        const SizedBox(height: 8),
                        _buildRow(
                          Icons.currency_rupee,
                          event["budget"] ?? "",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 TRACKING
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Inquiry Tracking",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        _buildTrackRow(
                          icon: Icons.flag,
                          title: "Status",
                          value: (status ?? "new").toUpperCase(),
                          valueColor: _getStatusColor(status),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 ⭐ REVIEW (ONLY CLOSED)
                  if (status == "closed")
                    _buildReviewSection(),

                  /// 🔥 CHAT
                  /*if (status != "closed") ...[
                    const SizedBox(height: 10),
                    Text("Conversation",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg["sender"] == "customer";

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? AppColors.primary
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg["text"] ?? "",
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],*/
                ],
              ),
            );
          },
        );
      }),

      /*bottomNavigationBar: Obx(() {
        final status = controller.lead.value["status"];

        if (status == "closed") {
          return const SizedBox();
        }

        return MessageInputBar(
          controller: controller.messageController,
          onSend: controller.sendMessage,
        );
      }),*/

     /* /// 🔥 INPUT FIXED (KEYBOARD SAFE)
      bottomNavigationBar: Obx(() {
        final status = controller.lead.value["status"];
        if (status == "closed") return const SizedBox();

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 🔥 KEY FIX
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [

                  /// 🔹 INPUT
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller.messageController,
                        minLines: 1,
                        maxLines: 4,
                        cursorColor: AppColors.primary,
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// 🔹 SEND BUTTON
                  GestureDetector(
                    onTap: controller.sendMessage,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),*/
    );
  }

  /// 🔥 REVIEW UI
  Widget _buildReviewSection() {
    return Obx(() {
      final hasReview = controller.userReview.value != null;

      if (hasReview) {
        final review = controller.userReview.value!;
        return _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Review",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review["rating"]
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(review["review"] ?? ""),
            ],
          ),
        );
      }

      return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rate this service",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () =>
                  controller.selectedRating.value = i + 1,
                  child: Icon(
                    i < controller.selectedRating.value
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            TextField(
              maxLines: 3,
              maxLength: 100,
              onChanged: (val) =>
              controller.reviewText.value = val,
              decoration: InputDecoration(
                hintText: "Write your review...",
                  counterText: null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: controller.submitReview,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildTrackRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(title)),
        Text(
          value,
          style: TextStyle(color: valueColor),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "closed":
        return Colors.red;
      case "converted":
        return Colors.green;
      case "contacted":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}