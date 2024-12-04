import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/subpages/screenshot_screen/view.dart';
import 'package:myapp/views/subpages/topics/view.dart';
import 'package:myapp/views/widets/cached_image.dart';
import 'package:myapp/views/widets/nodata.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

import '../../subpages/sound_cont/view.dart';
import 'controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final GlobalKey homeGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 0,
        children: [
          FloatingActionButton(
            heroTag: "topics",
            mini: true,
            onPressed: () => Get.to(() => ExploreTopicsPage()),
            child: const Icon(Icons.data_thresholding_rounded),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'voice',
            mini: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SoundSheet(),
              );
            },
            child: const Icon(Icons.record_voice_over_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'edit',
            mini: true,
            onPressed: () {
              controller.navigateToEditView();
            },
            child: const FaIcon(FontAwesomeIcons.penToSquare),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Center(
              child: controller.isLoading.isTrue && controller.quotes.isEmpty
                  ? const CircularProgressIndicator()
                  : controller.quotes.isEmpty
                      ? NoDataWidget(
                          onRetry: controller.fetchQuotes,
                        )
                      : Screenshot(
                          controller: controller.screenshotController,
                          child: Stack(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 1000),
                                child: controller.selectedTheme.value != null
                                    ? controller.selectedTheme.value
                                                ?.themeType ==
                                            "image"
                                        ? _buildImageBackground()
                                        : controller.selectedTheme.value
                                                    ?.themeType ==
                                                "video"
                                            ? _buildVideoBackground()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    colors: controller
                                                        .selectedTheme
                                                        .value!
                                                        .gradientColors,
                                                  ),
                                                ),
                                              )
                                    : SizedBox.expand(
                                        child: ColoredBox(
                                            color: context
                                                .theme.colorScheme.surface),
                                      ),
                              ),
                              SafeArea(
                                child: Center(
                                  child:
                                      NotificationListener<ScrollNotification>(
                                    onNotification: (notification) {
                                      if (notification
                                          is ScrollEndNotification) {
                                        final metrics = notification.metrics;
                                        if (metrics.pixels >=
                                            metrics.maxScrollExtent - 200) {
                                          controller.loadNextPage();
                                        }
                                      }
                                      return true;
                                    },
                                    child: Stack(
                                      children: [
                                        ListWheelScrollView(
                                          itemExtent: context.height,
                                          diameterRatio: RenderListWheelViewport
                                              .defaultDiameterRatio,
                                          physics:
                                              const FixedExtentScrollPhysics(),
                                          onSelectedItemChanged:
                                              controller.setCurrentQuoteIndex,
                                          children: controller.quotes
                                              .toList()
                                              .map((quote) {
                                            return QuoteItem(
                                              selectedTheme: controller
                                                  .selectedTheme.value,
                                              data: quote,
                                              onShare: () {
                                                Get.to(() => ScreenshotScreen(
                                                    selectedtheme: controller
                                                        .selectedTheme.value,
                                                    data: quote));
                                              },
                                              onSave: () => controller.download(
                                                  quoteText: quote.text,
                                                  context: context),
                                              onLikeDislike: () => controller
                                                  .likeDislikeQuote(quote),
                                            );
                                          }).toList(),
                                        ),
                                        // Loading indicator for pagination
                                        if (controller.isLoading.isTrue &&
                                            controller.quotes.isNotEmpty)
                                          Positioned(
                                            bottom: 20,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
            if (controller.favQuotes.isNotEmpty)
              Positioned(
                top: 0,
                right: 16,
                child: SafeArea(
                  child: IconButton(
                    onPressed: controller.gotoFavQuotePage,
                    icon: const Icon(
                      Icons.favorite,
                      size: 40,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBackground() {
    return SizedBox.expand(
      child: FittedBox(
          fit: BoxFit.fitHeight,
          child: CachedNetworkImageWidget(
            imageUrl: controller.selectedTheme.value!.url,
          )),
    );
  }

  Widget _buildVideoBackground() {
    return Obx(() => controller.isVideoInitialized.value
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.videoController?.value.size.width,
                height: controller.videoController?.value.size.height,
                child: VideoPlayer(controller.videoController!),
              ),
            ),
          )
        : Container(color: Colors.black));
  }
}

class QuoteItem extends StatelessWidget {
  final Quote data;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onLikeDislike;

  final ThemeItem? selectedTheme;

  const QuoteItem(
      {super.key,
      required this.data,
      required this.onShare,
      required this.onSave,
      required this.onLikeDislike,
      required this.selectedTheme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuoteCard(context),
            const SizedBox(height: 16),
            _buildActionButtons(data),
          ],
        ),
      ],
    ).animate().fade(duration: 500.ms);
  }

  Widget _buildQuoteCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          selectedTheme != null
              ? Text(
                  data
                          .languages?[
                              "${LocalizationService().currentLocaleString}"]
                          ?.text
                          .toString() ??
                      data.text,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                      fontFamily:
                          GoogleFonts.getFont("${selectedTheme?.fontFamily}")
                              .fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: selectedTheme?.textColor),
                )
              : Text(
                  data
                          .languages?[
                              "${LocalizationService().currentLocaleString}"]
                          ?.text
                          .toString() ??
                      data.text,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
          const SizedBox(height: 16),
          selectedTheme != null
              ? Text(
                  "- ${data.author?[LocalizationService().currentLocaleString]}",
                  style: context.textTheme.bodySmall?.copyWith(
                      fontFamily:
                          GoogleFonts.getFont("${selectedTheme?.fontFamily}")
                              .fontFamily,
                      fontStyle: FontStyle.normal,
                      color: selectedTheme?.textColor),
                )
              : Text(
                  "- ${data.author?[LocalizationService().currentLocaleString]}",
                  style: context.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.normal,
                    // color: context.theme.colorScheme.primary,
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildActionButtons(Quote quote) {
    return Obx(
      () => Get.find<HomeController>().hideButtons.isTrue
          ? _waterMark()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconButton(FontAwesomeIcons.share, onShare, 'Fav'),
                _buildIconButton(
                    quote.isFavorite.isTrue
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onLikeDislike,
                    'Like'),

                // const SizedBox(width: 32),
                _buildIconButton(FontAwesomeIcons.download, onSave, 'Save'),
                // const SizedBox(width: 32),
                // _buildIconButton(FontAwesomeIcons.copy, onCopy, 'Copy'),
              ],
            ),
    );
  }

  Widget _waterMark() {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundImage: AssetImage(
              'assets/images/logo.png',
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
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, String label) {
    return Column(
      children: [
        MaterialButton(
          shape: const CircleBorder(),
          // padding: EdgeInsets.zero,

          key: Key(label),
          onPressed: onPressed,
          child: FaIcon(
            icon,
            size: 30,
            // color: selectedTheme != null ? Colors.white : null,
          ),
          // style: IconButton.styleFrom(
          //     backgroundColor: Colors.white.withOpacity(0.1),
          //     padding: const EdgeInsets.all(0),
          //     side: BorderSide.none),
        ),
        // const SizedBox(height: 8),
        // Text(
        //   label,
        //   style: GoogleFonts.lato(
        //     textStyle: TextStyle(
        //       fontSize: 12,
        //       color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
        //     ),
        //   ),
        // ),
      ],
    ).animate().scale(duration: 300.ms, curve: Curves.easeInOut);
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildExpandingActionButtons(),

        //tap to close button

        //floating action button tap to open button

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: _open
              ? FloatingActionButton(
                  backgroundColor: context.theme.colorScheme.errorContainer,
                  mini: true,
                  shape: const CircleBorder(),
                  onPressed: _toggle,
                  child: const Icon(Icons.close),
                )
              : FloatingActionButton(
                  elevation: 0,
                  // mini: true,
                  onPressed: _toggle,
                  child: const Icon(Icons.add),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return Transform.rotate(
          angle: (1.0 - progress.value) * math.pi / 2,
          child: child!,
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
