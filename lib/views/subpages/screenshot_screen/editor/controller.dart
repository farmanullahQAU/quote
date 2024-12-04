import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/screenshot_service.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/pexels_images/view.dart';
import 'package:screenshot/screenshot.dart';

import 'view.dart';

enum BackgroundType {
  image,
  solidColor,
  gradient,
  video,
  transperent,
  pexelsImage
}

class EditorController extends GetxController with GetTickerProviderStateMixin {
  late final TabController tabController;
  late ThemeItem? selectedTheme;
  final screenshotController = ScreenshotController();
  var isTakingScreenshot = false.obs;
  Rx<BackgroundType>? backgroundType;
  RxBool showOptionsSheet = false.obs; // To track which sheet to show
  late AnimationController mainSheetController;
  late AnimationController optionsSheetController;
  late Animation<Offset> mainSheetAnimation;

  late Animation<Offset> optionsSheetAnimation;
  var currentTabIndex = 0.obs;
  TxtStyleOption selectedOption = TxtStyleOption.color;
  final RxDouble backgroundBlur = 0.0.obs;

  @override
  void onInit() {
    _initThemeObject();

    // Initialize the animation controllers
    mainSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    optionsSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Define the animation for sliding up the main sheet
    mainSheetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: mainSheetController,
      curve: Curves.easeInOut,
    ));

    // Define the animation for sliding up the options sheet
    optionsSheetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: optionsSheetController,
      curve: Curves.easeInOut,
    ));

    // Start by showing the main sheet
    mainSheetController.forward();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentTabIndex(tabController.index);

      if (currentTabIndex.value == 2) {
        // If pexels tab is selected
        Get.to(() => PexelsView(), transition: Transition.downToUp);
      }
    });
    super.onInit();
  }

  void onTapTab(int value) {
    currentTabIndex(value);
    if (currentTabIndex.value == 2) {
      Get.to(() => PexelsView(), transition: Transition.downToUp);
    }
  }

  void _initThemeObject() {
    selectedTheme = Get.arguments;

    // Initialize backgroundType based on themeType
    switch (selectedTheme?.themeType) {
      case 'image':
        backgroundType = BackgroundType.image.obs;
        break;
      case 'pexelsImage':
        backgroundType = BackgroundType.pexelsImage.obs;
        break;
      case 'colors': //list of colors for gradients
        backgroundType =
            BackgroundType.gradient.obs; // Or gradient, if preferred
        break;
      case 'video':
        backgroundType = BackgroundType.video.obs;
        break;

      case 'color':
        backgroundType = BackgroundType.solidColor.obs; //single solid color
      default:
        backgroundType = BackgroundType.transperent.obs; // No default value
    }

    if (backgroundType != null) {
      Logger().d('BackgroundType: ${backgroundType!.value}');
    } else {
      Logger().d('No valid backgroundType set');
    }
  }

  void toggleSheet() {
    if (showOptionsSheet.value) {
      // Closing the options sheet, showing the main sheet
      optionsSheetController.reverse();
      mainSheetController.forward();
    } else {
      // Closing the main sheet, showing the options sheet
      mainSheetController.reverse();
      optionsSheetController.forward();
    }

    showOptionsSheet.toggle();
  }

  selectTextStyleOption(TxtStyleOption option) {
    selectedOption = option;
    toggleSheet();
  }

  void saveImage(BuildContext context) async {
    isTakingScreenshot.value = true;

    await ScreenshotService.saveImage(screenshotController, context)
        .catchError((err) {
      isTakingScreenshot.value = false;
    });

    isTakingScreenshot.value = false;
  }

  void shareImage(BuildContext context) async {
    isTakingScreenshot.value = true;

    await ScreenshotService.shareImage(screenshotController, context)
        .catchError((err) {
      isTakingScreenshot.value = false;
    });

    isTakingScreenshot.value = false;
  }

  onChangeBlurValue(double value) {
    backgroundBlur.value = value * 10;
  }
}
