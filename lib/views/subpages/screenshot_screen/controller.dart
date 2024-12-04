// controllers/share_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/services/screenshot_service.dart';
import 'package:myapp/views/widets/toast.dart';
import 'package:screenshot/screenshot.dart';

class ShareController extends GetxController {
  final screenshotController = ScreenshotController();
  var isWatermarkHidden = false.obs;
  var isTakingScreenshot = false.obs;
  void toggleWatermark() {
    isWatermarkHidden.value = !isWatermarkHidden.value;
  }

  void addToCollection() {
    // Add your logic to add to collection
    print('Added to collection');
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

  void copyQuote(String quote) {
    Clipboard.setData(ClipboardData(text: quote));

    MyToast.showToast(message: "Copied", type: ToastType.success);
  }
}
