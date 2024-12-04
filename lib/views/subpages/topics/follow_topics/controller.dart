// import 'package:get/get.dart';

// class CategoriesController extends GetxController {
//   var selectedCategory = ''.obs;
//   var categories = [
//     {"name": "Motivation", "imageUrl": "https://via.placeholder.com/300"},
//     {"name": "Health", "imageUrl": "https://via.placeholder.com/300"},
//     {"name": "Business", "imageUrl": "https://via.placeholder.com/300"},
//     {"name": "Happiness", "imageUrl": "https://via.placeholder.com/300"},
//     {"name": "Success", "imageUrl": "https://via.placeholder.com/300"},
//     {"name": "Productivity", "imageUrl": "https://via.placeholder.com/300"},
//   ].obs;

//   void selectCategory(String category) {
//     selectedCategory.value = category;
//   }

//   List<Map<String, String>> get filteredCategories {
//     if (selectedCategory.value.isEmpty) {
//       return categories;
//     } else {
//       return categories
//           .where((category) => category['name'] == selectedCategory.value)
//           .toList();
//     }
//   }
// }
