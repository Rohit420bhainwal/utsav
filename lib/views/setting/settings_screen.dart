
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav/views/setting/settings_controller.dart';

import '../../utils/app_colors.dart';
import '../reportissue/report_issue_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const double _maxContentWidth = 1100;
  static const double _desktopBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop =
              constraints.maxWidth >= _desktopBreakpoint;

          final horizontalPadding = isDesktop ? 32.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              24,
              horizontalPadding,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _maxContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isDesktop),
                    const SizedBox(height: 28),

                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildSection(
                                  context,
                                  title: 'Legal',
                                  subtitle:
                                  'Your privacy and agreements',
                                  icon: Icons.shield_outlined,
                                  children: [
                                    _buildTile(
                                      context,
                                      icon: Icons.privacy_tip_outlined,
                                      title: 'Privacy Policy',
                                      subtitle:
                                      'Learn how your data is handled',
                                      onTap:
                                      controller.openPrivacyPolicy,
                                    ),
                                    _buildDivider(context),
                                    _buildTile(
                                      context,
                                      icon: Icons.description_outlined,
                                      title: 'Terms & Conditions',
                                      subtitle:
                                      'Read the terms of using Utsav',
                                      onTap: controller.openTerms,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildSection(
                                  context,
                                  title: 'More',
                                  subtitle: 'Help us improve Utsav',
                                  icon: Icons.more_horiz,
                                  children: [
                                    _buildTile(
                                      context,
                                      icon: Icons.star_border_rounded,
                                      title: 'Rate Us',
                                      subtitle:
                                      'Share your experience',
                                      onTap: controller.rateApp,
                                    ),
                                    _buildDivider(context),
                                    _buildTile(
                                      context,
                                      icon: Icons.share_outlined,
                                      title: 'Share App',
                                      subtitle:
                                      'Tell others about Utsav',
                                      onTap: controller.shareApp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                _buildSupportSection(
                                  context,
                                  controller,
                                ),
                                const SizedBox(height: 20),
                                _buildSection(
                                  context,
                                  title: 'Account',
                                  subtitle:
                                  'Manage your current session',
                                  icon: Icons.person_outline,
                                  children: [
                                    _buildTile(
                                      context,
                                      icon: Icons.logout_rounded,
                                      title: 'Logout',
                                      subtitle:
                                      'Sign out of your account',
                                      isDestructive: true,
                                      onTap: () =>
                                          _showLogoutDialog(controller),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildSection(
                            context,
                            title: 'Legal',
                            subtitle:
                            'Your privacy and agreements',
                            icon: Icons.shield_outlined,
                            children: [
                              _buildTile(
                                context,
                                icon: Icons.privacy_tip_outlined,
                                title: 'Privacy Policy',
                                subtitle:
                                'Learn how your data is handled',
                                onTap: controller.openPrivacyPolicy,
                              ),
                              _buildDivider(context),
                              _buildTile(
                                context,
                                icon: Icons.description_outlined,
                                title: 'Terms & Conditions',
                                subtitle:
                                'Read the terms of using Utsav',
                                onTap: controller.openTerms,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSupportSection(context, controller),
                          const SizedBox(height: 16),
                          _buildSection(
                            context,
                            title: 'More',
                            subtitle: 'Help us improve Utsav',
                            icon: Icons.more_horiz,
                            children: [
                              _buildTile(
                                context,
                                icon: Icons.star_border_rounded,
                                title: 'Rate Us',
                                subtitle: 'Share your experience',
                                onTap: controller.rateApp,
                              ),
                              _buildDivider(context),
                              _buildTile(
                                context,
                                icon: Icons.share_outlined,
                                title: 'Share App',
                                subtitle: 'Tell others about Utsav',
                                onTap: controller.shareApp,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            context,
                            title: 'Account',
                            subtitle:
                            'Manage your current session',
                            icon: Icons.person_outline,
                            children: [
                              _buildTile(
                                context,
                                icon: Icons.logout_rounded,
                                title: 'Logout',
                                subtitle:
                                'Sign out of your account',
                                isDestructive: true,
                                onTap: () =>
                                    _showLogoutDialog(controller),
                              ),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 32),

                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            size: 24,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Utsav',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'App Version 1.0.0',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isDesktop ? 60 : 52,
          height: isDesktop ? 60 : 52,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.settings_outlined,
            size: isDesktop ? 30 : 26,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: (isDesktop
                    ? theme.textTheme.headlineSmall
                    : theme.textTheme.titleLarge)
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your preferences and get help',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required List<Widget> children,
      }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.08 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 21,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.60),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSupportSection(
      BuildContext context,
      SettingController controller,
      ) {
    return _buildSection(
      context,
      title: 'Help & Support',
      subtitle: 'We are here to help you',
      icon: Icons.support_agent_outlined,
      children: [
        _buildTile(
          context,
          icon: Icons.support_agent_outlined,
          title: 'Contact Support',
          subtitle: 'Call, email or chat with us',
          onTap: () => _showSupportSheet(context, controller),
        ),
        _buildDivider(context),
        _buildTile(
          context,
          icon: Icons.report_problem_outlined,
          title: 'Report Issue',
          subtitle: 'Tell us about a problem',
          onTap: () => Get.to(() => ReportIssueScreen()),
        ),
      ],
    );
  }

  Widget _buildTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        String? subtitle,
        bool isDestructive = false,
      }) {
    final theme = Theme.of(context);
    final foreground = isDestructive
        ? Colors.red
        : theme.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (isDestructive
                      ? Colors.red
                      : theme.colorScheme.primary)
                      .withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: isDestructive
                      ? Colors.red
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.60),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 23,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 74,
      endIndent: 18,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
    );
  }

  void _showSupportSheet(
      BuildContext context,
      SettingController controller,
      ) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= _desktopBreakpoint;

    Get.bottomSheet(
      SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 480 : 600,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 22),
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Text(
                    'Reach Out to Us',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose how you would like to contact our team.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactOption(
                    context,
                    icon: Icons.call_outlined,
                    color: Colors.green,
                    title: 'Call Us',
                    subtitle: 'Speak to our support team',
                    onTap: () {
                      Get.back();
                      controller.contactCall();
                    },
                  ),
                  _buildContactOption(
                    context,
                    icon: Icons.email_outlined,
                    color: Colors.blue,
                    title: 'Email Us',
                    subtitle: 'Send us an email',
                    onTap: () {
                      Get.back();
                      controller.contactEmail();
                    },
                  ),
                  _buildContactOption(
                    context,
                    icon: Icons.chat_outlined,
                    color: Colors.green,
                    title: 'WhatsApp',
                    subtitle: 'Chat with us',
                    onTap: () {
                      Get.back();
                      controller.contactWhatsApp();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildContactOption(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(SettingController controller) {
    Get.dialog(
      AlertDialog(
        icon: const Icon(
          Icons.logout_rounded,
          color: Colors.red,
          size: 30,
        ),
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}