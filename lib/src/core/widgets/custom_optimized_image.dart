import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';

/// Optimized image widget for masonry grids and lists with lazy loading
/// Automatically calculates cache width based on screen size for better performance
class CustomOptimizedImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double padding;
  final double spacing;
  final int crossAxisCount;

  const CustomOptimizedImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.padding = 24,
    this.spacing = 12,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate approximate size based on screen width for cache optimization
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        (screenWidth - padding - spacing) /
        crossAxisCount; // padding + spacing / columns
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheWidth = (itemWidth * devicePixelRatio).round();

    return Image.asset(
      imagePath,
      fit: fit,
      width: width ?? double.infinity,
      height: height,
      cacheWidth: cacheWidth,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        // Show placeholder while loading
        return Container(
          color: Colors.grey.withOpacityValue(0.2),
          child: const Center(child: SizedBox(width: 20, height: 100)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.withOpacityValue(0.3),
          child: const Icon(Icons.broken_image_outlined, color: Colors.white54),
        );
      },
    );
  }
}
