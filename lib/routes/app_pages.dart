import 'package:get/get.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:myapp/views/tabs/home/view.dart';
import 'package:myapp/views/tabs/themes/view.dart';

import '../views/tabs/home/bottom_navbar/view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const BottomNavbarView(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
    ),
    GetPage(
      name: Routes.themes,
      page: () => ThemesScreen(),
    ),
  ];
}
