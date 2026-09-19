import 'package:flutter/material.dart';
import 'package:frontend_userside/app/theme/dark_theme.dart';
import 'package:frontend_userside/app/theme/light_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => LightTheme.theme;
  static ThemeData get darkTheme => DarkTheme.theme;
}
