import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/topics.dart';
import 'package:myapp/views/subpages/topics/follow_topics/view.dart';

import 'controller.dart';

class ExploreTopicsPage extends StatelessWidget {
  final TopicsController controller =
      Get.put(TopicsController(), permanent: false);

  ExploreTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Topics"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() => FollowedTopicsPage());
              },
              icon: const Icon(Icons.lock_open),
              label: const Text('Unlock All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8965e9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: CustomScrollView(
          slivers: [
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = controller.categories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(category.name, context),
                        const SizedBox(height: 8),
                        _buildGridCategories(category, context),
                      ],
                    );
                  },
                  childCount: controller.categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildGridCategories(Category category, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Prevents GridView scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display 2 items in a row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2, // Adjust as per your design needs
        ),
        itemCount: category.subTopics.length,
        itemBuilder: (context, index) {
          final topic = category.subTopics[index];
          return _buildTopicGridItem(topic, context);
        },
      ),
    );
  }

  Widget _buildTopicGridItem(SubTopic topic, BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.toggleSelection(topic);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceDim,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                topic.icon,
                size: 25,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    topic.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (topic.isSelected.value)
                Icon(
                  Icons.check_circle_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (topic.isLocked && !topic.isSelected.value)
                Icon(
                  Icons.lock_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomUnlockAllButton extends StatelessWidget {
  const CustomUnlockAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.to(() => FollowedTopicsPage());
        },
        icon: const Icon(Icons.lock_open),
        label: const Text('Unlock All'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff8965e9),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
