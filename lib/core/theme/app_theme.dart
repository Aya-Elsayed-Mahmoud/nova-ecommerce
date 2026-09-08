import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

class AppTheme {
  static const String _themeKey = 'is_dark_mode';

  // ValueNotifier to trigger app rebuilds when theme changes
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  // Initialize theme status from SharedPreferences
  static Future<void> initTheme(SharedPreferences prefs) async {
    final isDark = prefs.getBool(_themeKey) ?? false;
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle theme state & persist to storage
  static Future<void> toggleTheme(bool isDark) async {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // ==========================================
  // Light Theme
  // ==========================================
  static ThemeData get lightTheme {
  return ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,

  // ضبط ألوان كل الزراير في الـ Light Mode (أسود والنص أبيض)
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  ),
  );
  }

  // ==========================================
  // Dark Theme
  // ==========================================
  static ThemeData get darkTheme {
  return ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),

  // ضبط ألوان كل الزراير في الـ Dark Mode (أبيض والنص أسود)
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  elevation: 0,
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),
  ),
  ),
  ),
  );
  }
  }
