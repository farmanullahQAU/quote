import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/topics.dart';

import 'controller.dart';

class ReminderCategorySelectionScreen extends StatelessWidget {
  final controller = Get.put(ReminderCategorySelectionController());
  final onSubTopicSelected;

  ReminderCategorySelectionScreen({
    super.key,
    required this.onSubTopicSelected,
  });

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
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ListView(
              children: controller.categories
                  .map((category) => categoryTile(
                        category: category,
                        onSubTopicSelected: onSubTopicSelected,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class categoryTile extends StatelessWidget {
  final Category category;
  final Function(SubTopic) onSubTopicSelected;

  const categoryTile({
    super.key,
    required this.category,
    required this.onSubTopicSelected,
  });

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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            margin: const EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              color:
                  context.theme.colorScheme.surfaceContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: category.subTopics
                  .map((subTopic) => ListTile(
                        trailing:
                            (subTopic.isLocked) ? const Icon(Icons.lock) : null,
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(subTopic.title),
                            Get.find<ReminderCategorySelectionController>()
                                    .remindersTitles
                                    .contains(subTopic.title)
                                ? Icon(Icons.alarm)
                                : SizedBox()
                          ],
                        ),
                        selected:
                            Get.find<ReminderCategorySelectionController>()
                                .remindersTitles
                                .contains(subTopic.title),
                        onTap: () {
                          onSubTopicSelected(subTopic);
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
