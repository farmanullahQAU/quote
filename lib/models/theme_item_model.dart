import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class ThemeItem {
  final String category;
  final List<Color> gradientColors;
  final String fontFamily;
  final String url;
  final String themeType;
  final bool isFree;
  final DateTime? createdAt;
  final Color? textColor;

  ThemeItem({
    required this.category,
    required this.gradientColors,
    required this.fontFamily,
    required this.url,
    required this.themeType,
    required this.isFree,
    required this.createdAt,
    this.textColor,
  });

  // JSON deserialization
  factory ThemeItem.fromJson(Map<String, dynamic> json) {
    return ThemeItem(
      category: json['category'] as String,
      gradientColors: (json['colors'] as List)
          .map((color) => Color(int.parse(color.replaceFirst('#', '0xff'))))
          .toList(),
      fontFamily: json['fontFamily'] as String,
      textColor: json['textColor'] != null
          ? Color(
              int.parse(json['textColor'].toString().replaceFirst('#', '0xff')))
          : null,
      url: json['url'] as String,
      themeType: json['themeType'] as String,
      isFree: json['isFree'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'colors': gradientColors
          .map((color) => '#${color.value.toRadixString(16).substring(2)}')
          .toList(),
      'fontFamily': fontFamily,
      'textColor': textColor?.value.toRadixString(16).substring(2),
      'url': url,
      'themeType': themeType,
      'isFree': isFree,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

// Model for handling paginated response of themes
class PaginatedThemes {
  final List<ThemeItem> themes;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPrevPage;
  final int? nextPage;
  final int? prevPage;

  PaginatedThemes({
    required this.themes,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  // JSON deserialization
  factory PaginatedThemes.fromJson(Map<String, dynamic> json) {
    Logger().w(json);
    return PaginatedThemes(
      themes: (json['themes'] as List)
          .map((theme) => ThemeItem.fromJson(theme))
          .toList(),
      totalDocs: json['totalDocs'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
      nextPage: json['nextPage'] as int?,
      prevPage: json['prevPage'] as int?,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'themes': themes.map((theme) => theme.toJson()).toList(),
        'totalDocs': totalDocs,
        'limit': limit,
        'totalPages': totalPages,
        'currentPage': currentPage,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
        'nextPage': nextPage,
        'prevPage': prevPage,
      }
    };
  }
}
