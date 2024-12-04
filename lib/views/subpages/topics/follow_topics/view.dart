import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/topics.dart';

import '../controller.dart';

class FollowedTopicsPage extends GetView<TopicsController> {
  const FollowedTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Topics you follow',
          style: context.textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          SearchAnchor(
            builder: (context, controller) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (context, searchController) {
              String query = searchController.text.toLowerCase();

              // Filter categories and subtopics based on the search query
              final List<Category> filteredCategories = controller.categories
                  .where((category) =>
                      category.name.toLowerCase().contains(query) ||
                      category.subTopics.any((subTopic) =>
                          subTopic.title.toLowerCase().contains(query)))
                  .toList();

              if (query.isEmpty) {
                return const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Type to search topics...'),
                  ),
                ];
              }

              if (filteredCategories.isEmpty) {
                return const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No results found'),
                  ),
                ];
              }

              // Display filtered results as in the existing layout
              return filteredCategories
                  .map(
                    (category) => ListTile(
                      title: Text(category.name),
                      subtitle: Text(
                        category.subTopics
                            .map((e) => e.title)
                            .join(', '), // Subtopics listed
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        searchController.text = category.name;
                        searchController.closeView(category.name);
                      },
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ListView(
              physics: const BouncingScrollPhysics(),
              children: controller.filteredCategories.isNotEmpty
                  ? controller.filteredCategories
                      .map((category) => CategoryWidget(category: category))
                      .toList()
                  : controller.categories
                      .map((category) => CategoryWidget(category: category))
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.name, style: context.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: const EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceDim,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: category.subTopics
                  .map((subTopic) => SubTopicWidget(subTopic: subTopic))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SubTopicWidget extends StatelessWidget {
  final SubTopic subTopic;

  const SubTopicWidget({super.key, required this.subTopic});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: subTopic.isSelected.isTrue
              ? null
              : () {
                  subTopic.isSelected.toggle();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(
                subTopic.icon,
              ),
              title: Text(subTopic.title),
              trailing: subTopic.isLocked
                  ? const Icon(Icons.lock)
                  : GestureDetector(
                      onTap: () {
                        subTopic.isSelected.toggle();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: subTopic.isSelected.value
                              ? context.theme.colorScheme.primaryContainer
                              : context.theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              subTopic.isSelected.value
                                  ? 'Following'
                                  : 'Follow',
                              style: context.textTheme.bodySmall?.copyWith(
                                  color: !Get.isDarkMode &&
                                          subTopic.isSelected.value
                                      ? Colors.white
                                      : null),
                            ),
                            const SizedBox(width: 5),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: subTopic.isSelected.value
                                  ? Icon(Icons.check,
                                      size: 18, key: UniqueKey())
                                  : Icon(Icons.add, size: 18, key: UniqueKey()),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ));
  }
}
