import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/controller.dart';

class FontSizeSlider extends StatelessWidget {
  final TextController controller = Get.find();

  FontSizeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Slider(
        value: controller.currentFontSize.value,
        max: 25,
        min: 8,
        divisions: 10,
        label: controller.currentFontSize.value.round().toString(),
        onChanged: controller.updateFontSize));
  }
}
