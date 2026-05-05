import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  static String _resolveBaseUrl() {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override;
    }

    if (kIsWeb) {
      return 'http://localhost:8082';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8082';
      default:
        return 'http://localhost:8082';
    }
  }

  /// Build full image URL from relative or absolute path
  static String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // If it's a relative path starting with /api, prepend base URL
    if (imagePath.startsWith('/api/')) {
      final baseUrl = _resolveBaseUrl();
      return '$baseUrl$imagePath';
    }

    // For any other path, assume it needs the base URL
    final baseUrl = _resolveBaseUrl();
    if (imagePath.startsWith('/')) {
      return '$baseUrl$imagePath';
    }
    return '$baseUrl/$imagePath';
  }
}
