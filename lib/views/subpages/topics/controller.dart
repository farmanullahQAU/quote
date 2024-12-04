import 'package:get/get.dart';
import 'package:myapp/constrants.dart';
import 'package:myapp/models/topics.dart';
import 'package:myapp/views/tabs/home/controller.dart';

import 'qutoes/view.dart';

class TopicsController extends GetxController {
  late final RxList<Category> categories;
  final RxList<Category> filteredCategories = <Category>[].obs;

  @override
  void onInit() {
    categories = topics.obs;
    super.onInit();
  }

  void toggleSelection(SubTopic subTopic) {
    if (subTopic.isSelected.value) {
      Get.to(() => FilteredQuotesView(), arguments: {
        'themeModel': Get.find<HomeController>().selectedTheme.value,
        'category': subTopic.title,
      });
    } else {
      subTopic.isSelected.value = !subTopic.isSelected.value;
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all categories
      filteredCategories.assignAll(categories);
    } else {
      // Filter categories based on the query
      filteredCategories.assignAll(
        categories
            .where(
              (category) =>
                  category.name.toLowerCase().contains(query.toLowerCase()) ||
                  category.subTopics.any(
                    (subTopic) => subTopic.title
                        .toLowerCase()
                        .contains(query.toLowerCase()),
                  ),
            )
            .toList(),
      );
    }
  }
}
