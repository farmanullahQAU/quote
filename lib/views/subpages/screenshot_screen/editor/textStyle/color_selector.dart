// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:myapp/constrants.dart';

// import 'controller.dart';

// class ColorsSelector extends StatelessWidget {
//   final colorController = Get.put(ColorsSelectorController());

//   ColorsSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ColorsSelectorController>(builder: (controller) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TabBar(
//             labelPadding: const EdgeInsets.symmetric(horizontal: 8),
//             indicatorPadding: EdgeInsets.zero,
//             dividerHeight: 0,
//             controller: colorController.tabController,
//             isScrollable: true,
//             tabAlignment: TabAlignment.start,
//             tabs: colors.map((color) {
//               // final index = colors.indexOf(color);
//               return _buildColorTab(color, controller, borderColor: color);
//             }).toList(),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _buildColorTab(Color color, ColorsSelectorController controller,
//       {required Color borderColor}) {
//     return Obx(
//       () => Tab(
//         child: Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: borderColor,
//                 width: 0.5,
//               ),
//             ),
//             child: controller.selectedColor.value == color
//                 ? Container(
//                     margin: const EdgeInsets.all(1),
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                       border: Border.all(width: 1.5),
//                     ),
//                   )
//                 : null),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/constrants.dart';

import 'controller.dart';

class ColorsSelector extends StatelessWidget {
  final TextController textController = Get.find<TextController>();

  ColorsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find to retrieve the controller, assuming it was already initialized

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Observe changes in the selected color
        TabBar(
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          controller: textController.colorsTabController,
          indicatorPadding: EdgeInsets.zero,
          isScrollable: true,
          onTap: textController.updateFontColor,
          tabs: _buildColorTabs(textController, context),
          dividerHeight: 0,
          // indicator: const BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(color: Colors.transparent, width: 0),
          //   ),
          // ),
        ),
      ],
    );
  }

  // Helper method to generate the color tabs
  List<Widget> _buildColorTabs(
      TextController controller, BuildContext context) {
    return colors.map((color) {
      return Tab(
        child: Obx(
          () => Container(
            width: Get.width * 0.06,
            height: Get.width * 0.06,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              // border: Border.all(
              //   color: color == controller.textStyleModel.value.fontColor?.value
              //       ? Colors.black
              //       : Colors.transparent,
              //   width: 2,
              // ),
            ),
            // Only show the inner circle if the color is selected
            child: controller.selectedColor.value == color
                ? Center(
                    child: Container(
                      width: Get.width * 0.03,
                      height: Get.width * 0.03,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      );
    }).toList();
  }
}
