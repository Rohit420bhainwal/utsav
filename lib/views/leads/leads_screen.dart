import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/leads/lead_detail_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/date_utils.dart';
import 'leads_controller.dart';

class LeadsScreen extends StatelessWidget {
  LeadsScreen({super.key});

  final LeadsController controller = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "My Leads",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.leads.isEmpty) {
          return const Center(child: Text("No Leads Yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.leads.length,
          itemBuilder: (context, index) {
            final lead = controller.leads[index];

            final service = lead["service"] ?? {};
            final event = lead["eventDetails"] ?? {};

            /// ✅ VENDOR DATA (UPDATED)
            final vendor = lead["vendorId"] ?? {};
            final vendorUser = vendor["userId"] ?? {};

            final vendorName = vendorUser["name"] ?? "Unknown Vendor";
            final businessName = vendor["businessName"] ?? "";

            final title = service["title"] ?? "No Title";
            final category = service["categoryName"] ?? "";
            final city = service["city"] ?? "";

            final eventDateRaw = event["eventDate"];
            final eventDate = DateUtilsHelper.formatDate(eventDateRaw);


            final guestCount = event["guestCount"]?.toString() ?? "0";
            final budget = event["budget"]?.toString() ?? "-";

            final message = lead["message"] ?? "No message";
            final status =
            (lead["status"] ?? "new").toString().toUpperCase();

            final createdAtRaw = lead["createdAt"];
            final createdAt = DateUtilsHelper.formatDate(createdAtRaw);


            return GestureDetector(
              onTap: () {
                Get.to(() => LeadDetailScreen(),
                    arguments: lead["_id"]);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 VENDOR NAME (UPDATED UI)
                    Row(
                        children: [
                          const Icon(Icons.account_circle, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            vendorName,
                            style: textTheme.titleSmall,
                          ),
                        ]

                    ),
                    Row(
                        children: [
                          const Icon(Icons.business, size: 18),
                          const SizedBox(width: 6),
                          /// 🔥 BUSINESS NAME
                          if (businessName.isNotEmpty)
                            Text(
                              businessName,
                              style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,color: AppColors.secondary
                              ),
                            )
                        ]

                    ),

                    const SizedBox(height: 6),

                    /// SERVICE TITLE
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "$category • $city",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// EVENT DETAILS
                    Row(
                      children: [
                        const Icon(Icons.event, size: 18),
                        const SizedBox(width: 6),
                        Text(eventDate),

                        const SizedBox(width: 16),

                        const Icon(Icons.people, size: 18),
                        const SizedBox(width: 6),
                        Text("$guestCount guests"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.currency_rupee, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          controller.formatBudget(budget),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /*/// MESSAGE
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),*/

                    /// STATUS + DATE
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status)
                                .withOpacity(0.1),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          createdAt,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// 🔥 STATUS COLOR
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "closed":
        return Colors.grey;
      case "converted":
        return Colors.green;
      case "contacted":
        return Colors.orange;
      case "new":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}