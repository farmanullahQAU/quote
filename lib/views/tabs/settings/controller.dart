import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/services/localization.dart';

class SettingsController extends GetxController {
  var themeMode = ThemeMode.system.obs; // Default to system theme
  void changeLanguage(String langCode, String countryCode) {
    LocalizationService().changeLocale(langCode, countryCode);
  }

  // Toggle theme mode
  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode); // Apply theme change globally
  }
}
