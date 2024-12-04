import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/tabs/home/view.dart';

import '../../ai/view.dart';
import '../../settings/view.dart';
import '../../themes/view.dart';

class BottomNavbarController extends GetxController {
  List<Widget> pages = [
    HomeView(),
    AiChatScreen(),
    ThemesScreen(),
    SettingsPage(),
  ];

  int currentPageIndex = 0;
  void changePageIndex(int index) async {
    currentPageIndex = index;

    update(["navbar"]);
  }
}
