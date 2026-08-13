import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;

  OtpVerificationScreen({
    super.key,
    required this.email,
  });

  final OtpVerificationController controller =
  Get.put(OtpVerificationController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Icon(
              Icons.mark_email_read_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "Verify OTP",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Enter the OTP sent to",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 5),

            Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            TextFormField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: "OTP",
                counterText: "",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOtp(email),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("VERIFY OTP"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Change Email"),
            ),
          ],
        ),
      ),
    );
  }
}