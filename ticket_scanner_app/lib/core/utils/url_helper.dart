import 'dart:io';
import 'const.dart';

class UrlHelper {
  /// Normalizes image URLs to handle relative paths and emulator networking.
  static String normalize(String? url) {
    if (url == null || url.isEmpty) return '';

    String cleanedUrl = url;

    // Handle relative paths from Laravel Storage
    if (cleanedUrl.startsWith('/storage')) {
      cleanedUrl = "${Const.baseUrl}$cleanedUrl";
    } else if (cleanedUrl.startsWith('storage/')) {
      cleanedUrl = "${Const.baseUrl}/$cleanedUrl";
    }

    // Modernize localhost for Android Emulators
    if (Platform.isAndroid) {
      cleanedUrl = cleanedUrl.replaceAll('localhost', '10.0.2.2');
      cleanedUrl = cleanedUrl.replaceAll('127.0.0.1', '10.0.2.2');
    }

    return cleanedUrl;
  }
}
