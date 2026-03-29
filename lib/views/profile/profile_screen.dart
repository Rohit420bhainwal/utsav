import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../services/api_service.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String getImageUrl(String path) {
    return "${ApiService.baseUrl.replaceAll('/api/v1', '')}/$path"
        .replaceAll("\\", "/");
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          "Profile",
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.customer.value == null) {
              return const SizedBox();
            }
            return IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updated = await Get.toNamed(
                  AppRoutes.editProfile,
                  arguments: controller.customer.value,
                );

                if (updated != null) {
                  controller.fetchProfile();
                }
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style:
              textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          );
        }

        final data = controller.customer.value;
        if (data == null) return const SizedBox();

        final avatar = data["avatar"];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ================= PROFILE IMAGE =================
              Stack(
                alignment: Alignment.center,
                children: [
                  /// 🔍 IMAGE CLICK → FULL SCREEN
                  GestureDetector(
                    onTap: () {
                      if (avatar != null && avatar.isNotEmpty) {
                        Get.to(() => Scaffold(
                          backgroundColor: Colors.black,
                          appBar: AppBar(
                            backgroundColor: Colors.black,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          body: Center(
                            child: InteractiveViewer(
                              child: Image.network(getImageUrl(avatar)),
                            ),
                          ),
                        ));
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: (avatar != null && avatar.toString().isNotEmpty)
                          ? NetworkImage(getImageUrl(avatar))
                          : null,
                      child: (avatar == null || avatar.toString().isEmpty)
                          ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      )
                          : null,
                    ),
                  ),

                  /// 📷 CAMERA ICON → PICK IMAGE
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.pickAndUpdateImage(); // ✅ upload image
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ================= NAME =================
              Text(
                data["name"] ?? "",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              /// ================= EMAIL =================
              Text(
                data["email"] ?? "",
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              /// ================= CARD =================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text("Role"),
                      subtitle: Text(data["role"] ?? "-"),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading:
                      const Icon(Icons.verified_user_outlined),
                      title: const Text("Status"),
                      subtitle: Text(
                        data["isActive"] == true
                            ? "Active"
                            : "Inactive",
                      ),
                    ),

                    if (data["phone"] != null &&
                        data["phone"].toString().isNotEmpty) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading:
                        const Icon(Icons.phone_outlined),
                        title: const Text("Phone"),
                        subtitle: Text(data["phone"]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}