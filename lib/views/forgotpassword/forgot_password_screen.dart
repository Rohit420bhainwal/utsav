import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller =
  Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            Icon(
              Icons.lock_reset,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "Forgot Password?",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Enter your registered email address and we will send you an OTP to reset your password.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 40),

            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email_outlined),
                border: UnderlineInputBorder(),
              ),
              onChanged: controller.validateEmail,
            ),

            const SizedBox(height: 32),

            Obx(
                  () => SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.sendOtp,
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
                      : const Text("SEND OTP"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}