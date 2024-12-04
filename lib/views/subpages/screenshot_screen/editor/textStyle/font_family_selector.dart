import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/constrants.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/controller.dart';

class FontFamilySelector extends StatelessWidget {
  final textStyleController = Get.find<TextController>();

  FontFamilySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      // tabAlignment: TabAlignment.center,
      controller: textStyleController.fontFamilysTabController,
      onTap: textStyleController.updateFontFamily,
      indicator: const BoxDecoration(),
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      isScrollable: true,
      tabs: fontFamilies.map((font) {
        return Tab(
          child: Text(
            font,
            style: GoogleFonts.getFont(font),
          ),
        );
      }).toList(),
    );
  }
}
