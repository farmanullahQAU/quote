import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/bindings/quote_bindings.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/routes/app_pages.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:myapp/services/notifications.dart';
import 'package:myapp/services/storage_service.dart';
import 'package:myapp/style.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'services/connectivity_service.dart';
import 'services/localization.dart';
import 'utils/utils.dart';

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   // Handle notification tap when the app is in the background here
//   print('Notification tapped in background: ${notificationResponse.payload}');
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  //initilize all the services
  await Get.putAsync<ConnectivityService>(
      () async => ConnectivityService().init()); //connectivity
  await Get.putAsync<StorageService>(
      () async => await StorageService().init()); //storage

  Get.put(LocalizationService());
  await Get.putAsync<NotificationService>(
      () async => await NotificationService().init());
  tz.initializeTimeZones();
  // Initialize NotificationService
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context);

    MaterialTheme theme = MaterialTheme(textTheme);

    // return GetMaterialApp(
    //   title: 'Motivate Me',
    //   debugShowCheckedModeBanner: false,
    //   theme: theme.lightMediumContrast(), // Light theme
    //   darkTheme: theme.dark(), // Dark theme
    //   themeMode: ThemeMode.system, // System default theme

    //   locale: LocalizationService().getCurrentLocale(), // Current locale
    //   initialBinding: QuoteBinding(),

    //   translations: LocalizationService(), // Localization service
    //   fallbackLocale: LocalizationService.defaultLocale, // Fallback locale
    //   initialRoute: Routes.initial, // Initial route
    //   getPages: AppPages.pages, // Route pages
    // );

    return GetMaterialApp(
      translationsKeys: AppTranslation.translations,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,

      title: 'Motivate Me',
      theme: theme.lightMediumContrast(), // Light theme
      darkTheme: theme.dark(), // Dark theme

      themeMode: ThemeMode.system, // System default theme
      locale: LocalizationService().currentLocale, // Get saved locale
      fallbackLocale: LocalizationService.defaultLocale, // Default locale

      initialBinding: QuoteBinding(),

      initialRoute: Routes.initial, // Initial route
      getPages: AppPages.pages, // Route pages
    );
  }
}
