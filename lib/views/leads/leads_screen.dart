import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/leads/lead_detail_screen.dart';
import '../../utils/app_colors.dart';
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
          "My leads",
          style: textTheme.titleLarge?.copyWith(color: AppColors.surface,fontWeight: FontWeight.w600), // Inter font
        ),
        centerTitle: true,
      ),

      body: Obx(() {

        if(controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(controller.leads.isEmpty) {
          return const Center(
            child: Text("No Leads Yet"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.leads.length,
          itemBuilder: (context, index) {

            final lead = controller.leads[index];

            final service = lead["service"];
            final event = lead["eventDetails"];

            return GestureDetector(
              onTap: () {
                Get.to(() => LeadDetailScreen(), arguments: lead["_id"]);
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

                    /// SERVICE TITLE
                    Text(
                      service["title"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${service["categoryName"]} • ${service["city"]}",
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

                        Text(
                          event["eventDate"].toString().substring(0,10),
                        ),

                        const SizedBox(width: 16),

                        const Icon(Icons.people, size: 18),
                        const SizedBox(width: 6),

                        Text("${event["guestCount"]} guests"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [

                        const Icon(Icons.currency_rupee, size: 18),
                        const SizedBox(width: 6),

                        Text(event["budget"]),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// MESSAGE
                    Text(
                      lead["message"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// STATUS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            lead["status"].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          lead["createdAt"].toString().substring(0,10),
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
}