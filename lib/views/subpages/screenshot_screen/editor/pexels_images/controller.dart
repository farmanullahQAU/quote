import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/pexels_resp_model.dart';

import '../controller.dart';

class PexelsViewController extends GetxController {
  var photos = <Photo>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;
  Rx<Photo>? photo;

  RxString selectedImage = RxString("");

  final String apiKey =
      'Qw28p3A9gUJyFB6XZafDHkECyGg8VIkj9KgOE98uxPaDCptDTrHmWCuw';
  final String baseUrl = 'https://api.pexels.com/v1';

  Future<void> fetchPhotos({String query = '', bool loadMore = false}) async {
    if (!loadMore) {
      currentPage.value = 1;
      photos.clear();
    }

    if (isLoading.value || (!loadMore && !hasMore.value)) return;

    isLoading(true);
    try {
      var url = Uri.parse(
          '$baseUrl/search?query=${query.isEmpty ? 'nature' : Uri.encodeComponent(query)}&per_page=20&page=${currentPage.value}');
      var response = await http.get(url, headers: {'Authorization': apiKey});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var pexelsResponse = PexelsResponse.fromJson(data);

        var newPhotos = pexelsResponse.photos;

        if (loadMore) {
          photos.addAll(newPhotos);
        } else {
          photos.value = newPhotos;
        }

        currentPage.value++;
        hasMore.value = newPhotos.isNotEmpty;
      } else {
        Get.snackbar('Error', 'Failed to fetch photos: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void resetSearch() {
    photos.clear();
    currentPage.value = 1;
    hasMore.value = true;
  }

  selectImage(Photo photo) {
    if (this.photo != null) {
      this.photo?.value = photo;
    } else {
      this.photo = photo.obs;
    }
    Get.find<EditorController>().backgroundType?.value =
        BackgroundType.pexelsImage;
    Get.back();
  }
}
