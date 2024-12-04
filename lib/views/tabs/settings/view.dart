// Import other settings pages as needed

// Import other settings pages as needed

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/views/tabs/home/controller.dart';
import 'package:myapp/views/tabs/settings/controller.dart';
import 'package:myapp/views/tabs/settings/notifications/view.dart';
import 'package:myapp/views/tabs/settings/reminders/view.dart';

import 'languages_settings.dart/view.dart';
import 'themes/view.dart';
// Import other settings pages as needed

class SettingsPage extends StatelessWidget {
  final controller = Get.find<SettingsController>();
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // General Settings Section
          _buildSettingsSection(
            context,
            title: LocaleKeys.general_settings.tr,
            items: [
              _buildSettingsItem(
                context,
                title: LocaleKeys.title_language.tr,
                icon: Icons.language,
                onTap: () {
                  Get.to(() => LanguageSettings());
                },
              ),
              _buildSettingsItem(
                context,
                title: LocaleKeys.theme.tr,
                icon: Icons.brightness_6,
                onTap: () {
                  // Navigate to Theme Settings page
                  Get.to(() => ThemeSettingsPage());
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications Section
          _buildSettingsSection(
            context,
            title: LocaleKeys.notifications.tr,
            items: [
              _buildSettingsItem(context,
                  title: LocaleKeys.manage_notifications.tr,
                  icon: Icons.notifications,
                  onTap: scheduleTestNotification),
              _buildSettingsItem(
                context,
                title: LocaleKeys.sound_settings.tr,
                icon: Icons.volume_up,
                onTap: () {
                  Get.to(() => QuoteReminderScreen());
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Privacy Section
          _buildSettingsSection(
            context,
            title: LocaleKeys.privacy.tr,
            items: [
              _buildSettingsItem(
                context,
                title: LocaleKeys.privacy_policy.tr,
                icon: Icons.privacy_tip,
                onTap: () {
                  // Get.to(() => const PrivacyPolicyPage());
                },
              ),
              _buildSettingsItem(
                context,
                title: LocaleKeys.data_protection.tr,
                icon: Icons.lock,
                onTap: () {
                  // Navigate to Data Protection page
                  // Get.to(() => const DataProtectionPage());
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // About Section
          _buildSettingsSection(
            context,
            title: LocaleKeys.about.tr,
            items: [
              _buildSettingsItem(
                context,
                title: LocaleKeys.about_app.tr,
                icon: Icons.info,
                onTap: () {
                  // Get.to(() => const AboutAppPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void scheduleTestNotification() async {
    Get.to(() => QuoteNotificationSettingsScreen(),
        arguments: Get.find<HomeController>().quotes);
  }

  Widget _buildSettingsSection(BuildContext context,
      {required String title, required List<Widget> items}) {
    return Card(
      color: context.theme.colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      // contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
