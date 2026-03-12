import 'package:flutter/painting.dart';

/// Configure image cache for better performance
class ImageCacheConfig {
  static void configure() {
    // Increase image cache size for better performance
    // Default is 100MB, we set to 200MB for more cached images
    PaintingBinding.instance.imageCache.maximumSizeBytes = 200 * 1024 * 1024;

    // Increase max number of cached images
    // Default is 1000, we set to 500 to balance memory and cache hits
    PaintingBinding.instance.imageCache.maximumSize = 500;
  }

  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
