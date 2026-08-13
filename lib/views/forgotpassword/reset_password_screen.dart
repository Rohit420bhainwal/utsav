import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  ResetPasswordScreen({
    super.key,
    required this.email,
  });

  final ResetPasswordController controller =
  Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            Icon(
              Icons.lock_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "Create New Password",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Enter a new password for your account.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            Obx(
                  () => TextFormField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                    controller.togglePasswordVisibility,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
                  () => TextFormField(
                controller:
                controller.confirmPasswordController,
                obscureText:
                !controller.isConfirmPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon:
                  const Icon(Icons.lock_outline),
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller
                        .toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Obx(
                  () => SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.resetPassword(email),
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
                      : const Text("RESET PASSWORD"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}