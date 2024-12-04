import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/tabs/settings/controller.dart';

class LanguageSettings extends StatelessWidget {
  final SettingsController controller = Get.find<SettingsController>();

  LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Language',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: LocalizationService.supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = LocalizationService.supportedLocales[index];
                  return RadioListTile(
                    selected: locale == Get.locale,
                    selectedTileColor: context.theme.colorScheme.surface,
                    title: Text(
                      _getLanguageName(locale.languageCode),
                      style: const TextStyle(fontSize: 18),
                    ),
                    value: locale,
                    groupValue: Get.locale,
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        controller.changeLanguage(
                          newLocale.languageCode,
                          newLocale.countryCode!,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'ar':
        return 'Arabic';
      case 'hi':
        return 'Hindi';
      // Add more languages as needed
      default:
        return languageCode; // Fallback to code if unknown
    }
  }
}
