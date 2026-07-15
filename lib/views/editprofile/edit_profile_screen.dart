import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        title:  Text("Edit Profile",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              /// NAME
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) =>
                v == null || v.trim().isEmpty ? "Name is required" : null,
              ),

              const SizedBox(height: 16),

              /// EMAIL
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Email is required";
                  }
                  if (!GetUtils.isEmail(v.trim())) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// PHONE
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Phone number is required";
                  }
                  if (v.trim().length < 10) {
                    return "Enter valid phone number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              /// SAVE BUTTON
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                    controller.hasChanges.value &&
                        !controller.isUpdating.value
                        ? controller.updateProfile
                        : null,
                    child: controller.isUpdating.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Save Changes"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
