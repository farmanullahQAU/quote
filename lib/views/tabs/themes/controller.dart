import 'dart:developer';

import 'package:get/get.dart';
import 'package:myapp/data/providers/api_provider.dart';
import 'package:myapp/data/repositories/theme_repository.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/views/tabs/home/bottom_navbar/controller.dart';
import 'package:myapp/views/tabs/home/controller.dart';
import 'package:video_player/video_player.dart';

import '../../../models/theme_item_model.dart';

class ThemesController extends GetxController {
  var themes = <ThemeItem>[].obs;
  final ThemeRepository _repository = ThemeRepository(ApiProvider());

  bool hasNextPage = true;
  var isLoading = false.obs;

  // Separate lists for each category
  var categoryLists = <String, List<ThemeItem>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchThemes();
  }

  Future<void> fetchThemes({bool loadMore = false}) async {
    if (loadMore && !hasNextPage) return; // No further loading if no more pages

    try {
      isLoading(true);

      await _repository.getThemes(
        page: 1,
        limit: 50,
        useCache: false,
        successCallback: (PaginatedThemes data) {
          if (loadMore) {
            themes.addAll(data.themes);
          } else {
            themes(data.themes);
          }

          hasNextPage = data.hasNextPage;

          _categorizeThemes();
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

  void _categorizeThemes() {
    categoryLists.clear();
    for (var theme in themes) {
      if (!categoryLists.containsKey(theme.category)) {
        categoryLists[theme.category] = [];
      }
      categoryLists[theme.category]!.add(theme);
    }
  }

  void onTapGradient(ThemeItem theme,
      {VideoPlayerController? vidController}) async {
    Get.find<BottomNavbarController>().changePageIndex(0);
    await Future.delayed(const Duration(milliseconds: 500));
    Get.find<HomeController>().onSelectBackTheme(theme);
  }
}
