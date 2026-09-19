import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  // Brand Palette - Vibrant Blue / Indigo for Dark Mode
  static const Color primary = Color(0xFF3B82F6); // Vibrant Blue
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF1E293B);
  static const Color primaryGlow = Color(0x333B82F6);

  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color secondaryLight = Color(0xFF312E81);

  static const Color accent = Color(0xFF38BDF8); // Sky

  // Deep Charcoal Canvas & Elevated Surfaces
  static const Color background = Color(0xFF090D16); // Deep Dark Canvas
  static const Color surface = Color(
    0xFF111827,
  ); // Dark Surface Card (Slate-900)
  static const Color surfaceElevated = Color(0xFF1E293B); // Slate-800 Elevated
  static const Color surfaceSecondary = Color(0xFF1E293B); // Slate-800

  // Text & Typography
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate-50 Pure Light
  static const Color textSecondary = Color(0xFF94A3B8); // Slate-400
  static const Color textMuted = Color(0xFF64748B); // Slate-500

  // Borders & Dividers
  static const Color border = Color(0xFF1E293B); // Slate-800 Border
  static const Color borderLight = Color(0xFF334155); // Slate-700
  static const Color borderFocused = Color(0xFF3B82F6);

  // Status & Feedback Colors
  static const Color success = Color(0xFF34D399); // Emerald Light
  static const Color successBg = Color(0x1A10B981);
  static const Color warning = Color(0xFFFBBF24); // Amber Light
  static const Color warningBg = Color(0x1AF59E0B);
  static const Color error = Color(0xFFF87171); // Rose Light
  static const Color errorBg = Color(0x1AEF4444);
  static const Color info = Color(0xFF60A5FA);
  static const Color infoBg = Color(0x1A3B82F6);

  static ThemeData get theme {
    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        outline: border,
        outlineVariant: borderLight,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.6,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.4,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: const BorderSide(color: borderLight, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderLight, width: 0.8),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }
}
