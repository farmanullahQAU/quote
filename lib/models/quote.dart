// import 'package:get/get.dart';
// import 'package:logger/logger.dart';

// // Language class to represent text and voice-over URL for a specific language
// class Language {
//   final String text;
//   final String? voiceOverUrl;

//   Language({
//     required this.text,
//     this.voiceOverUrl,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       if (voiceOverUrl != null) 'voiceOverUrl': voiceOverUrl,
//     };
//   }

//   factory Language.fromMap(Map<String, dynamic> map) {
//     return Language(
//       text: map['text'],
//       voiceOverUrl: map['voiceOverUrl'],
//     );
//   }
// }

// // Quote class to represent a quote with its translations and other properties
// class Quote {
//   final String text;
//   final List<String>? categories; // Categories as List<String>
//   final Map<String, String>?
//       author; // Author translated in different languages (Map)
//   final bool isFromUser; // Indicates if the quote is from the user
//   final Map<String, Language>? languages; // Map for different languages

//   RxBool isFavorite; // Use RxBool for reactivity

//   Quote({
//     required this.text,
//     this.categories,
//     this.author,
//     required this.isFromUser,
//     this.languages,
//     bool? isFav,
//   }) : isFavorite = (isFav ?? false).obs;

//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       if (categories != null) 'categories': categories,
//       if (author != null) 'author': author,
//       'isFromUser': isFromUser,
//       'languages': (languages?.isNotEmpty ?? false)
//           ? languages?.map((key, value) => MapEntry(key, value.toJson()))
//           : null,
//     };
//   }

//   factory Quote.fromJson(dynamic map, {bool isFromUser = true}) {
//     Logger().e(map);
//     return Quote(
//       text: map['text'],
//       categories: map['categories'] != null
//           ? List<String>.from(map['categories']) // Convert categories from JSON
//           : null,
//       author: map['author'] != null
//           ? Map<String, String>.from(map['author']
//               as Map) // Correctly parse author as a Map<String, String>
//           : null,
//       isFromUser:
//           map['isFromUser'] ?? isFromUser, // Default to true if not provided
//       languages: map['languages'] != null
//           ? (map['languages'] as Map<String, dynamic>).map(
//               (key, value) => MapEntry(key, Language.fromMap(value)),
//             )
//           : null,
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:logger/logger.dart';

// Language class to represent text and voice-over URL for a specific language
class Language {
  final String text;
  final String? voiceOverUrl;

  Language({
    required this.text,
    this.voiceOverUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (voiceOverUrl != null) 'voiceOverUrl': voiceOverUrl,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      text: map['text'],
      voiceOverUrl: map['voiceOverUrl'],
    );
  }
}

// Quote class to represent a quote with its translations and other properties
class Quote {
  final String text;
  final List<String>? categories;
  final Map<String, String>? author;
  final bool isFromUser;
  final Map<String, Language>? languages;

  RxBool isFavorite;

  Quote({
    required this.text,
    this.categories,
    this.author,
    required this.isFromUser,
    this.languages,
    bool? isFav,
  }) : isFavorite = (isFav ?? false).obs;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (categories != null) 'categories': categories,
      if (author != null) 'author': author,
      'isFromUser': isFromUser,
      'languages': (languages?.isNotEmpty ?? false)
          ? languages?.map((key, value) => MapEntry(key, value.toJson()))
          : null,
    };
  }

  factory Quote.fromJson(dynamic map, {bool isFromUser = true}) {
    Logger().e(map);
    return Quote(
      text: map['text'],
      categories: map['categories'] != null
          ? List<String>.from(map['categories'])
          : null,
      author: map['author'] != null
          ? Map<String, String>.from(map['author'] as Map)
          : null,
      isFromUser: map['isFromUser'] ?? isFromUser,
      languages: map['languages'] != null
          ? (map['languages'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, Language.fromMap(value)),
            )
          : null,
    );
  }
}

class PaginatedQuotes {
  final List<Quote> quotes;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  PaginatedQuotes({
    required this.quotes,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  Map<String, dynamic> toJson() {
    return {
      'quotes': quotes.map((quote) => quote.toJson()).toList(),
      'pagination': {
        'totalDocs': totalDocs,
        'limit': limit,
        'totalPages': totalPages,
        'currentPage': currentPage,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
        'nextPage': nextPage,
        'prevPage': prevPage,
      },
    };
  }

  factory PaginatedQuotes.fromJson(dynamic json) {
    Logger().e(json['limit']);
    return PaginatedQuotes(
      quotes: (json['quotes'] as List<dynamic>)
          .map((quote) => Quote.fromJson(quote))
          .toList(),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }
}
