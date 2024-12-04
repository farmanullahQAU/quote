import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/controller.dart';

class HorizAlignmentSelector extends StatelessWidget {
  final TextController textController = Get.find();
  HorizAlignmentSelector({super.key});

  final List<Icon> icons = [
    const Icon(Icons.format_align_left),
    const Icon(Icons.format_align_center),
    const Icon(Icons.format_align_justify_sharp),
    const Icon(Icons.format_align_right),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          // color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.map((e) {
          final index = icons.indexOf(e);
          return Obx(
            () => IconButton(
              isSelected:
                  textController.selectHorizAlignmentIndex.value == index,
              // selectedIcon: const Icon(Icons.abc),
              iconSize: 25,
              onPressed: () =>
                  textController.updateTextAlign(_textAlig(index), index),
              icon: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(),
                  child: e),
            ),
          );
        }).toList(),
      ),
    );
  }

  TextAlign _textAlig(int index) {
    switch (index) {
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.justify;
      case 3:
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}
