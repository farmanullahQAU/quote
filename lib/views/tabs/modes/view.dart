// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:myapp/models/quote.dart';

// import '../ai/controller.dart';
// import '../home/bottom_navbar/controller.dart';

// class QuoteCategoriesView extends StatelessWidget {
//   const QuoteCategoriesView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200.0,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text('Quote Categories',
//                   style: GoogleFonts.playfairDisplay(
//                     fontWeight: FontWeight.bold,
//                     // color: Colors.white,
//                   )),
//               // background: Opacity(
//               //   opacity: 0.2,
//               //   child: Image.asset(
//               //     'assets/images/back1.jpg',
//               //     fit: BoxFit.cover,
//               //   ),
//               // ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(16),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.0,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) =>
//                     _buildCategoryCard(QuoteCategory.values[index]),
//                 childCount: QuoteCategory.values.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryCard(QuoteCategory category) {
//     return Hero(
//       tag: 'category_${category.name}',
//       child: Material(
//         color: Colors.transparent,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: _getCategoryColors(category),
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: InkWell(
//             onTap: () {
//               Get.find<BottomNavbarController>().changePageIndex(1);
//               Get.find<AiQuoteController>().sendQuoteRequest(
//                   "give me 5 qoutes about ${category.name} ", category.name);
//             },
//             borderRadius: BorderRadius.circular(20),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     _getCategoryIcon(category),
//                     size: 48,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     category.name.capitalizeFirst!,
//                     style: GoogleFonts.lato(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getCategoryIcon(QuoteCategory category) {
//     switch (category) {
//       case QuoteCategory.inspirational:
//         return Icons.lightbulb;
//       case QuoteCategory.love:
//         return Icons.favorite;
//       case QuoteCategory.life:
//         return Icons.nature_people;
//       case QuoteCategory.friendship:
//         return Icons.people;
//       case QuoteCategory.motivational:
//         return Icons.emoji_events;
//       case QuoteCategory.happiness:
//         return Icons.mood;
//       case QuoteCategory.wisdom:
//         return Icons.school;
//       case QuoteCategory.humor:
//         return Icons.sentiment_very_satisfied;
//       case QuoteCategory.success:
//         return Icons.star;
//       case QuoteCategory.famous:
//         return Icons.public;
//       case QuoteCategory.positive:
//         return Icons.add_circle;
//       case QuoteCategory.sad:
//         return Icons.sentiment_very_dissatisfied;
//       case QuoteCategory.romantic:
//         return Icons.favorite_border;
//     }
//   }

//   List<Color> _getCategoryColors(QuoteCategory category) {
//     switch (category) {
//       case QuoteCategory.inspirational:
//         return [const Color(0xFF6DD5ED), const Color(0xFF2193B0)];
//       case QuoteCategory.love:
//         return [const Color(0xFFFF9A9E), const Color(0xFFFAD0C4)];
//       case QuoteCategory.life:
//         return [const Color(0xFF56AB2F), const Color(0xFFA8E063)];
//       case QuoteCategory.friendship:
//         return [const Color(0xFFE55D87), const Color(0xFF5FC3E4)];
//       case QuoteCategory.motivational:
//         return [const Color(0xFFFF512F), const Color(0xFFDD2476)];
//       case QuoteCategory.happiness:
//         return [const Color(0xFFFDC830), const Color(0xFFF37335)];
//       case QuoteCategory.wisdom:
//         return [const Color(0xFF4776E6), const Color(0xFF8E54E9)];
//       case QuoteCategory.humor:
//         return [const Color(0xFFFFD54F), const Color(0xFFFFA000)];
//       case QuoteCategory.success:
//         return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
//       case QuoteCategory.famous:
//         return [const Color(0xFF5614B0), const Color(0xFFDBD65C)];
//       case QuoteCategory.positive:
//         return [const Color(0xFF00C9FF), const Color(0xFF92FE9D)];
//       case QuoteCategory.sad:
//         return [const Color(0xFF616161), const Color(0xFF9BC5C3)];
//       case QuoteCategory.romantic:
//         return [const Color(0xFFFF5F6D), const Color(0xFFFFC371)];
//     }
//   }

//   void _onCategorySelected(QuoteCategory category) {
//     Get.to(() => QuoteListView(category: category),
//         transition: Transition.fadeIn,
//         duration: const Duration(milliseconds: 500));
//   }
// }

// class QuoteListView extends StatelessWidget {
//   final QuoteCategory category;

//   const QuoteListView({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category.name.capitalizeFirst!,
//             style: GoogleFonts.playfairDisplay()),
//         backgroundColor: _getCategoryColors(category)[0],
//       ),
//       body: Center(
//         child: Text('Quotes for ${category.name} category'),
//       ),
//     );
//   }

//   List<Color> _getCategoryColors(QuoteCategory category) {
//     switch (category) {
//       case QuoteCategory.inspirational:
//         return [const Color(0xFF6DD5ED), const Color(0xFF2193B0)];
//       case QuoteCategory.love:
//         return [const Color(0xFFFF9A9E), const Color(0xFFFAD0C4)];
//       case QuoteCategory.life:
//         return [const Color(0xFF56AB2F), const Color(0xFFA8E063)];
//       case QuoteCategory.friendship:
//         return [const Color(0xFFE55D87), const Color(0xFF5FC3E4)];
//       case QuoteCategory.motivational:
//         return [const Color(0xFFFF512F), const Color(0xFFDD2476)];
//       case QuoteCategory.happiness:
//         return [const Color(0xFFFDC830), const Color(0xFFF37335)];
//       case QuoteCategory.wisdom:
//         return [const Color(0xFF4776E6), const Color(0xFF8E54E9)];
//       case QuoteCategory.humor:
//         return [const Color(0xFFFFD54F), const Color(0xFFFFA000)];
//       case QuoteCategory.success:
//         return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
//       case QuoteCategory.famous:
//         return [const Color(0xFF5614B0), const Color(0xFFDBD65C)];
//       case QuoteCategory.positive:
//         return [const Color(0xFF00C9FF), const Color(0xFF92FE9D)];
//       case QuoteCategory.sad:
//         return [const Color(0xFF616161), const Color(0xFF9BC5C3)];
//       case QuoteCategory.romantic:
//         return [const Color(0xFFFF5F6D), const Color(0xFFFFC371)];
//     }
//   }
// }
