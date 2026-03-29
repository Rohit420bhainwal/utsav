import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/setting/settings_controller.dart';
import '../../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 🔔 Notifications Card
          _settingsCard(
            children: [
              Obx(() => _tile(
                icon: Icons.notifications_outlined,
                title: "Enable Notifications",
                trailing: Switch(
                  value: controller.isNotificationEnabled.value,
                  onChanged: controller.toggleNotification,
                ),
              )),
            ],
          ),

          /// ⚙️ Preferences Card
          _settingsCard(
            children: [
              Obx(() => _tile(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                trailing: Switch(
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleTheme,
                ),
              )),
              _divider(),
              _tile(
                icon: Icons.language_outlined,
                title: "Language",
                subtitle: "English",
                onTap: () {},
              ),
            ],
          ),

          /// 🛡️ Legal Card
          _settingsCard(
            children: [
              _tile(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: controller.openPrivacyPolicy,
              ),
              _divider(),
              _tile(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                onTap: controller.openTerms,
              ),
            ],
          ),

          /// 💬 Support Card
          _settingsCard(
            children: [
              _tile(
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.support_agent_outlined,
                title: "Contact Us",
                onTap: () {},
              ),
              _divider(),
              _tile(
                icon: Icons.report_problem_outlined,
                title: "Report Issue",
                onTap: () {},
              ),
            ],
          ),

          /// ⭐ More Card
          _settingsCard(
            children: [
              _tile(
                icon: Icons.star_border,
                title: "Rate Us",
                onTap: controller.rateApp,
              ),
              _divider(),
              _tile(
                icon: Icons.share_outlined,
                title: "Share App",
                onTap: controller.shareApp,
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🚪 Logout Card
          _settingsCard(
            children: [
              _tile(
                icon: Icons.logout,
                title: "Logout",
                isDestructive: true,
                onTap: () => _showLogoutDialog(controller),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              "App Version 1.0.0",
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Card Container
  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /// 🔹 Tile
  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1);

  void _showLogoutDialog(SettingController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}