// import 'package:myapp/data/providers/api_provider.dart';
// import 'package:myapp/models/theme_item_model.dart';

// class ThemeRepository {
//   final ApiProvider _apiProvider;

//   ThemeRepository(this._apiProvider);

//   Future<void> getThemes({
//     required Function(List<ThemeItem>)
//         successCallback, // Success callback to handle fetched themes

//     required Function(String) onError, // Callback for handling errors
//     String storageKey = 'themesCache', // Default cache key
//     bool useCache = true, // Optional flag for using cache
//   }) async {
//     try {
//       // Fetch themes from the API or cache
//       await _apiProvider.getData(
//         'getThemes',
//         storageKey: storageKey,

//         successCallback: (data) {
//           // Convert dynamic data to List<ThemeItem>
//           List<ThemeItem> themes =
//               data.map<ThemeItem>((item) => ThemeItem.fromJson(item)).toList();

//           successCallback(themes); // Return the themes to the success callback
//         },
//         useCache: useCache, // Control whether to use cache
//         onError: (error) {
//           onError(error); // Handle error
//         },
//       );
//     } catch (e) {
//       // Handle the error by calling the error callback
//       onError('Failed to get themes: $e');
//     }
//   }
// }

import 'package:myapp/data/providers/api_provider.dart';
import 'package:myapp/models/theme_item_model.dart';

class ThemeRepository {
  final ApiProvider _apiProvider;

  ThemeRepository(this._apiProvider);

  Future<void> getThemes({
    required int page,
    required int limit,
    String? category,
    required Function(PaginatedThemes)
        successCallback, // Success callback to handle paginated data
    required Function(String) onError, // Callback for handling errors
    String storageKey = 'themesCache', // Default cache key
    bool useCache = true, // Optional flag for using cache
  }) async {
    try {
      // Fetch themes from the API or cache
      await _apiProvider.getData(
        'getThemes',
        params: {
          'page': page.toString(),
          'limit': limit.toString(),
          'category': category
        }, // Pass page and limit
        storageKey: '${storageKey}_page_$page',

        successCallback: (data) {
          // Convert dynamic data to PaginatedThemes
          PaginatedThemes paginatedThemes = PaginatedThemes.fromJson(data);

          successCallback(
              paginatedThemes); // Return the paginated themes to the success callback
        },
        useCache: useCache, // Control whether to use cache
        onError: (error) {
          onError(error); // Handle error
        },
      );
    } catch (e) {
      // Handle the error by calling the error callback
      onError('Failed to get themes: $e');
    }
  }
}
