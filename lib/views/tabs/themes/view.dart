import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/generated/locales.g.dart';
import 'package:myapp/models/theme_item_model.dart';
import 'package:myapp/services/video_services/video_cont_manager.dart';
import 'package:myapp/views/tabs/themes/controller.dart';
import 'package:myapp/views/tabs/themes/more/view.dart';
import 'package:myapp/views/widets/cached_image.dart';
import 'package:myapp/views/widets/nodata.dart';
import 'package:video_player/video_player.dart';

class ThemesScreen extends StatelessWidget {
  final ThemesController themesController = Get.find();

  ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemesController>(
      autoRemove: true,
      id: 'themes',
      builder: (controller) {
        return Obx(
          () => RefreshIndicator(
            onRefresh: controller.fetchThemes,
            child: controller.isLoading.isTrue && controller.themes.isEmpty
                ? Center(child: const CircularProgressIndicator())
                : controller.themes.isEmpty
                    ? NoDataWidget(
                        onRetry: controller.fetchThemes,
                      )
                    : Scaffold(
                        body: controller.themes.isEmpty
                            ? _buildEmptyState()
                            : CustomScrollView(
                                slivers: [
                                  _buildSliverAppBar(controller, context),
                                  SliverToBoxAdapter(
                                    child: controller.isLoading.isTrue
                                        ? _buildLoadingState()
                                        : _buildThemesList(controller, context),
                                  ),
                                ],
                              ),
                      ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ThemesController controller, BuildContext context) {
    return SliverAppBar(
      // expandedHeight: 120,

      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(LocaleKeys.themes.tr,
            style: Get.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        // background: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         context.theme.colorScheme.primary.withOpacity(0.7),
        //         Colors.purple.withOpacity(0.2),
        //       ],
        //     ),
        //   ),
        // ),
      ),
      actions: [
        _buildUnlockButton(controller),
      ],
    );
  }

  Widget _buildUnlockButton(ThemesController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: controller.fetchThemes,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_open,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(LocaleKeys.unlock_all.tr,
                      style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(3, (index) => _buildLoadingItem()),
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: Get.width * 0.44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: Get.width * 0.3,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        height: Get.height - kBottomNavigationBarHeight,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Get.context!.theme.colorScheme.surfaceContainer),
                child: const Icon(
                  Icons.brush_outlined,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No themes available', //TODO
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: themesController.fetchThemes,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemesList(ThemesController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: controller.categoryLists.keys.map((category) {
          final themes = controller.categoryLists[category] ?? [];
          return _buildThemeSection(category, context, themes);
        }).toList(),
      ),
    );
  }

  Widget _buildThemeSection(
      String title, BuildContext context, List<ThemeItem> themes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, context),
        const SizedBox(height: 12),
        SizedBox(
          height: Get.width * 0.44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Hero(
                  tag: 'theme_${themes[index]}',
                  child: _buildThemeItem(themes[index], context),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withOpacity(0.2), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Get.to(() => MoreThemesScreen(), arguments: title);
            },
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: Text(
              LocaleKeys.view_all.tr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem(ThemeItem theme, BuildContext context) {
    return GestureDetector(
      onTap: () => themesController.onTapGradient(theme),
      child: Container(
        width: Get.width * 0.30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.2),
          //     blurRadius: 8,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildThemeContent(theme, context),
        ),
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
        CachedNetworkImageWidget(
          imageUrl: theme.url,
          fit: BoxFit.cover,
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
    return Container(
      child: Stack(
        children: [
          if (!theme.isFree)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.lock,
                color: Colors.white,
                size: 25,
                // shadows: [
                //   Shadow(
                //     color: Colors.black26,
                //     blurRadius: 2,
                //     offset: Offset(0, 1),
                //   ),
                // ],
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              LocaleKeys.abc.tr,
              style: GoogleFonts.getFont(
                color: theme.textColor,
                theme.fontFamily,
                fontSize: context.textTheme.titleMedium?.fontSize,
              ),
            ),
          ),
        ],
      ),
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
    return GestureDetector(
      onTap: () {
        Get.find<ThemesController>()
            .onTapGradient(widget.theme, vidController: _controller);
      },
      child: Stack(
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
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
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
      child: Stack(
        children: [
          if (!widget.theme.isFree)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.lock,
                color: Colors.white,
                size: 25,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              LocaleKeys.abc.tr,
              style: GoogleFonts.getFont(
                widget.theme.fontFamily,
                fontSize: context.textTheme.titleMedium?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
