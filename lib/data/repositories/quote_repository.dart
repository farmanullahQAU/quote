// import 'package:myapp/models/quote.dart';

// import '../providers/api_provider.dart';

// class QuoteRepository {
//   final ApiProvider _apiProvider;

//   QuoteRepository(this._apiProvider);

//   Future<void> getQuotes({
//     String? category,
//     required Function(List<Quote>) successCallback,
//     required Function(String) onError,
//     String storageKey = 'quotesCache', // Default cache key
//     bool useCache = true, // Optional flag for using cache
//   }) async {
//     Map<String, String>? body = {};

//     if (category?.isNotEmpty ?? false) {
//       body['categories'] = category!;
//     }
//     try {
//       await _apiProvider.getData(
//         params: body,
//         'quotes',
//         storageKey: storageKey,
//         successCallback: (data) {
//           // Convert dynamic data to List<Quote>
//           List<Quote> quotes =
//               data.map<Quote>((item) => Quote.fromJson(item)).toList();

//           successCallback(quotes); // Return the quotes
//         },
//         useCache: useCache, // Pass cache flag to the provider
//         onError: (error) {
//           onError(error); // Handle error
//         },
//       );
//     } catch (e) {
//       onError('Failed to get quotes: $e');
//     }
//   }
// }
import 'package:logger/logger.dart';
import 'package:myapp/models/quote.dart';

import '../providers/api_provider.dart';

class QuoteRepository {
  final ApiProvider _apiProvider;

  QuoteRepository(this._apiProvider);

  Future<void> getQuotes({
    String? category,
    required Function(PaginatedQuotes) successCallback,
    required Function(String) onError,
    String storageKey = 'quotesCache',
    bool useCache = true,
    int page = 1, // Added page parameter
    int limit = 10, // Added limit parameter
  }) async {
    Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // Add category if provided
    if (category?.isNotEmpty ?? false) {
      params['categories'] = category;
    }

    await _apiProvider.getData(
      'quotes',
      params: params,
      storageKey: '${storageKey}_page_$page',
      successCallback: (data) {
        Logger().d(data);
        // Convert response data to PaginatedQuotes
        PaginatedQuotes paginatedQuotes = PaginatedQuotes.fromJson(data);
        successCallback(paginatedQuotes);
      },
      useCache: useCache,
      onError: onError,
    );
  }
}
