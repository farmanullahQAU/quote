import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/data/providers/api_provider.dart';
import 'package:myapp/data/repositories/quote_repository.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/video_services/video_cont_manager.dart';
import 'package:myapp/views/subpages/sound_cont/controller.dart';
import 'package:myapp/views/widets/toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

import '../../screenshot_screen/editor/view.dart';

class QuotesController extends GetxController {
  final soundsController = Get.put(SoundController());
  final ScreenshotController screenshotController = ScreenshotController();
  final QuoteRepository _repository = QuoteRepository(ApiProvider());

  var quotes = <Quote>[].obs;
  final isLoading = false.obs;
  var errorString = "".obs;
  String? category; //selected category from topics
  Rxn<ThemeItem> selectedtheme = Rxn<ThemeItem>();

  final currentQuoteIndex = 0.obs;

  VideoPlayerController? videoController;
  @override
  void onInit() async {
    super.onInit();
    selectedtheme.value = Get.arguments["themeModel"];
    category = Get.arguments["category"];

    fetchQuotes();
    // await playSounds();
  }

  Future copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Copied', 'Copied to clipboard');
  }

  Future<void> fetchQuotes() async {
    try {
      isLoading.value = true;

      await _repository.getQuotes(
        category: category,
        useCache: false,
        successCallback: (data) {
          // quotes(data); //TODO
        },
        onError: (error) {
          MyToast.showToast(message: error, type: ToastType.error);
          isLoading.value = false;
          errorString(error);
        },
      );
    } finally {
      isLoading.value = false;

      MyToast.closeToast();
    }
  }

  void navigateToEditView() {
    Get.to(
        () => QuoteEditorScreen(
              data: quotes[currentQuoteIndex.value],
            ),
        arguments: quotes[currentQuoteIndex.value],
        transition: Transition.zoom);
  }

  @override
  void onClose() {
    videoController?.dispose();
    VideoControllerManager().disposeControllers();

    super.onClose();
  }
}
