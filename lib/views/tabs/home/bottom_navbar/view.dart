import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/generated/locales.g.dart';

import 'controller.dart';

class BottomNavbarView extends StatelessWidget {
  const BottomNavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: PageView(
      //   controller: controller.pageController,
      //   onPageChanged: controller.changePageIndex,
      //   // physics: const NeverScrollableScrollPhysics(),
      //   children: [
      //     HomeView(),
      //     AiChatScreen(),
      //     const ThemesScreen(),
      //     const QuoteCategoriesView()
      //   ],
      // ),

      body: GetBuilder<BottomNavbarController>(
          id: "navbar",
          builder: (controller) {
            return controller.pages.elementAt(controller.currentPageIndex);
          }),
      bottomNavigationBar: GetBuilder<BottomNavbarController>(
          id: "navbar",
          builder: (controller) {
            return NavigationBar(
              onDestinationSelected: controller.changePageIndex,
              // backgroundColor:
              //     context.theme.bottomNavigationBarTheme.backgroundColor,

              backgroundColor: Colors.transparent,
              // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: controller.currentPageIndex,
              destinations: <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.format_quote_sharp),
                  label: LocaleKeys.quotes.tr,
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome),
                  label: LocaleKeys.ai.tr,
                ),
                NavigationDestination(
                  icon: Icon(Icons.gradient_rounded),
                  label: LocaleKeys.themes.tr,
                ),
                NavigationDestination(
                    icon: Icon(Icons.settings), label: LocaleKeys.settings.tr),
              ],
            );
          }),
    );
  }
}
