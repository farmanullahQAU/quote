import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/controller.dart';

class ColorsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const _filtersPerScreen = 6;
  static const viewportFractionPerItem = 1.0 / _filtersPerScreen;
  late final PageController pageController;
  RxInt page = RxInt(0);

  // FilterSelectorController(int initialPage) {
  //   page.value = initialPage;
  //   pageController = PageController(
  //     initialPage: page.value,
  //     viewportFraction: viewportFractionPerItem,
  //   );
  // }

  @override
  void onInit() {
    pageController = PageController(
        viewportFraction: viewportFractionPerItem, initialPage: 4);

    super.onInit();
  }

  void onPageChanged(int newPage) {
    page(newPage);

    Get.find<EditorController>().backgroundType?.value =
        BackgroundType.solidColor;
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
