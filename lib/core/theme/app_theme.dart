import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primaryBackground,
  );

  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}
