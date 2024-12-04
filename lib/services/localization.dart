import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

// class LocalizationService {
//   static final supportedLocales = [
//     const Locale('en', 'US'),
//     const Locale('ur', 'PK'),
//     const Locale('hi', 'IN'),
//     const Locale('ar', 'SA'),
//   ];

//   static const defaultLocale = Locale('en', 'US');

//   Locale getCurrentLocale() {
//     final storage = GetStorage();
//     String? langCode = storage.read('langCode');
//     String? countryCode = storage.read('countryCode');
//     return langCode != null && countryCode != null
//         ? Locale(langCode, countryCode)
//         : defaultLocale;
//   }

//   void changeLocale(String langCode, String countryCode) {
//     final locale = Locale(langCode, countryCode);
//     Get.updateLocale(locale);
//     GetStorage().write('langCode', langCode);
//     GetStorage().write('countryCode', countryCode);
//   }
// }
class LocalizationService extends GetxService {
  static final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('ur', 'PK'),
    const Locale('hi', 'IN'),
    const Locale('ar', 'SA'),
  ];

  static const defaultLocale = Locale('en', 'US');

  static final _currentLocale = Rx<Locale>(defaultLocale);

  Locale get currentLocale => _currentLocale.value;

  String get currentLocaleString =>
      "${currentLocale.languageCode}_${currentLocale.countryCode}";

  @override
  void onInit() {
    Logger().d("ssssssssssssssssssssssssssssssssssssssss");
    super.onInit();
    _loadCurrentLocale();
  }

  void _loadCurrentLocale() {
    final storage = GetStorage();
    final langCode = storage.read<String>('langCode');
    final countryCode = storage.read<String>('countryCode');

    if (langCode != null && countryCode != null) {
      _currentLocale.value = Locale(langCode, countryCode);
    } else {
      _currentLocale.value = defaultLocale;
    }
  }

  void changeLocale(String langCode, String countryCode) async {
    final locale = Locale(langCode, countryCode);
    _currentLocale.value = locale;
    await Get.updateLocale(locale);
    Logger().e(currentLocale.languageCode);
    Logger().e(currentLocale.countryCode);
    GetStorage().write('langCode', langCode);
    GetStorage().write('countryCode', countryCode);
  }
}
