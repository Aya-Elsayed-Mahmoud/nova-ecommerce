// main.dart
// ⚠️ نقطة تشغيل تجريبية للاختبار المستقل فقط.
// عند الدمج مع المشروع الأصلي، استخدم main.dart بتاع الفريق، وفقط
// استورد منه TempHomeScreen (أو مباشرة ProfileScreen) في المكان المناسب
// من الـ Navigation الأساسي (مثلاً داخل الـ Bottom Nav الحقيقي).

import 'package:flutter/material.dart';
import 'temp_home_screen.dart';
import 'theme/nova_theme.dart';

void main() {
  runApp(const NovaProfileTestApp());
}

class NovaProfileTestApp extends StatelessWidget {
  const NovaProfileTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVA - Profile Module (Test)',
      debugShowCheckedModeBanner: false,
      theme: buildNovaTheme(),
      home: const TempHomeScreen(),
    );
  }
}
