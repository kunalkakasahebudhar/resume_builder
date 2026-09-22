import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle h1({Color? color}) => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle h3({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textSecondaryLight,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textMutedLight,
  );

  static TextStyle button({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textSecondaryLight,
  );

  static TextStyle badge({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: color,
  );
}
