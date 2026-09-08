// nova_theme.dart
// ملف مركزي لكل ألوان وثوابت تصميم شاشات NOVA
// (لو حبيت تغيّر أي لون في المشروع كله، غيّره من هنا فقط)

import 'package:flutter/material.dart';

class NovaColors {
  static const Color background = Colors.white;
  static const Color cardBackground = Color(0xFFF7F7F8);
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color secondaryText = Color(0xFF8A8A8E);
  static const Color divider = Color(0xFFE8E8EA);
  static const Color logoutRed = Color(0xFFB3261E); // أحمر داكن للـ Logout فقط
  static const Color iconColor = Color(0xFF5C5C60);
}

class NovaRadius {
  static const double card = 16.0;
  static const double button = 12.0;
}

class NovaTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: NovaColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  static const TextStyle userName = TextStyle(
    color: NovaColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle userEmail = TextStyle(
    color: NovaColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sectionHeader = TextStyle(
    color: NovaColors.secondaryText,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle listItem = TextStyle(
    color: NovaColors.primaryText,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}

ThemeData buildNovaTheme() {
  return ThemeData(
    scaffoldBackgroundColor: NovaColors.background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: NovaColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: NovaColors.primaryText),
      titleTextStyle: NovaTextStyles.appBarTitle,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: NovaColors.primaryText,
      background: NovaColors.background,
    ),
    useMaterial3: true,
  );
}
