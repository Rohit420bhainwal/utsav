import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'message_controller.dart';

class MessageScreen extends StatelessWidget {
  final String serviceId;
  final String serviceTitle;
  final String vendorName;

  const MessageScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MessageController(
        serviceId: serviceId,
        serviceTitle: serviceTitle,
        vendorName: vendorName,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(vendorName),
        backgroundColor: Colors.black,
        elevation: 1,
      ),

      /// ✅ SCROLLABLE BODY (NO COLUMN)
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 📅 DATE PICKER
          Obx(() => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(
              controller.selectedDate.value == null
                  ? "Select Event Date"
                  : "${controller.selectedDate.value!.day}-${controller.selectedDate.value!.month}-${controller.selectedDate.value!.year}",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => controller.pickDate(context),
          )),

          const SizedBox(height: 10),

          /// 👥 GUEST COUNT
          TextField(
            controller: controller.guestCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Guest Count",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => controller.updateMessage(),
          ),

          const SizedBox(height: 10),

          /// 💰 BUDGET
          TextField(
            controller: controller.budgetController,
            decoration: InputDecoration(
              labelText: "Budget (optional)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => controller.updateMessage(),
          ),

          const SizedBox(height: 20),
        ],
      ),

      /// ✅ FIXED BOTTOM (BEST PRACTICE)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    minLines: 3,
                    maxLines: 6, // 🔥 increase this if you want more
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() => CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.secondary,
                  child: controller.isSending.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: controller.sendLead,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}