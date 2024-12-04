import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.high,
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) =>
            placeholder ??
            const Center(
              child: CircularProgressIndicator(),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
      ),
    );
  }
}
