import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/subpages/screenshot_screen/controller.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/view.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotScreen extends StatefulWidget {
  final ThemeItem? selectedtheme;
  final Quote data;

  const ScreenshotScreen({
    super.key,
    required this.selectedtheme,
    required this.data,
  });

  @override
  _ScreenshotScreenState createState() => _ScreenshotScreenState();
}

class _ScreenshotScreenState extends State<ScreenshotScreen>
    with SingleTickerProviderStateMixin {
  final ShareController _shareController = Get.put(ShareController());

  // Animation controller for bottom bar slide-up effect
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isShareActionsVisible = true; // Initially visible

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start outside of view (bottom)
      end: const Offset(0, 0), // End at normal position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Automatically show the bottom bar animation when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward(); // Slide up when the page is loaded
    });
  }

  void _toggleShareActions() {
    setState(() {
      _isShareActionsVisible = !_isShareActionsVisible;
      if (_isShareActionsVisible) {
        _animationController.forward(); // Slide up
      } else {
        _animationController.reverse(); // Slide down
      }
    });
  }

  void _navigateToNextPage() {
    Get.off(
        () => QuoteEditorScreen(
              data: widget.data,
            ),
        arguments: widget.selectedtheme,
        transition: Transition.fadeIn);
  }

  void _navigateToPreviousPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              // Swipe up for the next page
              if (details.primaryDelta! < -10) {
                _navigateToNextPage();
              } else if (details.primaryDelta! > 10) {
                _navigateToPreviousPage();
              }
            },
            onTap: _toggleShareActions, // Toggle bottom bar on tap
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  // height: !_isShareActionsVisible
                  //     ? Get.height * 0.9
                  //     : Get.height * 0.65,
                  height: Get.height,
                  // width: !_isShareActionsVisible ? Get.width : Get.width * 0.8,
                  width: Get.width,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Screenshot(
                      controller: _shareController.screenshotController,
                      child: Stack(
                        children: [
                          widget.selectedtheme?.themeType == "image"
                              ? Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              widget.selectedtheme?.url ??
                                                  ""))),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildQuoteCard(context),
                                      _waterMark(context),
                                    ],
                                  )))
                              : widget.selectedtheme?.themeType == "colors"
                                  ? Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          colors: widget.selectedtheme
                                                  ?.gradientColors ??
                                              [],
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildQuoteCard(context),
                                            _waterMark(context),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox.expand(
                                      child: ColoredBox(
                                        color:
                                            context.theme.colorScheme.surface,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildQuoteCard(context),
                                            _waterMark(context),
                                          ],
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
                ActionsWidget(
                    slideAnimation: _slideAnimation,
                    animationController: _animationController,
                    widget: widget,
                    shareController: _shareController),
              ],
            ),
          ),
          const SafeArea(child: Positioned(top: 0, child: CloseButton()))
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   "❝",
          //   style: context.textTheme.displayLarge?.copyWith(
          //     color: context.theme.colorScheme.primary.withOpacity(0.5),
          //   ),
          // ),
          // const SizedBox(height: 24),
          widget.selectedtheme != null
              ? Text(
                  widget
                          .data
                          .languages?[
                              "${LocalizationService().currentLocaleString}"]
                          ?.text ??
                      widget.data.text,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontFamily: GoogleFonts.getFont(
                            "${widget.selectedtheme?.fontFamily}")
                        .fontFamily,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                )
              : Text(
                  widget
                          .data
                          .languages?[
                              "${LocalizationService().currentLocaleString}"]
                          ?.text ??
                      widget.data.text,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
          const SizedBox(height: 16),
          widget.selectedtheme != null
              ? Text(
                  "- ${widget.data.author?[LocalizationService().currentLocaleString]}",
                  style: context.textTheme.bodySmall?.copyWith(
                    fontFamily: GoogleFonts.getFont(
                            "${widget.selectedtheme?.fontFamily}")
                        .fontFamily,
                    fontStyle: FontStyle.normal,
                  ),
                )
              : Text(
                  "- ${widget.data.author?[LocalizationService().currentLocaleString]}",
                  style: context.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.normal,
                    // color: context.theme.colorScheme.primary,
                  ),
                )
        ],
      ),
    );
  }

  Obx _waterMark(BuildContext context) {
    return Obx(() {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _shareController.isTakingScreenshot.isTrue ? 1 : 0,
        child: Container(
          margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
          padding: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 8,
                backgroundImage: AssetImage(
                  'assets/images/logo.jpeg',
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'MotivateMe',
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({
    super.key,
    required Animation<Offset> slideAnimation,
    required AnimationController animationController,
    required this.widget,
    required ShareController shareController,
  })  : _slideAnimation = slideAnimation,
        _animationController = animationController,
        _shareController = shareController;

  final Animation<Offset> _slideAnimation;
  final AnimationController _animationController;
  final ScreenshotScreen widget;
  final ShareController _shareController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _animationController,
          child: // Background of bottom bar
              // padding: const EdgeInsets.symmetric(vertical: 10),
              SafeArea(
            child: Container(
              width: double.infinity,
              color: context.theme.colorScheme.surfaceDim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.ios_share_outlined,
                            fill: 1,
                            size: 30,
                          ),
                          onPressed: () {
                            _shareController.shareImage(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_note_outlined,
                            fill: 1,
                            size: 30,
                          ),
                          onPressed: () {
                            Get.off(
                                () => QuoteEditorScreen(
                                      data: widget.data,
                                    ),
                                arguments: widget.selectedtheme,
                                transition: Transition.fadeIn);
                          },
                        ),
                        // IconButton(
                        //   icon: const Icon(
                        //     Icons.favorite_border_outlined,
                        //     fill: 1,
                        //     size: 30,
                        //   ),
                        //   onPressed: _shareController.addToCollection,
                        // ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy_outlined,
                            size: 30,
                          ),
                          onPressed: () =>
                              _shareController.copyQuote(widget.data.text),
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.save_alt,
                              size: 30,
                            ),
                            onPressed: () =>
                                _shareController.saveImage(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
