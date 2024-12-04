import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/data/repositories/quote_repository.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/screenshot_service.dart';
import 'package:myapp/services/video_services/video_cont_manager.dart';
import 'package:myapp/services/video_services/video_process.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/view.dart';
import 'package:myapp/views/subpages/sound_cont/controller.dart';
import 'package:myapp/views/widets/toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

import '../../fav_quotes/view.dart';

class HomeController extends GetxController {
  final soundsController = Get.put(SoundController());
  final ScreenshotController screenshotController = ScreenshotController();
  final QuoteRepository _repository;
  HomeController(this._repository);

  var quotes = <Quote>[].obs;
  var isLoading = false.obs;

  // Pagination state
  int currentPage = 1;
  bool hasNextPage = true;

  Rxn<ThemeItem> selectedTheme = Rxn<ThemeItem>();
  final isVideoInitialized = false.obs;
  final currentQuoteIndex = 0.obs;
  var hideButtons = false.obs;

  VideoProcess? videoProcess;
  VideoPlayerController? videoController;

  @override
  void onInit() async {
    super.onInit();
    fetchQuotes();
  }

  Future<void> fetchQuotes({bool loadMore = false}) async {
    if (loadMore && !hasNextPage) return;

    try {
      isLoading(true);

      final nextPage = loadMore ? currentPage + 1 : 1;

      await _repository.getQuotes(
        page: nextPage,
        limit: 2,
        successCallback: (PaginatedQuotes data) {
          if (loadMore) {
            quotes.addAll(data.quotes);
          } else {
            quotes(data.quotes);
          }

          currentPage = data.currentPage;
          hasNextPage = data.hasNextPage;
        },
        onError: (error) {
          print(error);
          MyToast.showToast(message: error, type: ToastType.error);
        },
        useCache: !loadMore, // Don't use cache for pagination
        storageKey: 'quotes_cache',
      );
    } catch (e) {
      MyToast.showToast(message: e.toString(), type: ToastType.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadNextPage() async {
    print("ssssssssssssssssssssssssssssss");
    if (hasNextPage) {
      await fetchQuotes(loadMore: true);
    }
  }

  void toggleButtonVisibility(bool isVisible) {
    hideButtons.value = isVisible;
  }

  Future<void> onSelectBackTheme(ThemeItem theme) async {
    selectedTheme(theme);
    if (theme.themeType == 'video') {
      await _initVideo();
    }
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Copied', 'Copied to clipboard');
  }

  Future<void> download(
      {String? quoteText, required BuildContext context}) async {
    hideButtons(true);
    if (selectedTheme.value?.themeType == 'video') {
      videoProcess = VideoProcess(
        videoUrl: selectedTheme.value!.url,
        audioUrl: soundsController.backgroundUrl,
        overlayText: quoteText ?? "",
      );
      videoProcess?.downloadVideo();
    } else {
      await ScreenshotService.saveImage(screenshotController, context);
    }
    hideButtons(false);
  }

  void setCurrentQuoteIndex(int index) async {
    final quote = quotes[index];
    final voiceOverUrl = quote.languages?['english']?.voiceOverUrl;

    if (voiceOverUrl != null && voiceOverUrl.isNotEmpty) {
      await soundsController.setVoiceType(voiceOverUrl);
    } else {
      soundsController.stopVoiceType();
    }
  }

  void navigateToEditView() {
    Get.to(
      () => QuoteEditorScreen(
        data: quotes[currentQuoteIndex.value],
      ),
      transition: Transition.zoom,
    );
  }

  Future<void> _initVideo() async {
    if (selectedTheme.value?.url == null) return;

    videoController =
        VideoControllerManager().getController(selectedTheme.value!.url);
    await videoController?.initialize();
    await videoController?.setLooping(true);
    await videoController?.play();
    isVideoInitialized(true);
  }

  @override
  void onClose() {
    videoController?.dispose();
    VideoControllerManager().disposeControllers();
    super.onClose();
  }

  void likeDislikeQuote(Quote quote) {
    final index = quotes.indexOf(quote);
    if (index != -1) {
      quotes[index].isFavorite.toggle();
    }
  }

  List<Quote> get favQuotes {
    return quotes.where((quote) => quote.isFavorite.isTrue).toList();
  }

  void gotoFavQuotePage() {
    Get.to(() => FavQuotesPage(), arguments: favQuotes);
  }
}
