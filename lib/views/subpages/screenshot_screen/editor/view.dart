import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/constrants.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/txts_style_model.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/colors/controller.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/controller.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/pexels_images/controller.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/color_selector.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/controller.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/font_size_slider.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/horiz_alignment.dart';
import 'package:screenshot/screenshot.dart';

import 'colors/view.dart';
import 'pexels_images/bluer_selector.dart';
import 'textStyle/font_family_selector.dart';
import 'textStyle/text_case_selector.dart';

enum TxtStyleOption {
  color,
  vAlignment,
  hAlignment,
  fontFamily,
  fontSize,
  fontCase,
}

class QuoteEditorScreen extends StatelessWidget {
  final textController = Get.put(TextController());
  final Quote data;

  QuoteEditorScreen({
    super.key,
    required this.data,
  });
  final controller = Get.put(
    EditorController(),
  );

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomSheet(
          shape: const RoundedRectangleBorder(),
          elevation: 10,
          // backgroundColor: Colors.transparent,
          onClosing: () {},
          builder: (_) {
            return Obx(
              () => controller.showOptionsSheet.value
                  // ? _buildOptionsSheet(1)
                  ? _buildOptionsSheet()
                  : _buildMainSheet(),
            );
          }),
      appBar: AppBar(
        title: const Text('Edit Quote'),
        actions: [
          // Text(controller.photo.value?.src.medium.toString() ?? "sss"),
          TextButton(
            child: const Text('Share'),
            onPressed: () {
              controller.shareImage(context);
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              controller.saveImage(context);
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [],
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: BackgroundWidget(data: data)),
      ),
    );
  }

