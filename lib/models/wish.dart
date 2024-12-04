// Enum for Wish categories
enum WishCategory {
  birthday,
  anniversary,
  goodMorning,
  goodNight,
  getWellSoon,
  congratulations,
  thankYou,
  wedding,
  newYear,
  christmas,
  festival,
  graduation,
  holiday,
}

// Wish class
class Wish {
  final String text;
  final WishCategory category;
  final String? occasion;

  Wish({
    required this.text,
    required this.category,
    this.occasion,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category.toString(),
      if (occasion != null) 'occasion': occasion,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      text: map['text'],
      category: WishCategory.values
          .firstWhere((e) => e.toString() == map['category']),
      occasion: map['occasion'],
    );
  }
}
