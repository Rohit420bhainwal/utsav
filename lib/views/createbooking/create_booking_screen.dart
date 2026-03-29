import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CreateBookingScreen extends StatelessWidget {
  const CreateBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Booking",
          style: textTheme.titleLarge?.copyWith(color: AppColors.surface,fontWeight: FontWeight.w600), // Inter font
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking Details",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                hintText: "Event name",
              ),
            ),

            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(
                hintText: "Select date",
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              readOnly: true,
            ),

            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(
                hintText: "Select time",
                suffixIcon: Icon(Icons.access_time_outlined),
              ),
              readOnly: true,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // API call later
                },
                child: const Text("Create Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
