import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/controller.dart';

enum FontCase { uppercase, lowercase, titlecase }

class FontCaseSelector extends StatelessWidget {
  final TextController textController = Get.find();

  final List<Map<String, dynamic>> cases = [
    {
      "value": "Aa",
      "case": FontCase.titlecase,
    },
    {
      "value": "aa",
      "case": FontCase.lowercase,
    },
    {
      "value": "AA",
      "case": FontCase.uppercase,
    },
  ];
  final TextController controller = Get.find();

  FontCaseSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cases.map((tCase) {
          return Obx(() => Tooltip(
                message: tCase['value'],
                child: IconButton(
                  isSelected: controller.selectedCase.value == tCase['case'],
                  icon: Text(
                    tCase['value'],
                    style: context.textTheme.titleMedium?.copyWith(
                        color: controller.selectedCase.value == tCase['case']
                            ? context.theme.colorScheme.primary
                            : context.textTheme.bodySmall?.color),
                  ),
                  onPressed: () {
                    controller.updateTextCase(tCase['case']);
                  },
                ),
              ));
        }).toList());
  }
}
