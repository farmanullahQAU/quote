import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/views/subpages/screenshot_screen/view.dart';
import 'package:myapp/views/tabs/home/view.dart';
import 'package:myapp/views/widets/error_widget.dart';
import 'package:myapp/views/widets/nodata.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

import '../../../widets/cached_image.dart';
import 'controller.dart';

class FilteredQuotesView extends StatelessWidget {
  final controller = Get.put(QuotesController());
  FilteredQuotesView({super.key});
  final GlobalKey homeGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: controller.screenshotController,
        child: RepaintBoundary(
          key: homeGlobalKey,
          child: Stack(
            children: [
              Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: controller.selectedtheme.value != null
                        ? controller.selectedtheme.value?.themeType ==
                                "image" //image as background to quote
                            ? _buildImageBackground()
                            : controller.selectedtheme.value?.themeType ==
                                    "video"
                                ? _buildVideoBackground() //video as background to qoute. (select theme is qoute from backend)
                                : controller.selectedtheme.value?.themeType ==
                                        "colors"
                                    ? //theme type is gradient from backend
                                    Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                colors: controller.selectedtheme
                                                    .value!.gradientColors)),
                                      )
                                    : const SizedBox()
                        : const SizedBox(),
                  )),
              SafeArea(
                child: Center(
                  child: Obx(() => controller.isLoading.isTrue
                      ? const CircularProgressIndicator()
                      : controller.errorString.isNotEmpty
                          ? MyErrorWidget(
                              errorMessage: controller.errorString.value,
                              onRetry: controller.fetchQuotes,
                            )
                          : controller.quotes.isEmpty
                              ? NoDataWidget(
                                  onRetry: controller.fetchQuotes,
                                )
                              : Container(
                                  // color: Colors.red,
                                  child: ListWheelScrollView(
                                    itemExtent: Get.height,
                                    diameterRatio: 3,
                                    physics: const FixedExtentScrollPhysics(),
                                    children:
                                        controller.quotes.toList().map((quote) {
                                      return QuoteItem(
                                        selectedTheme:
                                            controller.selectedtheme.value,
                                        data: quote,
                                        onShare: () {
                                          Get.to(() => ScreenshotScreen(
                                              selectedtheme: controller
                                                  .selectedtheme.value,
                                              data: quote));
                                        },
                                        onSave: () {
                                          // controller.downlaod(
                                          //   key: homeGlobalKey,
                                          //   quoteText: quote.text,
                                          //   context: context),
                                        },
                                        onLikeDislike: () => controller
                                            .copyToClipboard(quote.text),
                                      );
                                    }).toList(),
                                  ),
                                )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBackground() {
    return SizedBox.expand(
      child: FittedBox(
          fit: BoxFit.cover,
          child: CachedNetworkImageWidget(
              imageUrl: controller.selectedtheme.value!.url)),
    );
  }

  Widget _buildVideoBackground() {
    return Obx(() => SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.videoController?.value.size.width,
              height: controller.videoController?.value.size.height,
              child: VideoPlayer(controller.videoController!),
            ),
          ),
        ));
  }
}
