import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Color Palette
  static const Color primary = Color(0xFF6366F1); // Modern Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF10B981); // Modern Green
  static const Color background = Color(0xFFF8FAFC); // Very Soft Off-White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFF1E293B); // Dark Slate
  static const Color textSecondary = Color(0xFF64748B); // Muted Slate

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme).copyWith(
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: textSecondary,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: textPrimary,
        centerTitle: true,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        color: surface,
        margin: EdgeInsets.zero,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primary,
        secondarySelectedColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
