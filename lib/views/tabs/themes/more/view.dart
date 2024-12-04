import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/video_services/video_cont_manager.dart';
import 'package:myapp/views/tabs/themes/more/controller.dart';
import 'package:myapp/views/widets/nodata.dart';
import 'package:video_player/video_player.dart';

class MoreThemesScreen extends StatelessWidget {
  final themesController = Get.put(MoreThemesController());

  MoreThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoreThemesController>(
      autoRemove: false,
      id: 'themes',
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                await controller.fetchThemes(loadMore: true);
              },
              child: controller.isLoading.isTrue && controller.themes.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : controller.themes.isEmpty
                      ? NoDataWidget(
                          onRetry: controller.fetchThemes,
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification) {
                              final metrics = notification.metrics;
                              if (metrics.pixels >=
                                  metrics.maxScrollExtent - 200) {
                                controller.loadNextPage();
                              }
                            }
                            return true;
                          },
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                  expandedHeight: 100.0,
                                  pinned: false,
                                  backgroundColor: const Color(
                                      0xff0cc0df), // Primary branding color
                                  flexibleSpace: FlexibleSpaceBar(
                                    title: Text(
                                      controller.category ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4.0,
                                            color: Colors.black26,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    centerTitle: true,
                                    background: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Add a gradient background
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(
                                                    0xff8965e9), // PrimaryColor2
                                                Get.context!.theme.colorScheme
                                                    .primary
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Add branding accent (e.g., an image, logo, or pattern)
                                        Positioned(
                                          top: 20,
                                          right: 20,
                                          child: Opacity(
                                            opacity: 0.2,
                                            child: Icon(
                                              Icons.auto_awesome,
                                              size: 100,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SliverPadding(
                                padding: const EdgeInsets.all(16),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.75,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final theme = controller.themes[index];
                                      return _buildThemeItem(theme, context);
                                    },
                                    childCount: controller.themes.length,
                                  ),
                                ),
                              ),
                              if (controller.isLoading.isTrue)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeItem(ThemeItem theme, BuildContext context) {
    return GestureDetector(
      onTap: () => themesController.onTapGradient(theme),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildThemeContent(theme, context),
      ),
    );
  }

  Widget _buildThemeContent(ThemeItem theme, BuildContext context) {
    switch (theme.themeType) {
      case "video":
        return AnimatedVideoThumbnail(theme: theme);
      case "image":
        return _buildImageContent(theme, context);
      default:
        return _buildGradientContent(theme, context);
    }
  }

  Widget _buildImageContent(ThemeItem theme, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          theme.url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            );
          },
        ),
        _buildOverlayContent(theme, context),
      ],
    );
  }

  Widget _buildGradientContent(ThemeItem theme, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
        ),
      ),
      child: _buildOverlayContent(theme, context),
    );
  }

  Widget _buildOverlayContent(ThemeItem theme, BuildContext context) {
    return Stack(
      children: [
        if (!theme.isFree)
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.lock,
              color: Colors.white,
              size: 25,
            ),
          ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Text(
            LocaleKeys.abc.tr,
            style: GoogleFonts.getFont(
              theme.fontFamily,
              fontSize: context.textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedVideoThumbnail extends StatefulWidget {
  final ThemeItem theme;

  const AnimatedVideoThumbnail({super.key, required this.theme});

  @override
  _AnimatedVideoThumbnailState createState() => _AnimatedVideoThumbnailState();
}

class _AnimatedVideoThumbnailState extends State<AnimatedVideoThumbnail> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoControllerManager().getController(widget.theme.url);
    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        else
          _buildLoadingIndicator(),
        _buildVideoOverlay(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildVideoOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
    );
  }
}
