import 'package:get/get.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/tabs/home/controller.dart';

class FavQuotesController extends GetxController {
  var quotesList = <Quote>[].obs;
  var filteredQuotes = <Quote>[].obs;
  var searchText = ''.obs; // Search term
  var isSearching = false.obs; // To toggle search state

  @override
  void onInit() {
    quotesList.value = Get.find<HomeController>().favQuotes;
    filteredQuotes.assignAll(quotesList);
    super.onInit();
  }

  // Toggle search field visibility
  void toggleSearch() {
    isSearching.toggle();
    if (!isSearching.value) {
      searchQuotes(''); // Clear search if closing search field
    }
  }

  // Toggle favorite status
  void toggleFavorite(Quote quote) {
    Get.find<HomeController>().likeDislikeQuote(quote);
    filteredQuotes.remove(quote);
    quotesList.remove(quote);
  }

  // Search function
  void searchQuotes(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredQuotes.assignAll(quotesList);
    } else {
      filteredQuotes.assignAll(
        quotesList.where((quote) =>
            quote.text.toLowerCase().contains(query.toLowerCase()) ||
            (quote.author != null &&
                quote.author![LocalizationService().currentLocaleString]!
                    .contains(query.toLowerCase()))),
      );
    }
  }

  // Sorting function
  void sortQuotes(String criteria) {
    if (criteria == 'author') {
      filteredQuotes.sort((a, b) =>
          (a.author?[LocalizationService().currentLocaleString] ?? "")
              .compareTo(
                  b.author?[LocalizationService().currentLocaleString] ?? ""));
    } else if (criteria == 'text') {
      filteredQuotes.sort((a, b) => a.text.compareTo(b.text));
    }
  }
}
