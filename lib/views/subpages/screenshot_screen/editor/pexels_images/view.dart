import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:myapp/views/tabs/ai/view.dart';

import 'controller.dart';
import 'photographer_profile/view.dart';

class PexelsView extends StatelessWidget {
  final PexelsViewController controller =
      Get.put(PexelsViewController(), permanent: true);
  final TextEditingController searchController = TextEditingController();

  PexelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pexels Image Search',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for images...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    // controller.resetSearch();
                    // controller.fetchPhotos(query: '');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                // fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                controller.resetSearch();
                controller.fetchPhotos(query: value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.photos.isEmpty) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                  child: TypingIndicator(
                    showIndicator: true,
                  ),
                ));
              } else if (controller.photos.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No images found',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.resetSearch();
                    await controller.fetchPhotos(query: searchController.text);
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        if (controller.hasMore.value &&
                            !controller.isLoading.value) {
                          controller.fetchPhotos(
                              query: searchController.text, loadMore: true);
                        }
                      }
                      return true;
                    },
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: controller.photos.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.photos.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final photo = controller.photos[index];
                        return GestureDetector(
                          onTap: () => controller.selectImage(photo),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  child: CachedNetworkImage(
                                    imageUrl: photo.src.medium,
                                    placeholder: (context, url) => AspectRatio(
                                      aspectRatio: photo.width / photo.height,
                                      child: Container(color: Colors.grey[300]),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => PhotographerProfileView(
                                          photographerName: photo.photographer,
                                          photographerUrl:
                                              photo.photographerUrl,
                                          profileImageUrl:
                                              photo.photographerUrl,
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      photo.photographer,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: context
                                                  .textTheme.bodySmall?.color),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
