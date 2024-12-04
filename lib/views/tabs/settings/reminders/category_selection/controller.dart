import 'package:get/get.dart';
import 'package:myapp/constrants.dart';
import 'package:myapp/models/topics.dart';

class ReminderCategorySelectionController extends GetxController {
  late final RxList<Category> categories;

  List<String> remindersTitles = [];

  @override
  void onInit() {
    remindersTitles = Get.arguments;
    categories = topics.obs;
    super.onInit();
  }
}
