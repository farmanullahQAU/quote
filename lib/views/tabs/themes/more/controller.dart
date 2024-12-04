import 'dart:developer';

import 'package:get/get.dart';
import 'package:myapp/data/providers/api_provider.dart';
import 'package:myapp/data/repositories/theme_repository.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/views/tabs/home/bottom_navbar/controller.dart';
import 'package:myapp/views/tabs/home/controller.dart';
import 'package:video_player/video_player.dart';

class MoreThemesController extends GetxController {
  var themes = <ThemeItem>[].obs;
  final ThemeRepository _repository = ThemeRepository(ApiProvider());

  // Pagination state
  int currentPage = 1;
  bool hasNextPage = true;
  var isLoading = false.obs;
  String? category;

  // Separate lists for each category

  @override
  void onInit() {
    this.category = Get.arguments;
    super.onInit();
    fetchThemes();
  }

  Future<void> fetchThemes({bool loadMore = false}) async {
    if (loadMore && !hasNextPage) return; // No further loading if no more pages

    try {
      isLoading(true);

      final nextPage = loadMore ? currentPage + 1 : 1;

      await _repository.getThemes(
        category: category,
        page: nextPage,

        limit: 30,
        useCache: !loadMore, // Avoid cache when loading more pages
        successCallback: (PaginatedThemes data) {
          if (loadMore) {
            themes.addAll(data.themes);
          } else {
            themes(data.themes);
          }

          currentPage = data.currentPage;
          hasNextPage = data.hasNextPage;
        },
        onError: (error) {
          log(error.toString());
          Get.snackbar(LocaleKeys.error.tr,
              '${LocaleKeys.failed_to_fetch_themes.tr}: $error');
        },
        storageKey: 'themes_cache', // Cache key for pagination
      );
    } catch (e) {
      Get.snackbar(LocaleKeys.error.tr,
          '${LocaleKeys.failed_to_fetch_themes.tr}: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void loadNextPage() async {
    if (hasNextPage) {
      await fetchThemes(loadMore: true);
    }
  }

  void onTapGradient(ThemeItem theme,
      {VideoPlayerController? vidController}) async {
    Get.find<BottomNavbarController>().changePageIndex(0);

    Get.back();
    Get.find<HomeController>().onSelectBackTheme(theme);
  }
}
