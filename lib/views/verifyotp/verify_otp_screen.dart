import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/verifyotp/verify_otp_controller.dart';


class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final controller = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments["email"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              "Enter OTP sent to",
              style: TextStyle(fontSize: 16),
            ),

            Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.verifyOtp(email),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify"),
              ),
            )),
          ],
        ),
      ),
    );
  }
}