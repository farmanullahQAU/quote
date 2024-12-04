import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ColorsSelectors extends StatelessWidget {
  final ColorsController controller = Get.put(ColorsController());
  final List<Color> filters;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final EdgeInsets padding;

  ColorsSelectors({
    super.key,
    required this.filters,
    required this.onSave,
    required this.onShare,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
  }) {
    Get.put(ColorsController());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.width * 0.24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.onPageChanged(index);
                },
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return _buildCarouselItem(constraints, index);
                },
              );
            },
          ),
          _buildSelectionRing(context),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BoxConstraints constraints, int index) {
    final itemSize =
        constraints.maxWidth * ColorsController.viewportFractionPerItem;
    return Center(
      child: AnimatedBuilder(
        animation: controller.pageController,
        builder: (context, child) {
          double value = 1.0;
          if (controller.pageController.position.haveDimensions) {
            value = controller.pageController.page! - index;
            value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
          }
          return SizedBox(
            width: Tween<double>(begin: itemSize * 0.8, end: itemSize)
                .transform(value),
            height: Tween<double>(begin: itemSize * 0.8, end: itemSize)
                .transform(value),
            child: child,
          );
        },
        child: Item(
          color: filters[index],
          // gradient: Get.find<QuoteEditController>().gradients[index],
          onFilterSelected: () => controller.animateToPage(index),
        ),
      ),
    );
  }

  Widget _buildSelectionRing(BuildContext context) {
    final itemSize = MediaQuery.of(context).size.width *
        ColorsController.viewportFractionPerItem;
    return IgnorePointer(
      child: Container(
        width: itemSize,
        height: itemSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: context.theme.colorScheme.primary, width: 3),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Color color;
  final VoidCallback? onFilterSelected;
  // final LinearGradient gradient;

  const Item({
    super.key,
    required this.color,
    this.onFilterSelected,
    // required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ClipOval(
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