  // Main sheet with tabs and edit options
  Widget _buildMainSheet() {
    return SlideTransition(
      key: const ValueKey('MainSheet'),
      position: controller.mainSheetAnimation,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabBar(),
            const SizedBox(
              height: 16,
            ),
            Obx(() => controller.currentTabIndex.value == 0
                ? _buildTextStyleOptionRow() //Text Style Moduel
                : controller.currentTabIndex.value == 1
                    ? ColorsSelectors(
                        filters: colors,
                        onSave: () {},
                        onShare: () {},
                      ) //Media Style Moduel
                    : BlurImgSlider(
                        value: controller.backgroundBlur.value / 10,
                        label: "Opacity",
                        onChanged: (val) {
                          controller.onChangeBlurValue(val);
                        })), //Filters Style Moduel
          ],
        ),
      ),
    );
  }

  // New options sheet with slider and accept/cancel buttons
  Widget _buildOptionsSheet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          controller.selectedOption == TxtStyleOption.color
              ? ColorsSelector()
              : controller.selectedOption == TxtStyleOption.fontFamily
                  ? FontFamilySelector()
                  : controller.selectedOption == TxtStyleOption.hAlignment
                      ? HorizAlignmentSelector()
                      : controller.selectedOption == TxtStyleOption.fontSize
                          ? FontSizeSlider()
                          : controller.selectedOption == TxtStyleOption.fontCase
                              ? FontCaseSelector()
                              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.toggleSheet();
                  textController.clearSelection(controller.selectedOption);
                }, // Close the options sheet
              ),
              IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: controller.toggleSheet
                  // Save and close the options sheet
                  ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: controller.tabController,
      onTap: controller.onTapTab,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      dividerHeight: 0,
      tabs: const [
        Tab(icon: Icon(Icons.text_fields), text: 'Text'),
        Tab(icon: Icon(Icons.filter), text: 'Filters'),
        Tab(icon: Icon(Icons.image), text: 'Media'),
      ],
      indicatorColor: Colors.white,
    );
  }

  Widget _buildTextStyleOptionRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildEditOption(Icons.palette, 'Colors',
                () => controller.selectTextStyleOption(TxtStyleOption.color)),
            const SizedBox(
              width: 16,
            ),
            _buildEditOption(
                Icons.format_align_left,
                'Alignment',
                () => controller
                    .selectTextStyleOption(TxtStyleOption.hAlignment)),
            const SizedBox(
              width: 16,
            ),
            _buildEditOption(
                Icons.font_download,
                'Font Family',
                () => controller
                    .selectTextStyleOption(TxtStyleOption.fontFamily)),
            const SizedBox(
              width: 16,
            ),
            _buildEditOption(
                Icons.format_size,
                'Font Size',
                () =>
                    controller.selectTextStyleOption(TxtStyleOption.fontSize)),
            const SizedBox(
              width: 16,
            ),
            _buildEditOption(
                Icons.text_fields,
                'Font Case',
                () =>
                    controller.selectTextStyleOption(TxtStyleOption.fontCase)),
          ],
        ),
      ),
    );
  }

  Widget _buildEditOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.white),
          )),
          const SizedBox(height: 8),
          Text(
            label,
            style: Get.context!.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  final controller = Get.find<EditorController>();
  final textController = Get.find<TextController>();

  final Quote data;

  BackgroundWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller.screenshotController,
      child: Obx(() {
        return Stack(
          children: [
            _buildBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildTextWidget(
                      textStyleModel: textController.textStyleModel.value,
                      quote: data,
                      fontFamily:
                          textController.textStyleModel.value.fontFamily ??
                              controller.selectedTheme?.fontFamily),
                  // Watermark, visible only in screenshots
                  Obx(() {
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: controller.isTakingScreenshot.isTrue ? 1 : 0,
                      child: Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          margin:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          padding: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: context.theme.colorScheme.surface
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundImage: AssetImage(
                                  'assets/images/logo.jpeg',
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'MotivateMe',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBackground() {
    switch (controller.backgroundType?.value) {
      case BackgroundType.pexelsImage:
        return Obx(
          () => Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(Get.find<PexelsViewController>()
                            .photo!
                            .value
                            .src
                            .medium ??
                        ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: controller.backgroundBlur.value,
                  sigmaY: controller.backgroundBlur.value,
                ),
                child: Container(),
              ),
            ],
          ),
        );

      case BackgroundType.image:
        return Obx(
          () => Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(controller.selectedTheme?.url ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: controller.backgroundBlur.value,
                  sigmaY: controller.backgroundBlur.value,
                ),
                child: Container(),
              ),
            ],
          ),
        );
      case BackgroundType.solidColor:
        return Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: colors[Get.find<ColorsController>().page.value],
          ),
        );

      case BackgroundType.transperent: //no theme is selected
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: Get.context!.theme.colorScheme.surface,
        );
      case BackgroundType.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: controller.selectedTheme?.gradientColors ?? [],
            ),
          ),
        );
      default:
        return Container(color: Colors.white); // For video background
    }
  }
}

class BuildTextWidget extends StatelessWidget {
  final Quote quote;

  final TextStyleModel textStyleModel;
  final String? fontFamily;
  const BuildTextWidget(
      {super.key,
      required this.quote,
      required this.textStyleModel,
      required this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "❝",
            style: context.textTheme.displayLarge?.copyWith(
              color: context.theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            textCase(),
            textAlign: textStyleModel.textAlign ?? TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
                fontSize: textStyleModel.fontSize,
                color: textStyleModel.fontColor,
                fontFamily: fontFamily != null
                    ? GoogleFonts.getFont(fontFamily!).fontFamily!
                    : null),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                "- ${quote.author?[LocalizationService().currentLocaleString]}",
                style: context.textTheme.bodySmall?.copyWith(
                    color: textStyleModel.fontColor,
                    fontFamily: fontFamily != null
                        ? GoogleFonts.getFont(fontFamily!).fontFamily!
                        : null),
              )
            ],
          )
        ],
      ),
    );
  }

  String textCase() {
    final text = quote
            .languages?["${LocalizationService().currentLocaleString}"]?.text ??
        quote.text;
    switch (textStyleModel.fontCase ?? FontCase.titlecase) {
      case FontCase.lowercase:
        return text.toLowerCase();
      case FontCase.titlecase:
        return text;
      case FontCase.uppercase:
        return text.toUpperCase();
    }
  }
}
