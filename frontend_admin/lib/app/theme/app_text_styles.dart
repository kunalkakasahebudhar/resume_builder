import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle h1({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: fontWeight ?? FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle h2({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: fontWeight ?? FontWeight.w600,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle h3({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  static TextStyle titleMedium({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  static TextStyle titleSmall({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle caption({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
      );

  static TextStyle button({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Colors.white,
      );

  static TextStyle label({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color,
      );

  static TextStyle badge({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
      );
}
