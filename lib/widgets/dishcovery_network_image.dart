import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DishcoveryNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Duration fadeInDuration;
  final BorderRadius? borderRadius;

  const DishcoveryNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 180),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: const Duration(milliseconds: 120),
      placeholder: (context, url) => const DishcoveryImagePlaceholder(),
      errorWidget: (context, url, error) => const DishcoveryImageFallback(),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class DishcoveryImagePlaceholder extends StatelessWidget {
  const DishcoveryImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(Color(0xFF059669)),
          ),
        ),
      ),
    );
  }
}

class DishcoveryImageFallback extends StatelessWidget {
  const DishcoveryImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.restaurant_menu, size: 40, color: Color(0xFF047857)),
            SizedBox(height: 10),
            Text(
              'Dishcovery Recipe',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF065F46),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Image unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF047857), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
