import 'package:get/get.dart';
import 'package:myapp/data/providers/api_provider.dart';
import 'package:myapp/data/repositories/theme_repository.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/colors/controller.dart';
import 'package:myapp/views/subpages/topics/qutoes/controller.dart';
import 'package:myapp/views/tabs/ai/controller.dart';
import 'package:myapp/views/tabs/home/bottom_navbar/controller.dart';
import 'package:myapp/views/tabs/themes/controller.dart';

import '../data/repositories/quote_repository.dart';
import '../views/subpages/screenshot_screen/editor/textStyle/controller.dart';
import '../views/tabs/home/controller.dart';
import '../views/tabs/settings/controller.dart';

class QuoteBinding extends Bindings {
  @override
  void dependencies() {
    try {
      Get.put(ApiProvider());
      Get.put(QuoteRepository(Get.find<ApiProvider>()));
      Get.lazyPut(() => HomeController(Get.find<QuoteRepository>()));
      Get.lazyPut(() => QuotesController());
      Get.lazyPut(() => ColorsController());

      Get.lazyPut(() => ThemeRepository(Get.find<ApiProvider>()));
      Get.lazyPut(() => ThemesController());
      Get.lazyPut(() => BottomNavbarController());
      Get.lazyPut(() => AiQuoteController());
      Get.lazyPut(() => TextController());
      Get.lazyPut(() => SettingsController());
      print("QuoteBinding dependencies initialized successfully");
    } catch (e) {
      print("Error in QuoteBinding: $e");
    }
  }
}
