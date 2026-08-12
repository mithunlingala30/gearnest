import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0F172A); // Dark Obsidian Slate
  static const Color accent = Color(0xFF06B6D4); // Electric Cyan / Cyber Teal
  static const Color accentLight = Color(0xFFE0F2FE); // Cyan Ice Light
  static const Color accentDark = Color(0xFF0284C7); // Deep Cyan Blue
  static const Color secondary = Color(0xFF6366F1); // Indigo Accent
  static const Color background = Color(0xFFF8FAFC); // Clean Slate Sky
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Soft Slate Box
  static const Color textPrimary = Color(0xFF0F172A); // Rich Dark Slate Text
  static const Color textSecondary = Color(0xFF64748B); // Muted Slate Text
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // ── Web Layout Dimensions ───────────────────────────────────────────────────
  static const double webBodyMaxWidth = 1280.0;
  static const double webSidebarWidth = 260.0;
  static const double webNavHeight = 72.0;
  static const Color webNavBg = Color(0xFF0F172A);
  static const Color webHoverCyan = Color(0x1406B6D4);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0E7490)],
  );

  // Soft Ambient Shadows
  static const List<BoxShadow> bubbleShadow = [
    BoxShadow(
      color: Color(0x1F0F172A),
      blurRadius: 16,
      spreadRadius: 1,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0xFFFFFFFF),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, -3),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 8,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.accent, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: AppColors.surface,
      ),
    );
  }
}
